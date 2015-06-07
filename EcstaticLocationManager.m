//
//  LocationManager.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-24.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "EcstaticLocationManager.h"

@implementation EcstaticLocationManager

-(void)startLocationServices
{
    _latitude = -1.0f;
    _longitude = -1.0f;
    // Start the location services
    if(_location_services == nil)
    {
        _location_services = [[LocationServices alloc] init];
        [_location_services startLocationServices];
    }
    
    if(_location_manager == nil)
    {
        // Start collecting Locations
        _location_manager = [[CLLocationManager alloc] init];
        _location_manager.delegate = self;
        _location_manager.desiredAccuracy = kCLLocationAccuracyBest;
        _location_manager.distanceFilter = kCLDistanceFilterNone;
        [_location_manager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    
    NSLog(@"Error: %@",error.description);
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *crnLoc = [locations lastObject];
    _latitude = crnLoc.coordinate.latitude;
    _longitude = crnLoc.coordinate.longitude;
    NSLog(@"updated location: lat: %f  long: %f", _latitude, _longitude);
}

-(CLLocationCoordinate2D)getCoordinates
{
    CLLocation *location = [_location_manager location];
    return [location coordinate];
}

-(void)printLocations
{
    NSLog(@"latitude: %f  longitude: %f",_latitude, _longitude);
}

@end
