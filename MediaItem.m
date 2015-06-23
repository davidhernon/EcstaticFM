//
//  MediaItem.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-25.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "MediaItem.h"
#import "Room.h"
#import "SoundCloudAPI.h"

@implementation MediaItem

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.track_title forKey:@"track_title"];
    [coder encodeObject:self.artist forKey:@"artist"];
    [coder encodeObject:self.duration forKey:@"duration"];
    [coder encodeObject:self.artwork_url forKey:@"artwork_url"];
    [coder encodeObject:self.stream_url forKey:@"stream_url"];
    [coder encodeObject:self.room_number forKey:@"room_number"];
    [coder encodeObject:self.username forKey:@"username"];
    [coder encodeObject:self.download_url forKey:@"download_url"];
    [coder encodeObject:[NSNumber numberWithBool:self.is_event_mix] forKey:@"is_event_mix"];
}

-(NSDictionary*)serializeMediaItem
{
    NSMutableDictionary* serialized = [[NSMutableDictionary alloc] init];
    [serialized setValue:self.track_title forKey:@"track_title"];
    [serialized setValue:self.artist forKey:@"artist"];
    [serialized setValue:self.duration forKey:@"duration"];
    [serialized setValue:self.stream_url forKey:@"stream_url"];
    [serialized setValue:self.room_number forKey:@"room_number"];
    [serialized setValue:self.username forKey:@"username"];
    [serialized setValue:self.artwork_url forKey:@"artwork_url"];
    [serialized setValue:self.download_url forKey:@"download_url"];
    [serialized setValue:[NSNumber numberWithBool:self.is_event_mix] forKey:@"is_event_mix"];
    return serialized;
}

// Default constructor
- (id) init
{
    self = [super init];
    if(self)
    {
        _track_title = @"initialized from empty constructor";
        _artist = @"initialized from empty constructor";
        _duration = [NSNumber numberWithLong:-1];
        _artwork = [self addAlbumArtwork:nil];
        _duration_hours = [NSNumber numberWithLong:-1];;
        _duration_minutes = [NSNumber numberWithLong:-1];;
        _duration_seconds = [NSNumber numberWithLong:-1];;
    }
    return self;
}


/**
 constructor for a MediaItem* that is initialized with a JSON Disctionary from Soundcloud's API
 Example usage:
 @code
 MediaItem* mediaItem = [MediaItem alloc] initWithSoundCloudTrack:yourNSDictionarySoundCloudTrack;
 @endcode
 @param soundCloudTrack
        NSDictionary from JSON response of SoundCloud API for a single song.
 @return (id) of the newly created MediaItem
 */
- (id) initWithSoundCloudTrack:(NSDictionary *)soundCloudTrack
{
    self = [super init];
    if(self)
    {
        self.track_title = [soundCloudTrack objectForKey:@"title"];
        self.artist = [[soundCloudTrack objectForKey:@"user"] objectForKey:@"username"];
        self.duration = [NSString stringWithFormat:@"%@", [Utils convertTimeFromMillis:(int) [[soundCloudTrack objectForKey:@"duration"] intValue]]];
        self.artwork = [self addAlbumArtwork:[soundCloudTrack objectForKey:@"artwork_url"]];
        self.artwork_url = [soundCloudTrack objectForKey:@"artwork_url"];
        self.stream_url = [soundCloudTrack objectForKey:@"stream_url"];
        self.waveform_url = [self addWaveform:[soundCloudTrack objectForKey:@"waveform_url"]];
        self.playing_animation = [[UIImage alloc] init];
        self.username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
//        self.playing_animation = [UIImage animatedImageNamed:@"wave" duration:0.6f];
        self.playing_animation = [UIImage imageNamed:@"wave1.png"];
        self.original_format = [soundCloudTrack objectForKey:@"original_format"];
        NSString *b = [NSString stringWithFormat:@"%@",[soundCloudTrack objectForKey:@"downloadable"] ];
        if([b isEqualToString:@"1"])
            self.downloadable = YES;
        else
            self.downloadable = NO;
        if(self.downloadable)
        {
//            [SoundCloudAPI getSoundCloudTrackFromURL:[soundCloudTrack objectForKey:@"download_url"]];
            
            
            self.download_url = [soundCloudTrack objectForKey:@"download_url"];
            //find local file if it already downloaded
            NSString *locl_url = [[NSUserDefaults standardUserDefaults] objectForKey:[Utils getParsedURL:[NSString stringWithFormat:@"%@-client_id=%@",self.download_url,[SoundCloudAPI getClientID]]]];
            NSLog(@"printing key we need for string: %@", [Utils getParsedURL:[NSString stringWithFormat:@"%@-client_id=%@",self.download_url,[SoundCloudAPI getClientID]]]);
            
            NSLog(@"printing local file path: %@", self.local_file_path);
            
            
            
            //location exists locally
            if(locl_url)
            {
                self.local_file_path = locl_url;
                NSLog(@"printing local file path: %@", self.local_file_path);
                self.is_local_item = YES;
            }else{
                self.is_local_item = NO;
            }
        }else{
            self.is_local_item = NO;
        }
        self.is_event_mix = NO;
        
        
        
    }
    return self;
}

- (id) initWIthDict:(NSDictionary*)sds_dict
{
    self = [super init];
    if(self)
    {
        self.track_title = [sds_dict objectForKey:@"track_title"];
        self.artist = [sds_dict objectForKey:@"artist"];
        self.duration = [sds_dict objectForKey:@"duration"];
        self.artwork = [self addAlbumArtwork:[sds_dict objectForKey:@"artwork_url"]];
        self.artwork_url = [sds_dict objectForKey:@"artwork_url"];
        self.stream_url = [sds_dict objectForKey:@"stream_url"];
        self.playing_animation = [[UIImage alloc] init];
        self.username = [sds_dict objectForKey:@"username"];
        self.playing_animation = [UIImage imageNamed:@"wave1.png"];
        self.room_number = [Room currentRoom].room_number;
        self.download_url = [sds_dict objectForKey:@"soundcloudLink"];
        self.is_event_mix = YES;
        self.is_local_item = NO;
        self.local_file_path = [[NSString alloc] init];
        
        [SoundCloudAPI getSoundCloudTrackFromURL:[sds_dict objectForKey:@"soundcloudLink"]];
        
//        self.original_format = [sdsobjectForKey:@"original_format"];
    }
    return self;
}

//- (void) downloadMediaItem
//{
////    [Utils downloadSongFromURL:self.download_url];
//}

/**
 A Method for adding a UIImage from a url string containing the album artwork location for a track
 @code
 myMediaItem.artwork = [myMediaItem addAlbumArtwork:[soundCloudTrack objectForKey:@"arwork_url"];
 @endcode
 @param stringURL
        URL in string form of http location of album artwork
 @returns UIImage with artwork loaded or with default artwork if the stringURL is nil
 */
-(UIImage*)addAlbumArtwork:(NSString*)stringURL
{
    if([stringURL isEqual:[NSNull null]]){
        stringURL = @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi8MYn94Vl1HVxqMb7u31QSRa3cNCJOYhxw7xI_GGDvcSKQ7xwPA370w";
    }
    stringURL = [stringURL stringByReplacingOccurrencesOfString:@"large.jpg" withString:@"t500x500.jpg"];
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:stringURL]]];
}

/**
 A Method for adding a UIImage from a url string containing the waveformlocation for a track
 @code
 myMediaItem.artwork = [myMediaItem addWaveform:[soundCloudTrack objectForKey:@"waveform_url"];
 @endcode
 @param stringURL
 URL in string form of http location of waveform image
 @returns UIImage with waveform loaded or with default waveform if the stringURL is nil
 */
-(UIImage*)addWaveform:(NSString*)stringURL
{
    if([stringURL isEqual:[NSNull null]]){
        stringURL = @"http://w1.sndcdn.com/fxguEjG4ax6B_m.png";
    }
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:stringURL]]];
}

@end
