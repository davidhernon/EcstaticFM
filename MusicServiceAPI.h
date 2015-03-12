//
//  MusicServiceAPI.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaItem.h"

@protocol MusicServiceAPI <NSObject>
@required
+(NSArray*) getFavorites;
@optional
+(MediaItem*) getTrack;
+(NSArray*) searchTracks:(NSString*)query;

@end
