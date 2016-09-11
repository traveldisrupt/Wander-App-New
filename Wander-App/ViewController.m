//
//  ViewController.m
//  Wander-App
//
//  Created by Adhyam Nagarajan, Padmaja on 9/10/16.
//  Copyright © 2016 Adhyam Nagarajan, Padmaja. All rights reserved.
//

#import "ViewController.h"
#import "CreateWanderRequest.h"
#import "ViewWanderRequest.h"
#import "CancelWanderRequest.h"

#define TOKEN_URL @"https://api.wander.host/api/1/twilio/token/?user=arthur"

@interface ViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (nonatomic, strong) TCDevice *device;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIView *acceptCallView;
@property (weak, nonatomic) IBOutlet UIButton *hangupButton;
@property (weak, nonatomic) IBOutlet UIImageView *faceImage;
@property (weak, nonatomic) IBOutlet UILabel *youInCallLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileDescriptionLabel;
@property (nonatomic, strong) UIImageView *dot;

@end

@implementation ViewController
- (IBAction)hangUpCallAction:(id)sender {
  CancelWanderRequest *cancelRequest = [[CancelWanderRequest alloc] init];
  cancelRequest.cancelRequestForFindingGuide;
  
  
  self.acceptCallView.layer.borderWidth = .50;
  self.acceptCallView.layer.borderColor = [[UIColor blackColor] CGColor];
  self.acceptCallView.hidden = true;
  self.hangupButton.hidden = true;
  self.faceImage.hidden = true;
  self.youInCallLabel.hidden = true;
  self.profileLabel.hidden = true;
  self.profileDescriptionLabel.hidden = true;
  self.acceptCallView.layer.cornerRadius = 2;
  self.acceptCallView.layer.masksToBounds = false;
  self.callButton.hidden = false;
}

- (IBAction)callAction:(id)sender {
  
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.distanceFilter = kCLDistanceFilterNone;
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  
  if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    [self.locationManager requestWhenInUseAuthorization];
  }
//  [self.locationManager startUpdatingLocation];
  
  CreateWanderRequest *createRequest = [[CreateWanderRequest alloc] init];
  bool isCreated = createRequest.createRequestForFindingGuide;
  
  ViewWanderRequest *viewRequest = [[ViewWanderRequest alloc] init];
  
  if(isCreated) {
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = CGPointMake(200, 280);
    _spinner.tag = 24;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    
    viewRequest.viewRequestForFindingGuide;
  }
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  self.acceptCallView.layer.borderWidth = .50;
//  self.acceptCallView.layer.borderColor = [[UIColor blackColor] CGColor];
  self.acceptCallView.hidden = false;
  
  _dot =[[UIImageView alloc] initWithFrame:CGRectMake(50,90,200,150)];
  _dot.image=[UIImage imageNamed:@"wander-logo.png"];
  [self.acceptCallView addSubview:_dot];
  
  self.hangupButton.hidden = true;
  self.faceImage.hidden = true;
  self.youInCallLabel.hidden = true;
  self.profileLabel.hidden = true;
  self.profileDescriptionLabel.hidden = true;
  self.acceptCallView.layer.cornerRadius = 2;
  self.acceptCallView.layer.masksToBounds = false;
  
  [self retrieveToken];


  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) retrieveToken {
  // Create a GET request to the capability token endpoint
  NSURLSession *session = [NSURLSession sharedSession];
  
  NSURL *url = [NSURL URLWithString:TOKEN_URL];
  NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
  
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable responseData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (responseData) {
      NSError *error = nil;
      NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
      if (responseObject) {
        if (responseObject[@"identity"]) {
          dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.title = responseObject[@"identity"];
          });
        }
        if (responseObject[@"token"]) {
          [self initializeTwilioDevice:responseObject[@"token"]];
        }
      } else {
        [self displayError:[error localizedDescription]];
      }
    } else {
      [self displayError:[error localizedDescription]];
    }
  }];
  [task resume];
}

#pragma mark Initialization methods
- (void) initializeTwilioDevice:(NSString*)token {
  self.device = [[TCDevice alloc] initWithCapabilityToken:token delegate:self];
}

#pragma mark Utility Methods
- (void) displayError:(NSString*)errorMessage {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
  [alertController addAction:okAction];
  [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark TCDeviceDelegate

- (void)device:(TCDevice *)device didStopListeningForIncomingConnections:(NSError *)error {
  if (error) {
    NSLog(@"%@",[error localizedDescription]);
  }
}

- (void)device:(TCDevice *)device didReceiveIncomingConnection:(TCConnection *)connection {
  if (connection.parameters) {
    [_spinner stopAnimating];
//    NSString *from = connection.parameters[@"From"];
    NSString *from = @"Ford";
    NSString *message = [NSString stringWithFormat:@"Incoming call from %@",from];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Incoming Call" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      connection.delegate = self;
      [connection accept];
      
      self.acceptCallView.layer.borderWidth = .50;
      self.acceptCallView.layer.borderColor = [[UIColor blackColor] CGColor];
      self.acceptCallView.hidden = false;
      self.hangupButton.hidden = false;
      self.faceImage.hidden = false;
      self.youInCallLabel.hidden = false;
      self.profileLabel.hidden = false;
      self.profileDescriptionLabel.hidden = false;
      self.acceptCallView.layer.cornerRadius = 2;
      self.acceptCallView.layer.masksToBounds = false;
      self.callButton.hidden = true;
      self.dot.hidden = true;
      
      self.connection = connection;
    }];
    UIAlertAction *declineAction = [UIAlertAction actionWithTitle:@"Decline" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      [connection reject];
    }];
    
    [alertController addAction:acceptAction];
    [alertController addAction:declineAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
  }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  CLLocation * lastLocation = (CLLocation *)[locations lastObject];

//  NSLog(@"these are the locations %f and %f", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude);
  
//  NSString *url = @"https://thingspace.io/dweet/for/padmaja-device";
  
  //if there is a connection going on just cancel it.
  [self.connection cancel];
  
  //initialize new mutable data
  NSMutableData *data = [[NSMutableData alloc] init];
  self.receivedData = data;
  
  //initialize url that is going to be fetched.
  NSURL *url = [NSURL URLWithString:@"https://thingspace.io/dweet/for/arthur1million"];
  
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
