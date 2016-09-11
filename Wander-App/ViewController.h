//
//  ViewController.h
//  Wander-App
//
//  Created by Adhyam Nagarajan, Padmaja on 9/10/16.
//  Copyright © 2016 Adhyam Nagarajan, Padmaja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <TwilioClient/TwilioClient.h>

@interface ViewController : UIViewController <TCDeviceDelegate,
TCConnectionDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

@end
