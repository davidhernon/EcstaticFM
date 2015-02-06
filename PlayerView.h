//
//  PlayerView.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-05.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicTableViewController.h"

@interface PlayerView : UIView<NSURLSessionDataDelegate, PassInformation>
{
    @public NSString *songTitle;
    @public NSString *streamURL;
    @public MPMediaItem *discoTrack; //maybe take this out
    IBOutlet UILabel *countdownTimer;
    UIView *playerView;
    AVPlayer *player;
    AVAsset *avAsset;
    AVPlayerItem *playerItem;
    NSURL *songURL;
    NSArray *autoResults;
    IBOutlet UIView *volumeView;
    NSTimer *userLocTimer;
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
