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

+(NSString*)convertSecondsToTime:(double)num_seconds
{
    int days = num_seconds / (60 * 60 * 24);
    num_seconds -= days * (60 * 60 * 24);
    int hours = num_seconds / (60 * 60);
    num_seconds -= hours * (60 * 60);
    int minutes = num_seconds / 60;
    
    
    NSString *day_string = [self convertIntToStringWithFormat:days];
    NSString *hour_string = [self convertIntToStringWithFormat:hours];
    NSString *minute_string = [self convertIntToStringWithFormat:minutes];
    
    return [NSString stringWithFormat:@"%@:%@:%@", day_string, hour_string, minute_string];
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
+(void)downloadSongFromURL:(NSString*)download_url withRoomNumber:(NSString*)room_number withMediaItem:(MediaItem*)track
{
    // parse download url into
    NSString *parsed_download_url = [Utils getParsedURL:download_url];
        
    NSString *folderPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/",[Utils getParsedURL:track.track_title]]];
    
    TCBlobDownloadManager *sharedManager = [TCBlobDownloadManager sharedInstance];
    
    [sharedManager cancelAllDownloadsAndRemoveFiles:YES];

    TCBlobDownloader *downloader = [sharedManager startDownloadWithURL:[NSURL URLWithString:download_url ]
                                                            customPath:folderPath
                                                         firstResponse:^(NSURLResponse *response) {
                                                             NSLog(@"anything!");
                                                         }
                                                              progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress) {
                                                                  // downloader.remainingTime
                                                                  // downloader.speedRate
                                                                  NSLog(@"getting data, progress: %f", progress);
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
                                                                  
                                                                  //At this point, completion block finished with a complete download
                                                                  
                                                                  //Item downloaded will be called /download we need to rename it with NSFileManager to /download.[track_format] (i.e. /download.mp3 or /download.m4a
//                                                                  NSError * err = NULL;
//                                                                  NSFileManager * fm = [[NSFileManager alloc] init];
//                                                                  BOOL result = [fm moveItemAtPath:pathToFile toPath:[NSString stringWithFormat:@"%@.%@",pathToFile, track.original_format] error:&err];
                                                                  
//                                                                  NSLog(@"Utility Module - downloadSongFromURL:withRoomNumber:withMediaItem: - Move item to final location at: %@", [NSString stringWithFormat:@"%@.%@",pathToFile, track.original_format]);
                                                                  
                                                                  //Operation completed with an error
//                                                                  if(!result)
//                                                                      NSLog(@"Utility Module - downloadSongFromURL:withRoomNumber:withMediaItem: - File Move Operation Failed in Completion Block: %@", err);
                                                                  
                                                                  NSData *data = [[NSFileManager defaultManager] contentsAtPath:pathToFile];
                                                                  
                                                                  //write data to path but also save data to trackid_data in userdefaults
                                                                  [Utils writeDataToAudioFile:data forTrack:track];
                                                                  [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"%@_data",track.sc_id]];
                                                                  
                                                                  
                                                                  // Set the resultant local path to the track
//                                                                  track.local_file_path = [NSString stringWithFormat:@"%@.%@",pathToFile, track.original_format];
//                                                                  track.is_local_item = YES;
                                                                  
                                                                  // Save the local path with a unique key into NSUSerDefaults in order to get the file back at a later date
//                                                                  [[NSUserDefaults standardUserDefaults] setObject:track.local_file_path forKey:parsed_download_url];
//                                                                  NSLog(@"Printing key and object for storage: %@ for key %@",track.local_file_path,parsed_download_url);
                                                                  
                                                                  //EXPERIMENTAL
                                                                  // Save NSData in NSUserDefaults to use later as a URL
//                                                                  NSURL *url = [[NSURL alloc] initFileURLWithPath: track.local_file_path];
////                                                                  NSData *data = [[NSFileManager defaultManager] contentsAtPath:track.local_file_path];
//                                                                  NSString *data_key = [NSString stringWithFormat:@"%@_data",parsed_download_url];
////                                                                  [[NSUserDefaults standardUserDefaults] setObject:data forKey:data_key];
////                                                                  track.ns_defaults_data_key = data_key;
//                                                                  
//                                                                  // Do we need to do this on the main thread?
//                                                                  dispatch_async(dispatch_get_main_queue(), ^{
//                                                                      [Utils saveDownloadData:data forKey:data_key onTrack:track];
//                                                                  });
                                                                  
                                                                  
//                                                                  track.local_file_path = pathToFile;
                                                              }];
    [downloader start];
}


/**
 A tool for parsing a download URL and returning a parsed string which can be used as a unique identifier to the file
 */
+(NSString*)getParsedURL:(NSString*)url
{
    NSString *parsed_download_url = [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    parsed_download_url = [parsed_download_url stringByReplacingOccurrencesOfString:@":" withString:@"-"];
    parsed_download_url = [parsed_download_url stringByReplacingOccurrencesOfString:@"?" withString:@"-"];
    parsed_download_url = [parsed_download_url stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [parsed_download_url stringByReplacingOccurrencesOfString:@"." withString:@"-"];
}

+(void)saveDownloadData:(NSData*)data forKey:(NSString*)key onTrack:(MediaItem*)track
{
    NSLog(@"%@",track.sc_id);
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"%@",track.sc_id]];
//    track.ns_defaults_data_key = key;
    [track setLocalFilePathKey:key];
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
    
    [[NSUserDefaults standardUserDefaults] setObject:pathName forKey:[NSString stringWithFormat:@"%@",track.sc_id]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:documentsPath];
    
    for (NSString *filename in fileEnumerator) {
        NSLog(@"String of filename: %@", filename);
    }
}

//return the local URL for a given tracks file
+(NSURL*)getLocalURLForTrack:(MediaItem*)track
{
    
    NSString *path_name = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@",track.sc_id ]];
    NSURL *file_path = [NSURL fileURLWithPath:path_name];
    return file_path;
    
}

@end