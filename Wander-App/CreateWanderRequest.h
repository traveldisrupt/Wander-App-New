//
//  CreateWanderRequest.h
//  Wander-App
//
//  Created by Adhyam Nagarajan, Padmaja on 9/11/16.
//  Copyright © 2016 Adhyam Nagarajan, Padmaja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateWanderRequest : NSObject

@property (retain, nonatomic) NSURLConnection *createReqConnection;
@property (retain, nonatomic) NSMutableData *receivedData;
@property BOOL isRequestCreated;

-(BOOL) createRequestForFindingGuide;

@end
