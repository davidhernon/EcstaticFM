//
//  EventViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-01.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "EventViewController.h"
#import "PlayerView.h"
#import "MediaPickerTableViewController.h"

@implementation EventViewController

/*!
 Calls super viewDidLoad and initializes View Controller
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeMapView];
    [self createMapView];
    playerView.delegate = self;
    playerView.startprop = _startprop; //need to set the startprop properly
    //[playerView initializeAudio]; does this even do anything?
    //TODO: take out withNetworkLatency tag
    [playerView stream:streamURL withNetworkLatency:16];
    
}


/*****************************************************/
///////////////////////// //////////////////*//////////
///////////////////////      //////////////*///////////
/////////////////// MAP VIEW STUFF ///////*////////////
///////////////////////      ////////////*/////////////
///////////////////////// //////////////*//////////////
/*****************************************************/

/*!
 Initializes a Map UI for the User Interface
 */
-(void) initializeMapView{
    
    [self.navigationController setNavigationBarHidden:NO];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    self->setSpan = FALSE;
    
#warning Exchange static frame info for constraints
    CGRect r = self.view.bounds;
    r.size.height = 350;
    self->mapView = [[MKMapView alloc] initWithFrame:r];
    mapView.mapType = MKMapTypeStandard;
    mapView.showsUserLocation = YES;
    mapView.userTrackingMode = YES;
}

/*!
 Manages the location of the components in the map and calls createMapView
 @params manager
 @params newLocation
 @params oldLocation
 */
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    self->userLocation = mapView.userLocation;
    self->userlat = newLocation.coordinate.latitude;
    self->userlong = newLocation.coordinate.longitude;
    //only adjust the region of the map once
    if(!self->setSpan){
        self->setSpan = TRUE;
        [self createMapView];
    }
}

/*!
 Creates and adds the Map to the UI
 */
- (void)createMapView{
    //create the point for the destination
    CLLocationCoordinate2D coord = {.latitude =  self->latitude, .longitude =  self->longitude};
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coord;
    point.title = self->eventTitle;
    point.subtitle = self->location;
    [self->mapView addAnnotation:point];
    [mapView selectAnnotation:point animated:YES];
    
    //calculate the size of the region for the map
    CLLocationDegrees latitudeRegion = fabs(userlat-latitude);
    CLLocationDegrees longitudeRegion = fabs(userlong-longitude);
    latitudeRegion = (int)(latitudeRegion*2.5);
    longitudeRegion = (int)(longitudeRegion*2.5);
    latitudeRegion = (int)latitudeRegion%360;
    longitudeRegion = (int)longitudeRegion%360;
    
    MKCoordinateSpan span = {latitudeRegion, longitudeRegion};
    MKCoordinateRegion region = {{userlat, userlong}, span};
    [mapView setRegion:region];
    
    [self.view addSubview:mapView];
}



/*!
 Calculates Network Latency
 @returns millisecond latency on the network
 */
/*- (double)calculateNetworkLatency
{
    // NOT WORKING AT ALL
}*/






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)nextScreen
{
    [self getTracks:self];
}

//Refactor and (probably) move this to Utils
//Maybe add in a delegate to Utils to properly call the nav controller
-(void) getTracks:(id) sender
{
    SCAccount *account = [SCSoundCloud account];
    if (account == nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Not Logged In"
                              message:@"You must login first"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            MediaPickerTableViewController *trackListVC;
            trackListVC = [[MediaPickerTableViewController alloc]
                           initWithNibName:@"MediaPickerTableViewController"
                           bundle:nil];
            trackListVC.tracks = (NSArray *)jsonResponse;
            [self presentViewController:trackListVC
                               animated:YES completion:nil];
        }
    };
    
    NSString *resourceURL = @"https://api.soundcloud.com/me/favorites.json";
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
}

@end
