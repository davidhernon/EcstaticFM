//
//  SDSAPI.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//
#import "SDSAPI.h"
#import "EcstaticFM-Swift.h"
#import "LoginViewController.h"
#import "Player.h"
@implementation SDSAPI

static SocketIOClient *static_socket;
static bool createRoomBool;

+ (void) connect{
    static_socket = [[SocketIOClient alloc] initWithSocketURL:@"http://squad.fm:8080" options:nil];
    
    [static_socket on: @"connect" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"connected");
    }];
    
    [static_socket on: @"return_post_location" callback: ^(NSArray* data, void (^ack)(NSArray*)){
        NSLog(@"Posted a location");
    }];
    
    [static_socket on:@"return_create_room" callback:^(NSArray * data, void (^ack) (NSArray*)){
        NSLog(@"create room returned,%@", data[0]);
        NSDictionary* room_info_dict =[((NSDictionary*) data[0]) objectForKey:@"room_info"];
        //        NSArray* room_info = [room_info_dict objectForKey:@"room_info"];
        [[Room currentRoom] initWithDict:room_info_dict];
    }];
    
    [static_socket on:@"join" callback:^(NSArray * data, void (^ack) (NSArray*)){
		Mixpanel *mixpanel = [Mixpanel sharedInstance];
		[mixpanel track:@"joined_room"];
        NSLog(@"another user just joined you in the room");
    }];
	
	[static_socket on:@"return_chat_backlog" callback:^(NSArray * data, void (^ack) (NSArray*)){
		NSLog(@"return_chat_backlog returned,%@", data[0]);
		NSArray* chatLog =[((NSDictionary*) data[0]) objectForKey:@"chatlog"];
		NSString* username =[((NSDictionary*) data[0]) objectForKey:@"username"];

		AppDelegate* appDelegate = [[UIApplication sharedApplication]delegate];
		[appDelegate.chatViewController addChatLog:username content:chatLog];
	}];
	
	[static_socket on:@"leave_room" callback:^(NSArray * data, void (^ack) (NSArray*)){
		NSLog(@"one of the users just left the room");
	}];
	
	
	[static_socket on:@"send_text" callback:^(NSArray * data, void (^ack) (NSArray*)){
		NSLog(@"send_text returned,%@", data[0]);
		Mixpanel *mixpanel = [Mixpanel sharedInstance];
		[mixpanel track:@"chat_text"];
		NSString* textMessage =[((NSDictionary*) data[0]) objectForKey:@"textMessage"];
		NSString* username =[((NSDictionary*) data[0]) objectForKey:@"username"];
        NSString* timestamp = [((NSDictionary*) data[0]) objectForKey:@"timestamp"];
		AppDelegate* appDelegate = [[UIApplication sharedApplication]delegate];
        
		[appDelegate.chatViewController addChatText:username content:textMessage];
	}];

    
    [static_socket on:@"get_player_status" callback:^(NSArray * data, void (^ack) (NSArray*)){
        NSDictionary *d = (NSDictionary*)data[0];
        NSString *player_state_string = (NSString*)[d objectForKey:@"player_state"];
        if(player_state_string == NULL){
            NSLog(@"");
        }
        NSData *objectData = [player_state_string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *player_state = [NSJSONSerialization JSONObjectWithData:objectData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        
        
        if(player_state == NULL || player_state == (id)[NSNull null] )
        {
			[[Player sharedPlayer] joinRoom:0 withElapsedTime:0.0f andIsPlaying:0 isLocked:false];
            return;
        }
        
        //parse the JSON
        NSNumber *current_time_from_server = (NSNumber*)[d objectForKey:@"current_time"];
        NSNumber *elapsed_time = [NSNumber numberWithInt:[[player_state objectForKey:@"elapsed"] intValue]];
        NSNumber *server_timestamp = (NSNumber*)[player_state objectForKey:@"timestamp"];
        int song_index = [[player_state objectForKey:@"playing_song_index"] intValue];
        int is_playing = [[player_state objectForKey:@"is_playing"] intValue];
		BOOL playing = is_playing;
		BOOL isLocked = [[player_state objectForKey:@"is_locked"] intValue];
		
		//convert into floats
		float ctfs = [current_time_from_server longValue];
		float st = [server_timestamp longValue];
		float et = [elapsed_time intValue];
		float el;
		
		//if it was paused while player_state sitting on server
		if(is_playing == 0){
			el = (float)(1000.0f*et);
		}
		
		//if it was playing while player_state sat on server
		else{
			el = (float)ctfs - (float)st + (float)(1.0f*et);
		}
		
		//joinPlayingRoom call
		[[Player sharedPlayer] joinRoom:song_index withElapsedTime:el andIsPlaying:playing isLocked:isLocked];
    }];
    
    [static_socket on:@"realtime_player" callback:^(NSArray * data, void (^ack) (NSArray*)){
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        NSDictionary *d = (NSDictionary*)data[0];
        NSString *usr = [d objectForKey:@"username"];
        if([usr isEqualToString:username]){
            return;
        }
        NSString *command = [d objectForKey:@"msg_type"];
        if([command isEqualToString:@"play"])
        {
            [[Player sharedPlayer] updatePlaylist];
            [[Player sharedPlayer] play];
        }else if([command isEqualToString:@"pause"])
        {
            [[Player sharedPlayer] updatePlaylist];
            [[Player sharedPlayer] play];
        }else if([command isEqualToString:@"skip"])
        {
            [[Player sharedPlayer] next];
		}else if([command isEqualToString:@"back"])
		{
			[[Player sharedPlayer] last];
		}else if([command isEqualToString:@"lock"])
		{
            [[Player sharedPlayer] setLock:YES];
		}else if([command isEqualToString:@"unlock"])
		{
            [[Player sharedPlayer] setLock:NO];
		}else{
            NSLog(@"unlogged command returned from server!!!!!");
        }
    }];
    
    [static_socket on:@"return_get_playlist" callback:^(NSArray * data, void (^ack) (NSArray*)){
        NSDictionary *d = (NSDictionary*)data[0];
        NSArray* songs = [d objectForKey:@"playlist"];
        NSMutableDictionary *concat_dict = [[NSMutableDictionary alloc] init];
        int counter = 0;
        for(NSString *song in songs)
        {
            NSData *data = [song dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *playlist_dict = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
            [concat_dict setValue:playlist_dict forKey:[NSString stringWithFormat:@"%d", counter]];
            counter++;
        }
        
        [[Playlist sharedPlaylist] initWithDict:concat_dict];
        // may cause app to start playing music before right spot is reached (stop this!)
        [[Playlist sharedPlaylist] reloadPlayer];
        [SDSAPI getPlayerState:[Room currentRoom].room_number];
        // RE Show UI
    }];
    
    [static_socket on:@"add_song" callback:^(NSArray * data, void (^ack) (NSArray*)){
        NSDictionary *song = ((NSDictionary*) data[0]);
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] isEqual:[song objectForKey:@"username"]]){
            return;
        }
        [[Playlist sharedPlaylist] addTrack: [[MediaItem alloc] initWIthDict:song] ];
        [[Playlist sharedPlaylist] reloadPlayer];
        NSLog(@"song received");
    }];
 
    [static_socket on:@"remove_song" callback:^(NSArray * data, void (^ack) (NSArray*)){
        NSDictionary *remove_song_dict = ((NSDictionary*) data[0]);
        if([  [[NSUserDefaults standardUserDefaults] objectForKey:@"username"] isEqual:[remove_song_dict objectForKey:@"username"]]){
            return;
        }
        [[Player sharedPlayer] deleteSongWithDict:remove_song_dict];
    }];
    
    [static_socket on:@"new_owner" callback:^(NSArray * data, void (^ack) (NSArray*)){
        NSDictionary *change_owner_dict = ((NSDictionary*) data[0]);
        NSString *new_owner = [change_owner_dict objectForKey:@"msg"];
        [Room currentRoom].host_username = new_owner;
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] isEqual:new_owner])
           [Room currentRoom].is_owner = YES;
    }];
    
    [static_socket connect];
}

//Rewrite with Async timeout wait
+(void) createRoom:(NSString*)username{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        while(!static_socket.connected){
//            NSLog(@"static_socket connected inside=%d", static_socket.connected);
            [NSThread sleepForTimeInterval:0.1f];
        }
        
        NSDictionary * postDictionary = [NSDictionary dictionaryWithObjects:@[username, username]
                                                                    forKeys:@[@"username", @"room_name"]];
        
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONReadingMutableContainers error:nil];
        [static_socket emitObjc:@"create_room" withItems:@[jsonData]];
    });
}



+(void) aroundMe:(NSString*)username withID:(id)sender{
    NSLog(@"Start of around me");
    [static_socket on: @"return_get_rooms_around_me" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
		NSArray* locationsArray;
		@try {
			NSLog(@"get_rooms_around_me returned,%@", data[0]);
			NSDictionary* locationsDict =(NSDictionary*) data[0];
			locationsArray = [locationsDict objectForKey:@"rooms"];
		}
		@catch (NSException *exception) {
			locationsArray = @[];
			NSLog(@"%@", exception.reason);
		}
		[sender showRoomsScrollView:locationsArray];
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        while(!static_socket.connected){
            //			NSLog(@"static_socket connected inside=%d", static_socket.connected);
            [NSThread sleepForTimeInterval:0.1f];
        }
        
        NSDictionary * postDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: username, nil]
                                                                    forKeys:[NSArray arrayWithObjects:@"username", nil]];
        
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONReadingMutableContainers error:nil];
        [static_socket emitObjc:@"get_rooms_around_me" withItems:@[jsonData]];
    });
    
    
}

+(void)postLocation:(NSString*)username withLatitude:(float)latitude withLongitude:(float)longitude
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(!static_socket.connected)
        {
            [NSThread sleepForTimeInterval:0.1f];
        }
		
		if(![username length] >0){
			NSString* username = @"anonymous disco squid";
			NSLog(@"username, latitude, longitude: %@, %f, %f", username, latitude, longitude);
			NSArray *objects = [NSArray arrayWithObjects:username, @(latitude), @(longitude), nil];
			NSArray *keys = [NSArray arrayWithObjects:@"username", @"latitude", @"longitude", nil];
			NSDictionary *postDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
			NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONReadingMutableContainers error:nil];
			[static_socket emitObjc:@"post_location" withItems:@[jsonData]];
		}
		else{
			NSLog(@"username, latitude, longitude: %@, %f, %f", username, latitude, longitude);
			NSArray *objects = [NSArray arrayWithObjects:username, @(latitude), @(longitude), nil];
			NSArray *keys = [NSArray arrayWithObjects:@"username", @"latitude", @"longitude", nil];
			NSDictionary *postDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
			NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONReadingMutableContainers error:nil];
			[static_socket emitObjc:@"post_location" withItems:@[jsonData]];
		}
    });
}

/**
 Method for Serializing a Media Item and sending it to the server
 Currently only called by soundCloudMediaPicker when a track is added to the playlist
 */
+(void) sendMediaItemToServer:(MediaItem*)media_item
{
    media_item.room_number = [Room currentRoom].room_number;
    NSDictionary* item = [media_item serializeMediaItem];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:item
                                                       options:nil
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Didnt work kid");
    } else {
        [static_socket emitObjc:@"add_song" withItems:@[jsonData]];
    }
    
    
}

+(void)joinRoom:(NSString*)new_room_number withUser:(NSString*)host_username isEvent:(BOOL)isEvent withTrack:(MediaItem*)event_track
{
    
    //TEST if(event_track) then also isEvent
 
    // In Order to join a room we start by removing ourself from the old room
    [SDSAPI leaveRoom];
    
    //If the event is a Room, set the current Room variable
//    [Room currentRoom].is_event = isEvent;
    
    //set up variables to go in the dicts. These contain information about the CURRENT ROOM's state
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *current_room_number_as_string = [NSString stringWithFormat:@"%@",[Room currentRoom].room_number]; //rn
    NSString *is_event_string = isEvent ? @"true" : @"false";
    
    //set up the dictionaries to send to server
    NSMutableDictionary *joinDict  = [NSMutableDictionary dictionaryWithObjects:@[new_room_number, username, is_event_string] forKeys:@[@"room_number", @"username", @"is_event"]];
    
    if(event_track)
    {
        //spoofing username so we get the playlist properly
        NSMutableDictionary *media_item = [[NSMutableDictionary alloc] init];
        media_item = [NSMutableDictionary dictionaryWithDictionary:[event_track serializeMediaItem]];
        [media_item setObject:@"" forKey:@"username"];
        
        //add the item to the event
        [joinDict setValue:media_item forKey:@"media_item"];
    }
    
    //serialize the Dict
    NSData *joinJson = [NSJSONSerialization dataWithJSONObject:joinDict options:nil error:nil];
    //send join and leave messages
    [static_socket emitObjc:@"join_room" withItems:@[joinJson]];
    
    //update the currentRoom's state
    [Room currentRoom].room_number = new_room_number;
    [Room currentRoom].is_event = isEvent;
    
    if([username isEqualToString:host_username]){
        [[Room currentRoom] makeOwner];
    }
    else{
        [[Room currentRoom] makeNotOwner];
    }
    
    [Room currentRoom].host_username = host_username;
    
    NSDictionary *playlist_query = [NSDictionary dictionaryWithObjects:@[new_room_number] forKeys:@[@"room_number"]];
    NSData *json = [NSJSONSerialization dataWithJSONObject:playlist_query options:nil error:nil];
    [static_socket emitObjc:@"get_playlist" withItems:@[json]];
    
}



+(void)getPlayerState:(NSString*)room_number
{
    NSDictionary *gps  = [NSDictionary dictionaryWithObjects:@[room_number] forKeys:@[@"room_number"]];
    NSData *json = [NSJSONSerialization dataWithJSONObject:gps options:nil error:nil];
    [static_socket emitObjc:@"get_player_status" withItems:@[json]];
}

+(void)getPlaylist:(NSString*)room_number
{
    NSDictionary *playlist_query = [NSDictionary dictionaryWithObjects:@[room_number] forKeys:@[@"room_number"]];
    NSData *json = [NSJSONSerialization dataWithJSONObject:playlist_query options:nil error:nil];
    [static_socket emitObjc:@"get_playlist" withItems:@[json]];
}

+ (void)play
{
    NSString *room_number = [Room currentRoom].room_number;
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if([room_number isEqualToString:nil])
    {
        room_number = @"0";
    }
    NSDictionary *play_query = [NSDictionary dictionaryWithObjects:@[username, room_number, @"play", [self getDictForPlayerState]] forKeys:@[@"username", @"room_number", @"msg_type", @"player_state"]];
    NSData *json = [NSJSONSerialization dataWithJSONObject:play_query options:nil error:nil];
    [static_socket emitObjc:@"player" withItems:@[json]];
}

+ (NSDictionary*) getDictForPlayerState
{
    NSString *elspd = [NSString stringWithFormat:@"%i",(int)CMTimeGetSeconds([Player sharedPlayer].avPlayer.currentTime)];
    if([elspd isEqual:[NSString stringWithFormat:@"%i",INT_MIN]])
    {
        elspd = @"0";
    }
    return [NSDictionary dictionaryWithObjects:@[ [NSString stringWithFormat:@"%i",[[Player sharedPlayer] isPlaying]], [NSString stringWithFormat:@"%i",[[Player sharedPlayer] player_is_locked]], [NSString stringWithFormat:@"%i", [Player sharedPlayer].currentTrackIndex], elspd] forKeys:@[@"is_playing", @"is_locked", @"playing_song_index", @"elapsed"]];
}

+(void) sendText:(NSString*)textMessage
{
    NSString *room_number = [Room currentRoom].room_number;
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSNumber *time_now = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    
    NSDictionary *textDict = [NSDictionary dictionaryWithObjects:@[room_number, textMessage, username, time_now] forKeys:@[@"room_number", @"textMessage", @"username", @"timestamp"]];
    NSData *json = [NSJSONSerialization dataWithJSONObject:textDict options:nil error:nil];
    [static_socket emitObjc:@"send_text" withItems:@[json]];
}

+(void)realtimePlayer:(NSString*)command
{
	NSLog(@"User Hit realtimePlayer = %@", command);
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
	NSString *room_number = [Room currentRoom].room_number;
	NSDictionary *ps = [self getDictForPlayerState];
	NSDictionary *update_query = [NSDictionary dictionaryWithObjects:@[room_number, command, username, ps] forKeys:@[@"room_number", @"msg_type", @"username", @"player_state"]];
	NSData *json = [NSJSONSerialization dataWithJSONObject:update_query options:nil error:nil];
	[static_socket emitObjc:@"player" withItems:@[json]];
}

+(void) getChatBacklog{
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
	NSDictionary * postDictionary = [NSDictionary dictionaryWithObjects:@[username, [Room currentRoom].room_number]
																forKeys:@[@"username", @"room_number"]];
	
	NSData * jsonData = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONReadingMutableContainers error:nil];
	[static_socket emitObjc:@"get_chat_backlog" withItems:@[jsonData]];

}

+(void)deleteSong:(NSInteger)indexToDelete
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *room_number = [Room currentRoom].room_number;
    NSString *index_to_delete = [NSString stringWithFormat:@"%i",indexToDelete ];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjects:@[username, room_number, index_to_delete] forKeys:@[@"username", @"room_number", @"index_to_delete"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONReadingMutableContainers error:nil];
    [static_socket emitObjc:@"remove_song" withItems:@[jsonData]];
}

+(void)leaveRoom
{
    [[Playlist sharedPlaylist] clearPlaylist];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *isowner = [Room currentRoom].is_owner ? @"true" : @"false";
    NSDictionary *leaveDict  = [NSDictionary dictionaryWithObjects:@[[Room currentRoom].room_number, username, isowner ] forKeys:@[@"room_number", @"username", @"is_owner"]];
    NSData *leaveJson = [NSJSONSerialization dataWithJSONObject:leaveDict options:nil error:nil];
    [static_socket emitObjc:@"leave_room" withItems:@[leaveJson]];
}

+(void)user_connect
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSDictionary *connectDict  = [NSDictionary dictionaryWithObjects:@[ username ] forKeys:@[ @"username"]];
    NSData *connectJson = [NSJSONSerialization dataWithJSONObject:connectDict options:nil error:nil];
    [static_socket emitObjc:@"connect" withItems:@[connectJson]];
}

+(BOOL)getCreateRoomBool{
	return createRoomBool;
}

+(void)setCreateRoomBool:(BOOL)passedCreateRoomBool{
	createRoomBool = passedCreateRoomBool;
}

@end