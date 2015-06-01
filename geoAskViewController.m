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
    [appDelegate.locationServices try_start_location_services];
}



@end
