//
//  MediaItem.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-25.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaItem : NSObject

@property NSString* trackTitle;
@property NSString* artist;
@property NSString* owner; //which user added the song

@end
