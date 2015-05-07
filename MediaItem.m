//
//  MediaItem.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-25.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "MediaItem.h"

@implementation MediaItem

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



- (id) initWithSoundCloudTrack:(NSDictionary *)soundCloudTrack
{
    self = [super init];
    if(self)
    {
        self.track_title = [soundCloudTrack objectForKey:@"title"];
        self.artist = [[soundCloudTrack objectForKey:@"user"] objectForKey:@"username"];
        self.duration = [NSString stringWithFormat:@"%@", [self convertTimeFromMillis:(int) [[soundCloudTrack objectForKey:@"duration"] intValue]]];
        
        //Manipulate url to grab larger image from soundcloud api
        NSString* artwork_url_string = [soundCloudTrack objectForKey:@"artwork_url"];
        NSString* artwork_url_string_mod = [artwork_url_string stringByReplacingOccurrencesOfString:@"large.jpg"
                                             withString:@"t500x500.jpg"];
        self.artwork = [self addAlbumArtwork:artwork_url_string_mod];
        
        self.stream_url = [soundCloudTrack objectForKey:@"stream_url"];
        self.waveform = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[soundCloudTrack objectForKey:@"waveform"]]]];
    }
    return self;
}

-(UIImage*)addAlbumArtwork:(NSString*)stringURL
{
    if([stringURL isEqual:[NSNull null]]){
        stringURL = @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi8MYn94Vl1HVxqMb7u31QSRa3cNCJOYhxw7xI_GGDvcSKQ7xwPA370w";
    }
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:stringURL]]];
    
}

-(UIImage*)addWaveform:(NSString*)stringURL
{
    if([stringURL isEqual:[NSNull null]]){
        stringURL = @"http://w1.sndcdn.com/fxguEjG4ax6B_m.png";
    }
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:stringURL]]];
    
}

-(NSString*)convertTimeFromMillis:(int)millis
{
    NSNumber* seconds = [NSNumber numberWithInt:(millis / 1000) % 60];
    NSNumber* minutes = [NSNumber numberWithInt:((millis / (1000*60)) % 60)];
    NSNumber* hours   = [NSNumber numberWithInt:((millis / (1000*60*60)) % 24)];
    self.duration_seconds = seconds;
    self.duration_minutes = minutes;
    self.duration_hours = hours;
    if(hours != 0){
        return [NSString stringWithFormat:@"%@:%@:%@",hours.stringValue,minutes.stringValue,seconds.stringValue];
    }else{
        return [NSString stringWithFormat:@"%@:%@",minutes.stringValue,seconds.stringValue];
    }
}



@end
