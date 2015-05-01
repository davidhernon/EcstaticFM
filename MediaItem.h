//
//  MediaItem.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-25.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MediaItem : NSObject//<NSCoding>

@property NSString* track_title;
@property NSString* artist;
@property NSString* duration; //which user added the song
@property UIImage* artwork;

@end
