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
#import "MWLogging.h"

@class Player;

@interface Room : NSObject

// location
// title
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UILabel *location;

@property BOOL is_event;

@property (weak, nonatomic) NSString* other_listeners;
@property (weak, nonatomic) Playlist* playlist;
@property (weak, nonatomic) Player* player;

@property (retain, nonatomic) NSString* host_username;

@property (retain, nonatomic) NSString* room_number;
@property BOOL is_owner;

-(int)getNumberOfListenersInRoom;
+ (Room*)currentRoom;
-(Playlist*)getRoomPlaylist;
-(Player*)getRoomPlayer;
-(void)addMediaItemToPlaylist:(MediaItem*)media_item;
-(void)initWithDict:(NSDictionary*)room_info;
-(void)makeNotOwner;
-(void)makeOwner;


// playlist
//


@end
