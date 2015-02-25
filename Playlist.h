//
//  Playlist.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-25.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MediaItem.h"

@interface Playlist : NSObject

@property NSMutableArray* playlist;
+ (Playlist*) sharedPlaylist;
-(NSUInteger)count;
- (void) addTrack:(MediaItem *)song;
- (id)objectAtIndex:(NSUInteger)index;

@end
