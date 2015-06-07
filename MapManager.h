//
//  MapManager.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapManager : NSObject<CLLocationManagerDelegate>
@property CLLocationManager *locationManager;

@end
