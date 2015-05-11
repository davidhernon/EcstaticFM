//
//  Room.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-07.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Playlist.h"
#import "Player.h"

@interface Room : NSObject

// location
// title
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *location;

@property (weak, nonatomic) NSArray* other_listeners;
@property (weak, nonatomic) Playlist* playlist;
@property (weak, nonatomic) Player* player;

-(int)getNumberOfListenersInRoom;
+ (Room*)currentRoom;
-(Playlist*)getRoomPlaylist;
-(Player*)getRoomPlayer;
-(void)addMediaItemToPlaylist:(MediaItem*)media_item


// playlist
//


@end
