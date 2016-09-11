//
//  CancelWanderRequest.m
//  Wander-App
//
//  Created by Adhyam Nagarajan, Padmaja on 9/11/16.
//  Copyright © 2016 Adhyam Nagarajan, Padmaja. All rights reserved.
//

#import "CancelWanderRequest.h"

@implementation CancelWanderRequest

-(void) cancelRequestForFindingGuide {
  
  
  NSURL *url = [NSURL URLWithString:@"https://api.wander.host/api/1/trip/cancel/"];
  
  //initialize a request from url
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
  
  //set http method
  [request setHTTPMethod:@"POST"];
  
  [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  
  //initialize a connection from request
  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
  self.cancelReqConnection = connection;
  
  //start the connection
  [connection start];
}

@end
