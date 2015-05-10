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

@interface MediaItem : NSObject//<NSCoding>

@property NSString* track_title;
@property NSString* artist;
@property NSString* duration;
@property UIImage* artwork;
@property UIImage* waveform_url;
//Duration of track
@property NSNumber* duration_hours;
@property NSNumber* duration_minutes;
@property NSNumber* duration_seconds;
@property NSString* stream_url;
@property UIImage* waveform;
@property UIImage* playing_animation;

- (id) initWithSoundCloudTrack:(NSDictionary *)soundCloudTrack;

@end
