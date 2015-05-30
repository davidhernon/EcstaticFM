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
@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>

@property (strong, nonatomic) UIWindow *window;
@property id completionHandler;
@property (nonatomic, retain) NSArray *eventD;
@property (nonatomic, retain) Player* player;
@property LocationServices* locationServices;



@end

