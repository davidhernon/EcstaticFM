//
//  Utils.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-18.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <TCBlobDownload/TCBlobDownload.h>
@class MediaItem;

@interface Utils : NSObject
@property NSJSONSerialization* queryFromSoundCloud;


+(UIColor*) colorWithHexString:(NSString*)hex;
+(NSMutableString*) floatToText: (Float64)time;
+(NSString*)convertTimeFromMillis:(int)millis;
+(NSString*)convertSecondsToCountdownString:(double)num_seconds;
+(void)downloadSongFromURL:(NSString*)download_url withRoomNumber:(NSString*)room_number withMediaItem:(MediaItem*)track;
+(void)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath;
+(NSString*)getParsedURL:(NSString*)url;
@end

