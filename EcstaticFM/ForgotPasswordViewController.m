//
//  ForgotPasswordViewController.m
//  EcstaticFM
//
//  Created by Martin Weiss 1 on 2015-06-18.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@implementation ForgotPasswordViewController

- (IBAction)submit:(id)sender {
		// at the top
/*		static NSString *csrf_cookie;
		
		// in a function:
		NSURL *url = [[NSURL alloc] initWithString:@"http://54.173.157.204/forgotpassword.html/"];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
		[request setHTTPShouldHandleCookies:YES];
		
		[request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url]]];
		
		// make GET request are store the csrf
		[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
							   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
								   if(response!=nil){
									   [SDSAPI loginReturned];
								   }
								   
								   NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[(NSHTTPURLResponse *)response allHeaderFields] forURL:url];
								   [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:url mainDocumentURL:nil];
								   
								   // for some reason we need to re-store the CSRF token as X_CSRFTOKEN
								   for (NSHTTPCookie *cookie in cookies) {
									   if ([cookie.name isEqualToString:@"csrftoken"]) {
										   csrf_cookie = cookie.value;
										   NSLog(@"cookie.value=%@", cookie.value);
										   break;
									   }
								   }
								   NSString* urlString = @"http://54.173.157.204/auth/loginViewiOS/";
								   NSURL *url = [NSURL URLWithString:urlString];
								   
								   NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
								   [urlRequest setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url]]];
								   [urlRequest addValue:csrf_cookie forHTTPHeaderField:@"X_CSRFTOKEN"];
								   [urlRequest setHTTPMethod:@"POST"];
								   NSString* bodyData = [NSString stringWithFormat:@"username=%@&password=%@", username, pass];
								   [urlRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
								   NSOperationQueue *queue = [[NSOperationQueue alloc] init];
								   
								   [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
									{
										NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
										if ([responseString  isEqual: @"successful_login"]) {
											[callingViewController performSelectorOnMainThread:@selector(loginReturnedTrue) withObject:nil waitUntilDone:NO];
										}
										else{
											[callingViewController performSelectorOnMainThread:@selector(loginReturnedFalse) withObject:nil waitUntilDone:NO];
										}
									}];
							   }];
		NSMutableDictionary *cb = [[NSMutableDictionary alloc] init];
		[cb setObject:(id)callingViewController forKey:@"login_controller"];
		
		login_timer = [NSTimer scheduledTimerWithTimeInterval:10.0
													   target:self
													 selector:@selector(loginTimedOut:)
													 userInfo:(id)cb
													  repeats:NO];
		
	}
*/
}
@end
