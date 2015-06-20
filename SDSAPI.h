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
@property NSTimer *login_timer;
@property NSString *email;
+(NSString*)getWebsiteURL;
+(NSArray*)getUpcomingEvents;
+(void)signup:(NSString*)username password:(NSString*)pass email:(NSString*)email ID:(id)callingViewController;
+(void)login:(NSString*)username password:(NSString*)password ID:(id)callingViewController;
+(void)fbLogin;
+(void)createRoom:(NSString*)params;
+(void)aroundMe:(NSString*)username withID:(id)sender;
+(void)connect;
+(void)sendMediaItemToServer:(MediaItem*)media_item;
+(void)postLocation:(NSString*)username withLatitude:(float)latitude withLongitude:(float)longitude;
+(void)joinRoom:(NSString*)room_number withUser:(NSString*) user;
+(void)leaveRoom;
+(void)getPlaylist:(NSString*)room_number;
+(void)getPlayerState:(NSString*)room_number;
+(void)updatePlayerState;
+(void)sendText:(NSString*)textMessage;
+(void)realtimePlayer:(NSString*)command;
+(void)getChatBacklog;
+(void)logout;
+(void)deleteSong:(NSInteger)indexToDelete;
+(SocketIOClient*)get_static_socket;

@end
