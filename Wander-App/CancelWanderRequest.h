//
//  CancelWanderRequest.h
//  Wander-App
//
//  Created by Adhyam Nagarajan, Padmaja on 9/11/16.
//  Copyright © 2016 Adhyam Nagarajan, Padmaja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CancelWanderRequest : NSObject

@property (retain, nonatomic) NSURLConnection *cancelReqConnection;
@property (retain, nonatomic) NSMutableData *receivedData;
@property BOOL isRequestCancelled;

-(void) cancelRequestForFindingGuide;

@end
