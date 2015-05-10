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
        [self updatePlaylist];
    }
    return  self;
}

/**
 Singleton Constructor for creating a single Player Object for the client
 Example usage:
 @code
 Player* player = [Player sharedPlayer];
 @endcode
 @return Player* for the singleton player, either a new one or the already created one.
 */
+ (Player*)sharedPlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ecstaticPlayer = [[Player alloc] init];
        ecstaticPlayer.avPlayer = [[AVPlayer alloc] init];
        ecstaticPlayer.currentTrackIndex = 0;
        ecstaticPlayer.isPaused = NO;
    });
    return ecstaticPlayer;
}

/**
 add the delegate to Player for Player to communicate with a view controller
 Example usage:
 @code
 [player addDelegate:self];
 @endcode
 @param (id) sender
 Usually called with the PlayerViewController to set up a delegate relation between the two
 @return void
 */
- (void) addDelegate:(id)sender
{
    _delegate = sender;
}

/**
 updates the playlist in the Player form the singleton Playlist object. also updates the delegate playlistTableView
 Example usage:
 @code
 [player updatePlaylist];
 @endcode
 @return (void)
 */
-(void) updatePlaylist
{
    ecstaticPlayer.playlist = [Playlist sharedPlaylist];
    [_delegate updatePlaylistTable];
}

/**
 Method for playing or pausing and controlling which currentTrack is playing
 Example usage:
 @code
 [[Player sharedPlayer] play];
 @endcode
 @return void
 */
-(void)play
{
   // [self updatePlaylist];
    if(_avPlayer.rate == 0)
    {
        NSLog(@"rate: %f",_avPlayer.rate);
        if(!_currentTrack)
        {
            if([_playlist count] > 0 && _currentTrackIndex < [_playlist count])
            {
                _currentTrack = [_playlist objectAtIndex:_currentTrackIndex];
               // [[Playlist sharedPlaylist] removeTrack:_currentTrack];
                [self updatePlaylist];
            }else{
                [_avPlayer stop];
                return;
            }
        }else{
            [_avPlayer play];
            _isPaused = NO;
            return;
        }
        
        
    }else if(!_isPaused){
        [_avPlayer pause];
        _isPaused = YES;
        return;
    }else{
        [_avPlayer play];
        _isPaused = NO;
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@", _currentTrack.stream_url,[SoundCloudAPI getClientID]];//Your client ID
    
        [SCRequest performMethod:SCRequestMethodGET
                      onResource:[NSURL URLWithString:urlString]
                 usingParameters:nil
                     withAccount:[SCSoundCloud account]
          sendingProgressHandler:nil
                 responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                     NSError *playerError;
                    // NSLog(@"data:%@",data);
                     _avPlayer = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
                     [_avPlayer prepareToPlay];
                     [_delegate initPlayerUI:[_avPlayer duration] withTrack:_currentTrack];
                     _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
                     [_avPlayer play];
                     _isPaused = NO;
        }];
}

/**
 Calls the delegate to update the UISlider from the current time in the player
 Example usage:
 @code
 [self updateTime];
 [[Player sharedPlayer] updateTime];
 @endcode
 @return void
 */
-(void)updateTime
{
    [_delegate setCurrentSliderValue:_avPlayer];
    if(!_avPlayer.playing && !_isPaused){
        [self audioPlayerDidFinishPlaying:_avPlayer successfully:YES];
    }
}

/**
 Calls inside the updateTime selector to control functionality at the end of a song playing
 Example usage:
 @code
 Called in a callback when the song ends
 @endcode
 @param player
        AVAudioPlayer that was playing the song
        flag
        Boolean that indicates if the song played successfully or not
 @return (id) of the newly created MediaItem
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    _currentTrack = nil;
    [ecstaticPlayer updatePlaylist];
    _avPlayer.rate = 0;
    _currentTrackIndex++;
    [ecstaticPlayer play];
}

/**
 Changes the currentTime value to the correct point as dictated by the UISlider
 Example usage:
 @code
 [[Player sharedPlayer] seek:slider.value]
 @endcode
 @param value
        Float variable indicating how for through the song you are. Usually set from a UISlider in PlayerViewController
 @return void
 */
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
    NSLog(@"print currentTime of player: %f", _avPlayer.currentTime);
    if(_avPlayer.currentTime <= 10.0)
    {
        _currentTrackIndex--;
        [self updatePlaylist];
        _isPaused = YES;
        [self play];
    }else{
        _avPlayer.currentTime = 0.0;
    }
    
}

@end
