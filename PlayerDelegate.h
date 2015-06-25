//
//  PlayerDelegate.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-06-25.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#ifndef EcstaticFM_PlayerDelegate_h
#define EcstaticFM_PlayerDelegate_h

@protocol PlayerDelegate <NSObject>

- (void) initPlayerUI:(float)duration withTrack:(MediaItem*)currentTrack atIndex:(int)index;

- (void) setCurrentSliderValue:(AVPlayer*)childPlayer;

- (void)updatePlaylistTable;

- (void)hideUI;

- (void)redrawUI;

- (void)showPlayButton;

- (void)showPauseButton;

- (void)playerIsLoadingNextSong;

-(void)playerIsDoneLoadingNextSong;

-(void)lock;
-(void)unlock;

-(void)deleteSongAtIndex:(int)index;

@end


#endif
