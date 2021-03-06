//
//  AppDelegate.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-01-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "AppDelegate.h"
#import "SDSAPI.h"
#import "SCUI.h"
#import "ChatViewController.h"
#import "SSKeychain.h"

@implementation AppDelegate

+ (void) initialize
{
    [SCSoundCloud setClientID:@"230ccb26b40f7c87eb65fc03357ffa81"
                       secret:@"4a50ef64acc242ce02e9abc5e370c064"
                  redirectURL:[NSURL URLWithString:@"sampleproject://oauth"]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // Override point for customization after application launch.
//    _eventD = [SDSAPI getUpcomingEvents];
    _player = [[Player alloc] init];
    _locationServices = [[LocationServices alloc]init];
    [SDSAPI connect];
	
	// Initialize the library with your Mixpanel project token, MIXPANEL_TOKEN
	[Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
	
	// Later, you can get your instance with
	self.mixpanel = [Mixpanel sharedInstance];
    return YES;
    
    
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [SDSAPI leaveRoom];
}

@end
