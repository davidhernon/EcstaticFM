//
//  Settings.m
//  EcstaticFM
//
//  Created by Martin Weiss 1 on 2015-06-16.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "Settings.h"

@implementation Settings

-(void)viewWillAppear:(BOOL)animated{
	//if you are not the room owner then you cannot toggle the room lock
	if(![Room currentRoom].is_owner){
		_toggleLock.hidden = YES;
	}
}

- (IBAction)toggleLock:(id)sender {
	if(_toggleLock.on){
		[[Player sharedPlayer] setLock:true];
		[SDSAPI realtimePlayer:@"lock"];
	}
	else{
		[[Player sharedPlayer] setLock:false];
		[SDSAPI realtimePlayer:@"unlock"];
	}
}

- (IBAction)Logout:(id)sender {
    //api handles transition to loginView
	NSURL *url = [[NSURL alloc] initWithString:@"http://54.173.157.204/logout.html/"];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPShouldHandleCookies:YES];
	[request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url]]];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
							   NSLog(@"Logged Out");
						   }];
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
 -(IBAction)segueToChat:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerPageViewController *player_page = [sb instantiateViewControllerWithIdentifier:@"pp"];
    [player_page setChatAsStart];
    [self presentViewController:player_page animated:NO completion:nil];
}

-(IBAction)swipeToChat:(id)sender
{
    [(PlayerPageViewController*)self.parentViewController swipeToChatViewControllerReverse];
}

@end
