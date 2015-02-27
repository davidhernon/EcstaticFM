//
//  AppDelegate.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-01-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>

@property (strong, nonatomic) UIWindow *window;
@property id completionHandler;
@property BOOL returned;
@property (nonatomic, retain) NSArray *eventD;


@end
