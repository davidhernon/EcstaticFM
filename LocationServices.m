//
//  LocationServices.m
//  EcstaticFM
//
//  Created by Martin Weiss 1 on 2015-05-10.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "LocationServices.h"
#import "SDSAPI.h"
#import "geoAskViewController.h"

@implementation LocationServices

-(id)initWithViewController:(geoAskViewController*)vc
{
	if(self = [super init])
	{
		self.vc = vc;
	}
	return self;
}

-(Boolean) checkForPermissions{
    if (self.locationManager == nil){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways){
        return true;
    }
    else{
        return false;
    }
}

-(void) try_start_location_services{
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
 
	// Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
	if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
		[self.locationManager requestAlwaysAuthorization];
	}
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	if(status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
	{
		[self.vc performSegueWithIdentifier:@"roomsViewSegue" sender:self];
		self.status = kCLAuthorizationStatusAuthorizedAlways;
			[self.locationManager startUpdatingLocation];
			self.lastUpdatedTime = [NSDate date];
			self.howOftenToUpdate = 15.0;
	}
	else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted){
		self.status = kCLAuthorizationStatusDenied;
	}
	else if (status == kCLAuthorizationStatusNotDetermined){
		self.status = kCLAuthorizationStatusNotDetermined;
	}
	else{
		[self.vc performSegueWithIdentifier:@"backToPlayerSegue" sender:self];

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
		
		
		
//		static NSString *csrf_cookie;
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSString* username = [defaults objectForKey:@"username"];
        
        [SDSAPI postLocation:username withLatitude:location.coordinate.latitude withLongitude:location.coordinate.longitude];
        
		
	}
}

@end
