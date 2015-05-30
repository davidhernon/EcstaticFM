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
    AppDelegate* appDelegate = [[UIApplication  sharedApplication]delegate];
    [appDelegate.locationServices start_location_services];
    
    //while(!appDelegate.locationServices checkForPermissions){
        //[NSThread sleepForTimeInterval:0.1f];
    //}
    
    if([appDelegate.locationServices checkForPermissions]){
        [self performSegueWithIdentifier:@"roomsViewSegue" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"backToPlayerSegue" sender:self];
    }
}
@end
