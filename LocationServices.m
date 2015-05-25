//
//  LocationServices.m
//  EcstaticFM
//
//  Created by Martin Weiss 1 on 2015-05-10.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "LocationServices.h"

@implementation LocationServices

-(void) start_location_services{
	// Create the location manager if this object does not
	// already have one.
	
	self.locationManager = [[CLLocationManager alloc] init];
 
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;

	// Set a movement threshold for new events.
	
	// Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
	if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
		[self.locationManager requestAlwaysAuthorization];
	}
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	if(status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
	{
		[self.locationManager startUpdatingLocation];
		self.lastUpdatedTime = [NSDate date];
		self.howOftenToUpdate = 15.0;
	}
}


// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations {
	
	// If it's a relatively recent event, turn off updates to save power.
	CLLocation* location = [locations lastObject];
	NSTimeInterval howRecent = [_lastUpdatedTime timeIntervalSinceNow];
	if (abs(howRecent) > _howOftenToUpdate) {
		self.lastUpdatedTime = [NSDate date];

		// If the event is recent, do something with it.
		NSLog(@"latitude %+.6f, longitude %+.6f\n",
			  location.coordinate.latitude,
			  location.coordinate.longitude);
		
		
		
		static NSString *csrf_cookie;
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSString* username = [defaults objectForKey:@"username"];
		
		NSString* urlString = @"http://54.173.157.204/geo/post_location/";
		NSURL *url = [NSURL URLWithString:urlString];
		NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: url];
		for (NSHTTPCookie *cookie in cookies) {
			if ([cookie.name isEqualToString:@"csrftoken"]) {
				csrf_cookie = cookie.value;
				break;
			}
		}
		
		NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
		
		NSString* bodyData = [NSString stringWithFormat:@"username=%@&my_location_lat=%f&my_location_lon=%f", username, location.coordinate.latitude, location.coordinate.longitude];
		NSData *postData = [bodyData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
		
		[urlRequest setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url]]];
		[urlRequest addValue:csrf_cookie forHTTPHeaderField:@"X_CSRFTOKEN"];
		[urlRequest setHTTPMethod:@"POST"];
		[urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[urlRequest setHTTPBody:postData];
		
		NSOperationQueue *queue = [[NSOperationQueue alloc] init];
		
		[NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
		 {
			 NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			 
			 if ([responseString  isEqual: @"location_received"]) {
				 NSLog(@"%@", responseString);
			 }
			 else{
				 NSLog(@"%@", responseString);
			 }
		 }];
		
	}
}

@end
