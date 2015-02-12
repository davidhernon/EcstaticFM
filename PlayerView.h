//
//  PlayerView.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-11.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "Utils.h"

@interface PlayerView : UIView
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak,nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) AVPlayer *player;
// PLAYER STUFF TO REFACTOR:

-(void) initializeAudio;
-(void) stream:(NSString*) streamURL;
- (double)calculateNetworkLatency;

@property (weak, nonatomic) AVAsset *avAsset;
@property (weak, nonatomic) AVPlayerItem *playerItem;
@property int j;
@property double startprop;
@property (weak, nonatomic) NSDate *requestStart;
@property (nonatomic, retain) NSArray *serverTimestamp;
@property (nonatomic, retain) NSString* serverTimestampString;
@property (nonatomic, retain) NSDate* serverTimestampDate;
@property NSTimeInterval serverTimeSinceEpoch;
@property NSMutableArray *serverTimestampsArray;
@property NSMutableArray *durations;
@property NSTimeInterval requestDuration;
//
-(void)updateSlider;
@end
