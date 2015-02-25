//
//  Player.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-12.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "Player.h"
#import "Playlist.h"

@implementation Player

-(id)init{
    self=[super init];
    if(self){
        //Do custom init work
        [self createPlayer];
        [self initializePlaylist];
    }
    return  self;
}

-(AVPlayer*) createPlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _player = [[AVPlayer alloc] init];
    });
    return _player;
}

-(void) initializePlaylist
{
    _playlist = [Playlist sharedPlaylist];
}

@end
