//
//  Utils.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-18.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Utils : NSObject
@property NSJSONSerialization* queryFromSoundCloud;


+(UIColor*) colorWithHexString:(NSString*)hex;
+(NSMutableString*) floatToText: (Float64)time;
+(NSString*)convertTimeFromMillis:(int)millis;
+(NSString*)convertSecondsToTime:(double)num_seconds;
@end

