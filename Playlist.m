//
//  Playlist.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-25.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "Playlist.h"
#import "Player.h"

@implementation Playlist

static Playlist *sharedPlaylist = nil;

-(id)init{
    self=[super init];
    if(self){
        //Is there any extra initialization?
    }
    return  self;
}

//Why the fuck does this method work?
+ sharedPlaylist
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlaylist = [[self alloc] init];
        sharedPlaylist.playlist = [[NSMutableArray alloc]init];
    });
    return sharedPlaylist;
}

- (void) initWithDict:(NSDictionary*)playlist
{
    // Hadnling player UI and stop/start
    sharedPlaylist.playlist = [[NSMutableArray alloc] init];
    
    if([playlist count] == 0)
    {
        return;
    }
    
    for(int i = 0; i < [playlist count]; i++)
    {
        NSDictionary *track = [playlist objectForKey:[NSString stringWithFormat:@"%d", i]];
        MediaItem *new_track = [[MediaItem alloc] initWIthDict:track];
        
        [self addTrack:new_track];
    }
}

-(void)clearPlaylist
{
    sharedPlaylist. playlist = [[NSMutableArray alloc] init];
    [[Player sharedPlayer] resetPlayer];
}

- (void) addTrack:(MediaItem *)song
{
    [self.playlist addObject:song];
}

- (void) addTracks:(NSMutableArray*)songsToAdd
{
    [self.playlist addObjectsFromArray:songsToAdd];
}

-(void) removeTrack:(MediaItem*)song
{
    [self.playlist removeObject:song];
}

- (NSUInteger) count
{
    return self.playlist.count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [self.playlist objectAtIndex:index];
}

- (void) reloadPlayer
{
    [[Player sharedPlayer] reloadUI];
}

- (void) removeLocalSongById:(NSString*)track_id
{
    NSArray* parsed_track_id_array = [track_id componentsSeparatedByString: @"."];
    track_id = [parsed_track_id_array firstObject];
    
    for(MediaItem* track in _playlist)
    {
        if([[NSString stringWithFormat:@"%@",track.sc_id] isEqualToString:track_id]){
            //we found the local track that just got deleted so lets remove it
            [track makeNotLocalTrack];
        }
    }
}

@end
