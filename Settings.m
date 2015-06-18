//
//  Settings.m
//  EcstaticFM
//
//  Created by Martin Weiss 1 on 2015-06-16.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "Settings.h"

@implementation Settings
- (IBAction)toggleLock:(id)sender {
	/*if(){
		
	}
	else{
		
	}*/
}

- (IBAction)Logout:(id)sender {
    //api handles transition to loginView
	[SDSAPI logout];
    NSString* cached_username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if(cached_username)
    {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"username"];
        [SSKeychain deletePasswordForService:@"EcstaticFM" account:cached_username];
    }
}

- (IBAction)changeSettings:(id)sender {
	if (&UIApplicationOpenSettingsURLString != NULL)
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end
