//
//  Utils.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-18.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "Utils.h"
#import "SCUI.h"
#import "MediaItem.h"
#import "PlayerViewController.h"


@implementation Utils
@synthesize queryFromSoundCloud;



+(UIColor *)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(NSMutableString*) floatToText: (Float64)time{
    NSString *hours = [NSString stringWithFormat:@"%uh ", (int) time/3600];
    time = (int)time % 3600;
    NSString *mins = [NSString stringWithFormat:@"%um ", (int) time/60];
    time = (int)time % 60;
    NSString *seconds = [NSString stringWithFormat:@"%us ", (int) time];
    NSMutableString *timeString = [[NSMutableString alloc] initWithString:hours];
    
    [timeString appendString:mins];
    [timeString appendString:seconds];
    return timeString;
}

+(NSString*)convertTimeFromMillis:(int)millis
{
    NSInteger seconds = (NSInteger) (millis / 1000) % 60 ;
    NSInteger minutes = (NSInteger) ((millis / (1000*60)) % 60);
    NSInteger hours   = (NSInteger) ((millis / (1000*60*60)) % 24);
    if(hours != 0){
        NSString *minute_string;
        NSString *seconds_string;
        if(minutes < 10)
        {
            minute_string = [NSString stringWithFormat:@"0%ld",minutes];
        }else
        {
            minute_string = [NSString stringWithFormat:@"%ld",minutes];
        }
        if(seconds < 10)
        {
            seconds_string = [NSString stringWithFormat:@"0%ld",seconds];
        }else
        {
            seconds_string = [NSString stringWithFormat:@"%ld",seconds];
        }
        return [NSString stringWithFormat:@"%ld:%@:%@",hours,minute_string,seconds_string];
        
    }else{
        if(seconds < 10)
        {
            return [NSString stringWithFormat:@"%ld:0%ld",minutes,seconds];
        }else
        {
           return [NSString stringWithFormat:@"%ld:%ld",minutes,seconds];
        }
    }
}

+(NSString*)convertSecondsToCountdownString:(double)num_seconds
{
    int days = num_seconds / (60 * 60 * 24);
    num_seconds -= days * (60 * 60 * 24);
    int hours = num_seconds / (60 * 60);
    num_seconds -= hours * (60 * 60);
    int minutes = num_seconds / 60;
    
    if(days != 0){
        NSString *day_string = [self convertIntToStringWithFormat:days];
        return [NSString stringWithFormat:@"%@ days",day_string];
    }else if(hours != 0){
        NSString *hour_string = [self convertIntToStringWithFormat:hours];
        return [NSString stringWithFormat:@"%@ hours",hour_string];
    }else{
        NSString *minute_string = [self convertIntToStringWithFormat:minutes];
        return [NSString stringWithFormat:@"%@ minutes",minute_string];
    }
    
    return @"converting seconds into Countdown String failed :)";
}

+(NSString*)convertIntToStringWithFormat:(int)num
{
    NSString *ret = [[NSString alloc] init];
    if(num < 10)
    {
        ret = [NSString stringWithFormat:@"0%i",num];
    }else{
        ret = [NSString stringWithFormat:@"%i", num];
    }
    return ret;
}

/**
 Downloads a remote file from a http URL to the local file system. At the completion of the download it writes the file to the local system, under Documents. The file path can be returned from NSUserDefaults using a key made from the parsed download_url
 */
+(void)downloadSongFromURL:(NSString*)download_url withRoomNumber:(NSString*)room_number withMediaItem:(MediaItem*)track withSender:(PlayerViewController*)sender
{
    // parse download url into
//    NSString *parsed_download_url = [Utils getParsedURL:download_url];
    
//    NSString *folderPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/",[Utils getParsedURL:track.track_title]]];
    NSLog(@"download url: %@", download_url);
    
    TCBlobDownloadManager *sharedManager = [TCBlobDownloadManager sharedInstance];
    
    [sharedManager cancelAllDownloadsAndRemoveFiles:YES];

    //SENDER start running load image
    //SENDER change download button to "In Progress: "
    
    
    TCBlobDownloader *downloader = [sharedManager startDownloadWithURL:[NSURL URLWithString:download_url ]
                                                            customPath:nil
                                                         firstResponse:^(NSURLResponse *response) {
                                                             NSLog(@"anything!");
                                                         }
                                                              progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress) {
                                                                  // downloader.remainingTime
                                                                  // downloader.speedRate
                                                                  //SENDER update progress
                                                                  [sender setIsDownloading];
                                                                  NSLog(@"getting data, progress: %f", progress);
                                                                  [sender updateDownloadProgress:progress];
                                                              }
                                                                 error:^(NSError *error) {
                                                                     NSLog(@"was there error?: %@", error.description);
//                                                                     [downloader cancelDownloadAndRemoveFile:YES];
//                                                                     [self downloadSongFromURL:download_url withRoomNumber:room_number withMediaItem:track];
//                                                                     return;
                                                                 }
                                                              complete:^(BOOL downloadFinished, NSString *pathToFile) {
                                                                  NSLog(@"Utility Module - downloadSongFromURL:withRoomNumber:withMediaItem: - Done downloading item with file path %@", pathToFile);
                                                                  
                                                                  // If Path To File is null then we return
                                                                  // This is an interesting flow from TCBlobDownloader where on a download we hit the completion block with an unfinished download and (null) path to file. We should just return and move on at this point because we will hit the completion block again with a complete download in a few ms
                                                                  if(!pathToFile)
                                                                  {
                                                                      return;
                                                                  }
                                                                  
                                                                  NSData *data = [[NSFileManager defaultManager] contentsAtPath:pathToFile];
                                                                  
                                                                  //write data to path but also save data to trackid_data in userdefaults
                                                                  [Utils writeDataToAudioFile:data forTrack:track];
                                                                  [[NSFileManager defaultManager] removeItemAtPath:pathToFile error:nil];
                                                                  //SENDER stop running load image
                                                                  //SENDER change download button
                                                                  [sender setDownloadFinished];
                                                            
                                                              }];
        [downloader start];
}

//write file to iOS device
// save path to file against the key track id in NSUSerDefaults
+(void)writeDataToAudioFile:(NSData*)data forTrack:(MediaItem*)track
{
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",track.sc_id,track.original_format];
    
    NSString *pathName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask,
                                                                  YES) firstObject]
                             stringByAppendingPathComponent:fileName];
    
    [[NSFileManager defaultManager] createFileAtPath:pathName
                                            contents:data
                                          attributes:nil];
    
    [track makeLocalTrack:pathName];

}

@end