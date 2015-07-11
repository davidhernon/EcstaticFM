//
//  MediaItem.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-25.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Utils.h"
@class Room;

@interface MediaItem : NSObject//<NSCoding>

@property NSString* track_title;
@property NSString* artist;
@property NSString* duration;
@property UIImage* artwork;
@property NSString* artwork_url;
@property UIImage* waveform_url;
//Duration of track
@property NSNumber* duration_hours;
@property NSNumber* duration_minutes;
@property NSNumber* duration_seconds;
@property NSString* stream_url;
@property UIImage* waveform;
@property UIImage* playing_animation;
@property NSString* room_number;
@property NSString *download_url;
@property BOOL is_event_mix;
@property BOOL is_local_item;
@property BOOL downloadable;
@property (strong, nonatomic) NSString *local_file_path;
@property NSString *original_format;
@property (strong, nonatomic) NSNumber *sc_id;
@property (strong, retain) NSDictionary *sc_event_song;
@property (strong, nonatomic) NSNumber *size;

@property NSString* username;

- (id) initWithSoundCloudTrack:(NSDictionary *)soundCloudTrack;
- (id) initWIthDict:(NSDictionary*)sds_dict;
-(NSDictionary*)serializeMediaItem;
-(void)setLocalFilePathKey:(NSString*)key;
-(void)makeLocalTrack:(NSString*)file_path;
-(void)makeNotLocalTrack;

@end
