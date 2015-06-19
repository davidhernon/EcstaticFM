//
//  ForgotPasswordViewController.m
//  EcstaticFM
//
//  Created by Martin Weiss 1 on 2015-06-18.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@implementation ForgotPasswordViewController

-(void)forgotPasswordReturnedTrue
{
	NSLog(@"true");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder Sent!"
													message:@"An email was sent to you with your password, please reset it and try again. Thanks!"
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles: nil];
	    [alert addButtonWithTitle:@"OK"];
	    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	[self performSegueWithIdentifier:@"ShowLogin" sender:self];
}



- (IBAction)submit:(id)sender {
		// at the top
		static NSString *csrf_cookie;
		
		// in a function:
	
	// in a function:
	NSURL *url = [[NSURL alloc] initWithString:@"http://54.173.157.204/"];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPShouldHandleCookies:YES];
	
	[request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url]]];
	
	// make GET request are store the csrf
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
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

		   NSString* urlString = @"http://54.173.157.204/auth/forgotpassword.html/";
		   NSURL *url = [NSURL URLWithString:urlString];
		   
		   NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
		   [urlRequest setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url]]];
		   [urlRequest addValue:csrf_cookie forHTTPHeaderField:@"X_CSRFTOKEN"];
		   [urlRequest setHTTPMethod:@"POST"];
		   NSString* bodyData = [NSString stringWithFormat:@"email=%@", self.email.text];
		   [urlRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
		   NSOperationQueue *queue = [[NSOperationQueue alloc] init];
		   
		   [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
			{
				dispatch_async(dispatch_get_main_queue(),
							   ^{
								   [self performSelector:@selector(forgotPasswordReturnedTrue) withObject:nil withObject:NO];
							   });

			}];
		}];
}
@end
