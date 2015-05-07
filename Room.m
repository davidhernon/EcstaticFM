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

+ (Room*)currentRoom
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentRoom = [[Room alloc] init];
    });
    return currentRoom;
}

@end
