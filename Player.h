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
#import "SDSAPI.h"
@protocol PlayerDelegate;

@interface Player : NSObject

@property Playlist* playlist;
@property MediaItem* currentTrack;
@property AVPlayer* avPlayer;
@property NSTimer* progressTimer;
@property int currentTrackIndex;
@property BOOL isPaused;
@property BOOL isNextSong;


@property (nonatomic, weak) id<PlayerDelegate> delegate;

+(Player*) sharedPlayer;
-(void)play;
-(void) pause;
-(void) last;
-(void) next;
-(void) updatePlaylist;
-(void)addDelegate:(id)sender;
-(void)updateTime;
-(void)seek:(float)value;
-(BOOL)isPlaying;
-(void) reloadUI;
- (void) joinPlayingRoom:(int)index withElapsedTime:(int)elapsed andIsPlaying:(int)is_playing;


@end




@protocol PlayerDelegate <NSObject>

- (void) initPlayerUI:(float)duration withTrack:(MediaItem*)currentTrack atIndex:(int)index;

- (void) setCurrentSliderValue:(AVPlayer*)childPlayer;

- (void)updatePlaylistTable;

- (void)hideUI;

- (void)redrawUI;

- (void)showPlayButton;

- (void)showPauseButton;

@end


