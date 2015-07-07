//
//  Room.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-07.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "Room.h"

@implementation Room

static Room *currentRoom = nil;



-(id)init
{
    self = [super init];
    if(self)
    {
        //initialize
    }
    return self;
}

-(id)initWithStream:(NSString*)streamURL
{
    self = [super init];
    if(self)
    {
        //initialize
    }
    return self;
}

+ (Room*)currentRoom
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MWLogDebug(@"Rooms - Room - currentRoom - initializing new singleton Room");
        currentRoom = [[Room alloc] init];
        currentRoom.room_number = @"0";
        currentRoom.is_owner = YES;
        currentRoom.title.text = [NSString stringWithFormat:@"%@'s Room", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"] ];
        currentRoom.host_username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        currentRoom.is_event = NO;
    });
    return currentRoom;
}

- (void) makeOwner
{
    MWLogDebug(@"Rooms - Room - makeOwner - setting client as Room owner");
    currentRoom.is_owner = YES;
}

- (void) makeNotOwner
{
    MWLogDebug(@"Rooms - Room - makeNowOwner - removing client as room owner");
    currentRoom.is_owner = NO;
}

- (void) initWithDict:(NSDictionary *)room_info
{
    MWLogDebug(@"Rooms - Room - initWithDict: - initializing room with a dict");
    if(!currentRoom)
        [Room currentRoom];
    currentRoom.title.text = [room_info objectForKey:@"room_name"];
    currentRoom.room_number = [room_info objectForKey:@"room_number"];
    currentRoom.host_username = [room_info objectForKey:@"host_username"];
    currentRoom.other_listeners = [room_info objectForKey:@"number_of_users"];
	NSString* usr = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
	if([usr isEqualToString:currentRoom.host_username]){
		[self makeOwner];
	}
    NSLog(@"room number: %@", currentRoom.room_number);
}

//- (void) initWithRoom:(NSDictionary*)room_to_join
//{
//    MWLogDebug(@"Rooms - Room - makeNowOwner - removing client as room owner");
//    if(!currentRoom)
//        [Room currentRoom];
//    
//    currentRoom.title.text = [room_to_join objectForKey:@"title"];
//}

#warning Unfinished Code Block
/**
 Function returns the number of other listeners in the current room
 */
-(int)getNumberOfListenersInRoom
{
    MWLogDebug(@"Rooms - Room - getNumberOfListenersInRoom - dummy method called, always returns 0");
    return 0;
}
//
///**
// Add parameter media_item to this Room's playlist and update the server with the change
// */
//#warning Unfinished Code Block
//-(void)addMediaItemToPlaylist:(MediaItem*)media_item
//{
//#warning Make sure if multiple people add songs they get the right playlist
//    [_playlist addTrack:media_item];
//    //Update Server With the mediaItem
//    //Wait and check server queue to see if playlists match or client needs to reorder
//    //Update Playey
//    //Update PlayerUI
//}
//
///**
// Add parameter media_items to this Room's playlist and update the server with the changes
// */
//#warning Unfinished Code Block
//-(void)addMediaItemsToPlaylist:(NSArray*)media_items
//{
//#warning Make sure if multiple people add songs they get the right playlist
//    [_playlist addTracks:(NSMutableArray*)media_items];
//    //Update Server With the mediaItem
//    //Wait and check server queue to see if playlists match or client needs to reorder
//    //Update Playey
//    //Update PlayerUI
//}

//-(NSInteger*)getRoomNumber
//{
//    return _room_number;
//}

@end
