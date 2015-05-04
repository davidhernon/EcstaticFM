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

static Player *ecstaticPlayer = nil;
//static AVPlayer *avPlayer = nil;

-(id)init{
    self=[super init];
    if(self){
        //Do custom init work
        [self updatePlaylist];
    }
    return  self;
}

+ (Player*)sharedPlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ecstaticPlayer = [[Player alloc] init];
        ecstaticPlayer.avPlayer = [[AVPlayer alloc] init];
    });
    return ecstaticPlayer;
}

-(void) updatePlaylist
{
    ecstaticPlayer.playlist = [Playlist sharedPlaylist];
}

-(void)play
{
    [self updatePlaylist];
////    If play rate = 0, or player has an error
//    if(avPlayer.rate == 0 || avPlayer.error)
//    {
////        If there is no current Track and there are items in the Playlist
//        if(!ecstaticPlayer.currentTrack && [ecstaticPlayer.playlist count] != 0)
//        {
//            ecstaticPlayer.currentTrack = [ecstaticPlayer.playlist objectAtIndex:0];
//            [[Playlist sharedPlaylist] removeTrack:ecstaticPlayer.currentTrack];
//            [self updatePlaylist];
////            WARNING: Recursion here could cause infinite loop
//            [self play];
//        }else{
////            There is a currentTrack but its not playing
//            
//        }
//    }
//    Check if player is playing or has an error
        if(_avPlayer.rate == 0 || _avPlayer.error)
        {
//          There is no current track
            if(!_currentTrack){
//              Playlist has more than 0 items in it
                if([_playlist count] > 0){
                    _currentTrack = [_playlist objectAtIndex:0];
                    [[Playlist sharedPlaylist] removeTrack:_currentTrack];
                    [self updatePlaylist];
//               Else there are no tracks in the playlist, return
                }else{
                    return;
                }
            }
            AVPlayer *player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:_currentTrack.stream_url]];
            _avPlayer = player;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playerItemDidReachEnd:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:[_avPlayer currentItem]];
            [_avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(idle:) userInfo:nil repeats:YES];
            _avPlayer.volume=1.0;
            [_avPlayer play];
            [player play];
        }
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == _avPlayer && [keyPath isEqualToString:@"status"]) {
        if (_avPlayer.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
        } else if (_avPlayer.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
        } else if (_avPlayer.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
        }
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    //  code here to play next sound file
    
}

-(void) pause
{
    
}

-(void)next
{
    
}

-(void)last
{
    
}

@end
