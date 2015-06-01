//
//  LocationServices.h
//  EcstaticFM
//
//  Created by Martin Weiss 1 on 2015-05-10.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDSAPI;
@class geoAskViewController;
@import CoreLocation;

@interface LocationServices : NSObject<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) NSDate *lastUpdatedTime;
@property int howOftenToUpdate;
@property geoAskViewController* vc;
-(void)try_start_location_services;
-(void)locationManager:(CLLocationManager *)manager
	didUpdateLocations:(NSArray *)locations;
- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;
-(Boolean) checkForPermissions;

@end
