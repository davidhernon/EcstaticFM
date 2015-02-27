//
//  Utils.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-18.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "Utils.h"
#import "SCUI.h"

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

+(NSString*)getWebsiteURL
{
    return @"http://54.173.157.204/appindex.html/";
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

+(NSJSONSerialization*)soundCloudRequest:(id)sender
{
    
    SCAccount *account = [SCSoundCloud account];
    
    if(account == nil){
        // TODO:
        NSLog(@"SoundCloud account was nil, need to sign in!");
        return nil;
    }
//TDO is alloc initing queryFromSoundCloud a bad move?
    __block NSJSONSerialization* queryFromSoundCloud;
    NSString *resourceURL = @"https://api.soundcloud.com/me/favorites.json";
    __block bool soundCloudReturn = FALSE;
    
    id obj = [SCRequest performMethod:SCRequestMethodGET
                           onResource:[NSURL URLWithString:resourceURL]
                      usingParameters:nil
                          withAccount:account
               sendingProgressHandler:nil
                      responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                          // Handle the response
                          if (error) {
                              NSLog(@"SoundCloud Query failed on return: %@", [error localizedDescription]);
                          } else {
                              // Check the statuscode and parse the data
                              NSError *jsonError = nil;
                              NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                                                   JSONObjectWithData:data
                                                                   options:0
                                                                   error:&jsonError];
                              if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
                                  NSLog(@"successfully responded to SoundCloud");
                                  queryFromSoundCloud = jsonResponse;
                              }
                              soundCloudReturn = TRUE;
                          }
                      }];
    while(soundCloudReturn == FALSE)
    {
        [NSThread sleepForTimeInterval:0.1f];
    }
    return queryFromSoundCloud;
    
}




@end