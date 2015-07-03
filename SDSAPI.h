//
//  SDSAPI.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "RoomsViewController.h"
#import "Room.h"
#import "MediaItem.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "UIAroundMeView.h"
@class Player;
@class LoginViewController;
@class SocketIOClient;
@interface SDSAPI : NSObject

@property ChatViewController* chatViewController;
+(void)connect;

+(void)createRoom:(NSString*)params;
+(void)updatePlayerState;
+(void)sendText:(NSString*)textMessage;
+(void)realtimePlayer:(NSString*)command;
+(void)deleteSong:(NSInteger)indexToDelete;
+(void)leaveRoom;
+(void)joinRoom:(NSString*)new_room_number withUser:(NSString*)host_username isEvent:(BOOL)isEvent withTrack:(MediaItem*)event_track;
+(void)setCreateRoomBool:(bool)passedCreateRoomBool;

+(void)aroundMe:(NSString*)username withID:(id)sender;
+(void)sendMediaItemToServer:(MediaItem*)media_item;
+(void)postLocation:(NSString*)username withLatitude:(float)latitude withLongitude:(float)longitude;
+(void)getPlaylist:(NSString*)room_number;
+(void)getPlayerState:(NSString*)room_number;
+(void)getChatBacklog;
+(bool)getCreateRoomBool;
+(void)user_connect;
@end
