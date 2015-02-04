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
#import "MusicTableViewController.h"
#import "Utils.h"
@interface EventViewController : UIViewController<NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate, UIAlertViewDelegate, AVAudioPlayerDelegate, CLLocationManagerDelegate, PassInformation>{
    MKMapView *mapView;
@public float latitude;
@public float longitude;
@public NSString *eventTitle;
@public NSString *songTitle;
@public NSString *streamURL;
@public NSString *location;
@public MPMediaItem *discoTrack;
    IBOutlet UILabel *countdownTimer;
    UIView *playerView;
    AVPlayer *player;
    AVAsset *avAsset;
    AVPlayerItem *playerItem;
    NSURL *songURL;
    NSArray *autoResults;
    IBOutlet UIView *volumeView;
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
