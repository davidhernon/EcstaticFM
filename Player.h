//
//  Player.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-12.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "playlist.h"

@interface Player : NSObject

@property AVPlayer* player;
@property Playlist* playlist;



@end
