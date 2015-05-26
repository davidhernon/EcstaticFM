//
//  SDSAPI.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "RoomsViewController.h"
@interface SDSAPI : NSObject


+(NSString*)getWebsiteURL;
+(NSArray*)getUpcomingEvents;
+(void)login:(NSString*)username password:(NSString*)password;
+(void)fbLogin;
+(void)createRoom:(NSString*)params;
+(void)aroundMe:(NSString*)username withID:(id)sender;
+(void)connect;
+(void) sendMediaItemToServer:(MediaItem*)media_item;
+(void)postLocation:(NSString*)username withLatitude:(float)latitude withLongitude:(float)longitude;

@end
