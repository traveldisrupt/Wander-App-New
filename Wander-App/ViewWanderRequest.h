//
//  ViewWanderRequest.h
//  Wander-App
//
//  Created by Adhyam Nagarajan, Padmaja on 9/11/16.
//  Copyright © 2016 Adhyam Nagarajan, Padmaja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewWanderRequest : NSObject

@property (retain, nonatomic) NSURLConnection *viewReqConnection;
@property (retain, nonatomic) NSMutableData *receivedViewData;
@property NSInteger viewStatusTripId;

-(void) viewRequestForFindingGuide;

@end
