//
//  EventViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-01.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()

@end

@implementation EventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeAudio];
    [self initializeMapView];
    [self createMapView];
    [self createVolumeView];
    [self checkForTrack];
}

/*****************************************************/
///////////////////////// //////////////////*//////////
///////////////////////      //////////////*///////////
//////////// PLAYER PROGRAMMATIC STUFF ///*////////////
///////////////////////      ////////////*/////////////
///////////////////////// //////////////*//////////////
/*****************************************************/
- (void) pickTrack{
    [self performSegueWithIdentifier:@"pickTrack" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MusicTableViewController *childVC = segue.destinationViewController;
    childVC.delegate = self;
}

- (void)checkForTrack
{
    MPMediaPropertyPredicate *songPredicate =
    [MPMediaPropertyPredicate predicateWithValue:songTitle
                                     forProperty:MPMediaItemPropertyTitle
                                  comparisonType:MPMediaPredicateComparisonContains];
    NSSet *predicates = [NSSet setWithObjects: songPredicate, nil];
    MPMediaQuery *songsQuery =  [[MPMediaQuery alloc] initWithFilterPredicates: predicates];
    self->autoResults = [songsQuery items];
    
    //no song found locally
    if(!([autoResults count] == 0))
    {
        [self foundLocally];
    }
    //found song locally
    else{
        [self notFoundLocally];
    }
}
- (void) notFoundLocally{
    NSString *message = [NSString stringWithFormat:@""];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ Not Found", songTitle]														message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    
    [alert addButtonWithTitle:@"Stream"];
    [alert addButtonWithTitle:@"Pick Track to Synchronize"];
    [alert show];
}

- (void) foundLocally{
    NSString *message = [NSString stringWithFormat:@"You've got the Track!: %@", songTitle];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sweeeeeeet"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    //found song locally, and play it
    self->discoTrack = [autoResults objectAtIndex:0];
    [self loadAndPlayLocalTrack];
}

- (void) loadAndPlayLocalTrack{
    [self createTimeLabels];
    songURL = [self->discoTrack valueForProperty:MPMediaItemPropertyAssetURL];
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:songURL options:nil];
    NSArray *keyArray = [[NSArray alloc] initWithObjects:@"tracks", nil];
    [urlAsset loadValuesAsynchronouslyForKeys:keyArray completionHandler:^{
        
        self->playerItem = [[AVPlayerItem alloc] initWithAsset:urlAsset];
        
        player = [[AVPlayer alloc] initWithPlayerItem:self->playerItem];
        
        while (true) {
            if (player.status == AVPlayerStatusReadyToPlay && playerItem.status == AVPlayerItemStatusReadyToPlay)
                break;
        }
        
        [player play];
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Stream"])
    {
        NSLog(@"Stream.");
        //Get the Stream URL
        NSURL *url = [NSURL URLWithString:streamURL];
        self->avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        self->playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
        self->player = [AVPlayer playerWithPlayerItem:playerItem];
        double serverTime = [self calculateNetworkLatency];
        double eta = _startprop - serverTime;
        NSLog(@"eta=%f", eta);
        [self->player play];
        [self createTimeLabels];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    }
    else if([title isEqualToString:@"Pick Track to Synchronize"])
    {
        NSLog(@"Pick Track to Synchronize.");
        [self pickTrack];
    }
}

- (void) updateSlider{
    AVPlayerItem *currentItem = player.currentItem;
    Float64 currentTime = CMTimeGetSeconds(currentItem.currentTime); //playing time
    Float64 duration = CMTimeGetSeconds(currentItem.duration); //total time
    
    //create a pair of labels
    self->playtimeLabel.text = [self floatToText:currentTime];
    self->durationLabel.text = [self floatToText:duration];
    self->slider.value = currentTime/duration;
}

-(NSMutableString*) floatToText: (Float64)time{
    NSString *hours = [NSString stringWithFormat:@"%uh ", (int) time/3600];
    time = (int)time % 3600;
    NSString *mins = [NSString stringWithFormat:@"%um ", (int) time/60];
    time = (int)time % 60;
    NSString *seconds = [NSString stringWithFormat:@"%us ", (int) time];
    NSMutableString *timeString = [[NSMutableString alloc] initWithString:hours];
    
    [timeString appendString:mins];
    [timeString appendString:seconds];
    return timeString;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [self.navigationController setNavigationBarHidden:YES];   //it hides
    }
    [super viewWillDisappear:animated];
}

//delegate function implemented
//this gets called from the second viewconroller when the view disappears
- (void) setTrack:(MPMediaItem *)song
{
    self->discoTrack = song;
    [self loadAndPlayLocalTrack];
}


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

-(void) initializeAudio{
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    // Change the default output audio route
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                            sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
}


/*****************************************************/
///////////////////////// //////////////////*//////////
///////////////////////      //////////////*///////////
/////////////////// PLAYER VIEW STUFF ////*////////////
///////////////////////      ////////////*/////////////
///////////////////////// //////////////*//////////////
/*****************************************************/


- (void)createVolumeView{
    volumeView.backgroundColor = [Utils colorWithHexString:@"0EA48B"];
    
    //put the trackname on the view
    UILabel *tracknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    tracknameLabel.text = self->songTitle;
    tracknameLabel.textAlignment = NSTextAlignmentCenter;
    [tracknameLabel setTextColor:[UIColor whiteColor]];
    [tracknameLabel setBackgroundColor:[UIColor clearColor]];
    [tracknameLabel setFont:[UIFont fontWithName: @"Dosis-Bold" size: 14.0f]];
    [self->volumeView addSubview:tracknameLabel];
    
    //create slider
    CGRect frame = CGRectMake(30.0, 40.0, 260.0, 10.0);
    self->slider = [[UISlider alloc] initWithFrame:frame];
    //[slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    slider.continuous = YES;
    slider.value = 0.0;
    [self->volumeView addSubview:slider];
    
}

- (void) createTimeLabels{
    self->playtimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 75, 100, 20)];
    self->durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 75, 100, 20)];
    [self->volumeView addSubview:playtimeLabel];
    [self->volumeView addSubview:durationLabel];
    [self->volumeView bringSubviewToFront:playtimeLabel];
}
//returns the exact time that the server thinks it is, adjusted for network latency :)
- (double)calculateNetworkLatency
{
    if(self.j < 10)
    {
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL * url = [NSURL URLWithString:@"http://54.68.113.110/"];
        self.requestStart = [NSDate date];
        
        NSURLSessionDataTask *dataTask = [delegateFreeSession dataTaskWithURL:url
                                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                if(error == nil)
                                                                {
                                                                    self.serverTimestamp = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                           options:kNilOptions
                                                                                                                             error:&error];
                                                                }
                                                                for(NSDictionary *item in _serverTimestamp) {
                                                                    self.serverTimestampString = [item valueForKey:@"timeStamp"];
                                                                }
                                                                self.serverTimestampString = [self.serverTimestampString stringByReplacingOccurrencesOfString: @"T" withString:@" "];
                                                                
                                                                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
                                                                self.serverTimestampDate = [formatter dateFromString:self.serverTimestampString];
                                                                self.serverTimeSinceEpoch = [self.serverTimestampDate timeIntervalSince1970];
                                                                [self.serverTimestampsArray addObject: [[NSNumber alloc] initWithDouble:self.serverTimeSinceEpoch]];
                                                                
                                                                [self.durations addObject: [[NSNumber alloc] initWithDouble:self.requestDuration]];
                                                                self.requestDuration = [[NSDate date] timeIntervalSinceDate:_requestStart];
                                                                self.j = self.j + 1;
                                                                [self calculateNetworkLatency];
                                                            }];
        [dataTask resume];
    }
    else
    {
        float average = 0;
        for(int i = 2; i < self.j; i++)
        {
            NSLog(@"Trial = %i", i);
            NSLog(@"Duration = %f", [[self.durations objectAtIndex:i]doubleValue]);
            NSLog(@"ServerTime = %f", [[self.serverTimestampsArray objectAtIndex:i]doubleValue]);
            
            average = average + [[self.durations objectAtIndex:i]doubleValue];
        }
        average = average/(self.j-2);
        self.requestDuration = average;
        self.serverTimeSinceEpoch = [[self.serverTimestampsArray objectAtIndex:(self.j-1)]doubleValue];
        return self.serverTimeSinceEpoch + self.requestDuration/2.0;
    }
    return -193234;
}



- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }



@end
