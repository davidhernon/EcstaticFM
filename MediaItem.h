//
//  MediaItem.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-25.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MediaItem : NSObject//<NSCoding>

@property NSString* track_title;
@property NSString* artist;
@property NSString* duration;
@property UIImage* artwork;
//Duration of track
@property NSNumber* duration_hours;
@property NSNumber* duration_minutes;
@property NSNumber* duration_seconds;
@property NSString* stream_url;

- (id) initWithSoundCloudTrack:(NSDictionary *)soundCloudTrack;
-(NSString*)convertTimeFromMillis:(int)millis;

@end
