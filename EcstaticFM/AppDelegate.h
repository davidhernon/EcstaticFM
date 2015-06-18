//
//  AppDelegate.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-01-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "LocationServices.h"
#import "Mixpanel.h"
#import "Settings.h"
@class ChatViewController;

//DEV KEY MUST CHANGE TO PRODUCTION
#define MIXPANEL_TOKEN @"a17f016312fe75ac288ba52dc81b1cdb"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>

@property (strong, nonatomic) UIWindow *window;
@property id completionHandler;
@property (nonatomic, retain) Player* player;
@property LocationServices* locationServices;
@property Mixpanel* mixpanel;
@property ChatViewController* chatViewController;


@end

