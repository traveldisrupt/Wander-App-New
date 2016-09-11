//
//  ViewController.m
//  Wander-App
//
//  Created by Adhyam Nagarajan, Padmaja on 9/10/16.
//  Copyright © 2016 Adhyam Nagarajan, Padmaja. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <CLLocationManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.distanceFilter = kCLDistanceFilterNone;
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  
  if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    [self.locationManager requestWhenInUseAuthorization];
  }
  [self.locationManager startUpdatingLocation];
  
  
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  CLLocation * lastLocation = (CLLocation *)[locations lastObject];

  NSLog(@"these are the locations %f and %f", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude);
  
//  NSString *url = @"https://thingspace.io/dweet/for/padmaja-device";
  
  //if there is a connection going on just cancel it.
  [self.connection cancel];
  
  //initialize new mutable data
  NSMutableData *data = [[NSMutableData alloc] init];
  self.receivedData = data;
  
  //initialize url that is going to be fetched.
  NSURL *url = [NSURL URLWithString:@"https://thingspace.io/dweet/for/padmaja-device"];
  
  //initialize a request from url
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
  
  //set http method
  [request setHTTPMethod:@"POST"];
  //initialize a post data
  
  NSString *postBodyData = [NSString stringWithFormat:@"lat=%f&lon=%f",lastLocation.coordinate.latitude, lastLocation.coordinate.longitude];
  
  //set request content type we MUST set this value.
  
  [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  
  //set post data of request
  [request setHTTPBody:[postBodyData dataUsingEncoding:NSUTF8StringEncoding]];
  
  //initialize a connection from request
  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
  self.connection = connection;
  
  //start the connection
  [connection start];
  
}

/*
 this method might be calling more than one times according to incoming data size
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
  [self.receivedData appendData:data];
}
/*
 if there is an error occured, this method will be called by connection
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
  
  NSLog(@"%@" , error);
}

/*
 if data is successfully received, this method will be called by connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
  
  //initialize convert the received data to string with UTF8 encoding
  NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
                                            encoding:NSUTF8StringEncoding];
  NSLog(@"%@" , htmlSTR);
  //initialize a new webviewcontroller
}

@end
