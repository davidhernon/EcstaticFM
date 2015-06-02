//
//  geoAskViewController.m
//  EcstaticFM
//
//  Created by Kizma on 2015-05-30.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "geoAskViewController.h"

@implementation geoAskViewController


- (IBAction)letsConnect:(id)sender {
    AppDelegate* appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate.locationServices try_start_location_services];
	if(appDelegate.locationServices.status == kCLAuthorizationStatusDenied){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Permissions Error"
														message:@"Make sure that 'Privacy > Loction Services' is turned on, and go to your iPhone's Settings under 'Ecstatic > Location' and set the permission to 'Always'."
													   delegate:self
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles: nil];
		    [alert addButtonWithTitle:@"OK"];
		    [alert show];
	}
}



@end
