//
//  EventViewController.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-01.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "Utils.h"
#import "PlayerView.h"
@interface EventViewController : UIViewController<mediaPickerDelegate,NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate, UIAlertViewDelegate, AVAudioPlayerDelegate, CLLocationManagerDelegate>{
    
    //David's stuff
    IBOutlet PlayerView *playerView;
    
    
    
    MKMapView *mapView;
@public float latitude;
@public float longitude;
@public NSString *eventTitle;
@public NSString *songTitle;
@public NSString *streamURL;
@public NSString *location;
@public MPMediaItem *discoTrack;
    IBOutlet UILabel *countdownTimer;
    AVPlayer *player;
    AVAsset *avAsset;
    AVPlayerItem *playerItem;
    NSURL *songURL;
    NSArray *autoResults;
    CLLocationDegrees userlat;
    CLLocationDegrees userlong;
    NSTimer *userLocTimer;
    MKUserLocation *userLocation;
    CLLocationManager *locationManager;
    BOOL setSpan;
    UISlider *slider;
    UILabel *playtimeLabel;
    UILabel *durationLabel;
    
}
@property double startprop;
@property double eta;
@property NSTimer *updatePlayerTimer;
@property int j;
@property NSDate *requestStart;
@property (nonatomic, retain) NSArray *serverTimestamp;
@property (nonatomic, retain) NSString* serverTimestampString;
@property (nonatomic, retain) NSDate* serverTimestampDate;
@property NSTimeInterval serverTimeSinceEpoch;
@property NSMutableArray *serverTimestampsArray;
@property NSMutableArray *durations;
@property NSTimeInterval requestDuration;

@end
