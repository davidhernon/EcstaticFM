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



@end