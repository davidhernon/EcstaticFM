//
//  SDSAPI.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDSAPI : NSObject

+(NSString*)getWebsiteURL;
+(NSArray*)getUpcomingEvents;

@end
