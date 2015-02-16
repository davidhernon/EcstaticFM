//
//  EventViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-01.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "EventViewController.h"
#import "PlayerView.h"

@implementation EventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeMapView];
    [self createMapView];
    
    playerView.startprop = _startprop; //need to set the startprop properly
    double network = 16;
    //[playerView initializeAudio]; does this even do anything?
    [playerView stream:streamURL withNetworkLatency:network];
    
}

///**
// 
// */
//-(void) stream
//{
//    NSLog(@"Stream.");
//    //Get the Stream URL
//    NSURL *url = [NSURL URLWithString:streamURL];
//    self->avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
//    
//    AVPlayerItem *pItem = [AVPlayerItem playerItemWithURL:url];
//    NSArray *metadataList = [pItem.asset commonMetadata];
//    for (AVMetadataItem *metaItem in metadataList) {
//        NSLog(@"metadata: %@",[metaItem commonKey]);
//    }
//    
//    self->playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
//
//    self->player = [AVPlayer playerWithPlayerItem:playerItem];
//    double serverTime = [self calculateNetworkLatency];
//    double eta = _startprop - serverTime;
//    NSLog(@"eta=%f", eta);
//    [self->player play];
//   // [self createTimeLabels];
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
//
//}


/*****************************************************/
///////////////////////// //////////////////*//////////
///////////////////////      //////////////*///////////
/////////////////// MAP VIEW STUFF ///////*////////////
///////////////////////      ////////////*/////////////
///////////////////////// //////////////*//////////////
/*****************************************************/

-(void) initializeMapView{
    
    [self.navigationController setNavigationBarHidden:NO];   //it hides
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

//grab the user location
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

/*- (double)calculateNetworkLatency
{
    // NOT WORKING AT ALL
}*/



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
