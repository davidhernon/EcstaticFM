//
//  Player.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-12.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Playlist.h"
#import "SoundCloudAPI.h"
//#import "PlayerViewController.h"

@protocol PlayerDelegate;

@interface Player : NSObject

@property Playlist* playlist;
@property MediaItem* currentTrack;
@property AVAudioPlayer* avPlayer;
@property NSTimer* progressTimer;
@property NSUInteger currentTrackIndex;
@property BOOL isPaused;

@property (nonatomic, weak) id<PlayerDelegate> delegate;

+(Player*) sharedPlayer;
-(void)play;
-(void) pause;
-(void) last;
-(void) updatePlaylist;
-(void)addDelegate:(id)sender;
-(void)updateTime;
-(void)seek:(float)value;
-(BOOL)isPlaying;


@end

@protocol PlayerDelegate <NSObject>

- (void) initPlayerUI:(float)duration withTrack:(MediaItem*)currentTrack atIndex:(NSUInteger)index;

- (void) setCurrentSliderValue:(AVAudioPlayer*)childPlayer;

- (void)updatePlaylistTable;

@end