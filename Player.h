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
#import "PlayerDelegate.h"
//@protocol PlayerDelegate;

@interface Player : NSObject

@property Playlist* playlist;
@property MediaItem* currentTrack;
@property AVPlayer* avPlayer;
@property NSTimer* progressTimer;
@property int currentTrackIndex;
@property BOOL player_is_paused;
@property BOOL player_is_locked;
@property BOOL isNextSong;
@property BOOL user_joining_room;
@property BOOL user_hit_button;


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
- (void) joinRoom:(int)index withElapsedTime:(float)elapsed andIsPlaying:(BOOL)is_playing isLocked:(BOOL)isLocked;
-(void)setLock:(BOOL)player_is_locked;
-(void) deleteSongWithDict:(NSDictionary*)remove_song_dict;

@end

