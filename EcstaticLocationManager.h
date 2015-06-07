//
//  LocationManager.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-24.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationServices.h"
#import <UIKit/UIKit.h>

@interface EcstaticLocationManager : NSObject<CLLocationManagerDelegate>
@property CLLocationManager *location_manager;
@property LocationServices *location_services;
@property float latitude;
@property float longitude;

-(void)startLocationServices;
-(CLLocationCoordinate2D)getCoordinates;
-(void)printLocations;

@end
