//
//  ViewWanderRequest.m
//  Wander-App
//
//  Created by Adhyam Nagarajan, Padmaja on 9/11/16.
//  Copyright © 2016 Adhyam Nagarajan, Padmaja. All rights reserved.
//

#import "ViewWanderRequest.h"

@implementation ViewWanderRequest

-(void) viewRequestForFindingGuide {
  
  NSURL *url = [NSURL URLWithString:@"https://api.wander.host/api/1/trips/"];
  
  //initialize a request from url
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
  
  //set http method
  [request setHTTPMethod:@"GET"];
  //initialize a post data
  
//  NSString *postBodyData = [NSString stringWithFormat:@"username=%@",@"arthur"];
  
  //set request content type we MUST set this value.
  
  [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  
  //set post data of request
//  [request setHTTPBody:[postBodyData dataUsingEncoding:NSUTF8StringEncoding]];
  
  //initialize a connection from request
  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
  self.viewReqConnection = connection;
  
  //start the connection
  [connection start];
}

/*
 this method might be calling more than one times according to incoming data size
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
  [self.receivedViewData appendData:data];
  NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
  NSInteger resultInteger = (NSInteger)[results objectForKey:@"trip_id"];
  NSLog(@"The trip_id for view created is :%ld",(long)resultInteger);
  self.viewStatusTripId = resultInteger;
  //  NSDictionary *resultsDictionary = [[results objectForKey:@"results"] objectAtIndex:0];
  //  NSLog(@"received data");
}
/*
 if there is an error occured, this method will be called by connection
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
  NSLog(@"received view error");
  NSLog(@"%@" , error);
}

/*
 if data is successfully received, this method will be called by connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
  
  //initialize convert the received data to string with UTF8 encoding
  NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedViewData
                                            encoding:NSUTF8StringEncoding];
  NSLog(@"%@" , htmlSTR);
  NSLog(@"received view data successfully");
  //initialize a new webviewcontroller
}

@end
