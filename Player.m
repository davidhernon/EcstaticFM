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

- (void) addDelegate:(id)sender
{
    _delegate = sender;
}

-(void) updatePlaylist
{
    ecstaticPlayer.playlist = [Playlist sharedPlaylist];
    [_delegate updatePlaylistTable];
}

-(void)play
{
    [self updatePlaylist];
    if(_avPlayer.rate == 0)
    {
        NSLog(@"rate: %f",_avPlayer.rate);
        if(!_currentTrack)
        {
            if([_playlist count] > 0)
            {
                _currentTrack = [_playlist objectAtIndex:0];
                [[Playlist sharedPlaylist] removeTrack:_currentTrack];
                [self updatePlaylist];
            }else{
                return;
            }
        }else{
            [_avPlayer play];
        }
        
        
    }else{
        NSLog(@"rate %f",_avPlayer.rate);
        [_avPlayer pause];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@", _currentTrack.stream_url,[SoundCloudAPI getClientID]];//Your client ID
    
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:urlString]
             usingParameters:nil
                 withAccount:[SCSoundCloud account]
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                 NSError *playerError;
                 NSLog(@"data:%@",data);
                 _avPlayer = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
                 [_avPlayer prepareToPlay];
                 [_delegate initPlayerUI:[_avPlayer duration] withTrack:_currentTrack];
                 _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
                 [_avPlayer play];
             }];
    
    
    
}

-(void)updateTime
{
    [_delegate setCurrentSliderValue:_avPlayer];
    if(!_avPlayer.playing){
        [self audioPlayerDidFinishPlaying:_avPlayer successfully:YES];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    
    _currentTrack = nil;
    [ecstaticPlayer updatePlaylist];
    _avPlayer.rate = 0;
    [ecstaticPlayer play];
}

-(void)seek:(float)value
{
    if(_avPlayer.rate != 0)
    {
        _avPlayer.currentTime = value;
    }
}

-(void) pause
{
    [_avPlayer pause];
}

-(void)next
{

}

-(void)last
{
    
}

@end
