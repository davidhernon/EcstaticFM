
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
        ecstaticPlayer.player_is_paused = NO;
        ecstaticPlayer.isNextSong = NO;
        ecstaticPlayer.user_joining_room = NO;
		ecstaticPlayer.user_hit_button = NO;
		ecstaticPlayer.player_is_locked = NO;
    });
    return ecstaticPlayer;
}

/**
the delegate to Player for Player to communicate with a view controller
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
 Method for playing or pausing and controlling which currentTrack is playing. Needs refactoring.
 Example usage:
 @code
 [[Player sharedPlayer] play];
 @endcode
 @return void
 */
-(void)play
{
    if([self playerNotPlayingAudioOrCurrentUserJoiningRoom])
    {
        if([self thereDoesntExistACurrentTrack])
        {
            [self playlistExistsAndIndexIsLessThanPlaylistLength];
            
        // else there is a current track and the player is just paused
        }else{
            //This hits when song makes it to the end, then a new song is added and user hits play or hits when User hits play after a pause
            [self playSignalFromUserOrPlayer];
            return;
        }
        
    // audio is not playing check if we are not paused
    }else if(!_player_is_paused){
        [self pauseSignalFromUserOrPlayer];
        return;
    // audio is not playing but we are not paused
    }else{
        [self setupAudioForPlayAfterPause];
        return;
    }
    
    [self callNextSong];
    
}

- (void)updatePlayerStateAndUIWithNewSong
{
    [_delegate initPlayerUI:(1.0f*CMTimeGetSeconds(_avPlayer.currentItem.asset.duration)) withTrack:_currentTrack atIndex:_currentTrackIndex];
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    _player_is_paused = NO;
}

-(void)callNextSong
{
	Mixpanel *mixpanel = [Mixpanel sharedInstance];
	[mixpanel track:@"played_song"];

    //set up the UI in advance to display album art while song is buffering
    [_delegate playerIsLoadingNextSong];
    [_delegate initPlayerUI:0.0f withTrack:_currentTrack atIndex:_currentTrackIndex];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@", _currentTrack.stream_url,[SoundCloudAPI getClientID]];//Your client ID
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"MyAudio" ofType:@"mp3"];
//    
//    // - - -
//
    
   
    
    NSURL *url;
//    if(_currentTrack.is_event_mix && _currentTrack.is_local_item)
    if(_currentTrack.is_local_item)
    {
        NSLog(@"Playing Local Song %@", _currentTrack.local_file_path);
        
        NSLog(@"PLaying local song with formatted: %@", _currentTrack.local_file_path);
        
        
        url = [[NSURL alloc] initFileURLWithPath: _currentTrack.local_file_path];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:_currentTrack.local_file_path];
        AVAsset *asset = [AVAsset assetWithURL:url];
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
        _avPlayer = [AVPlayer playerWithPlayerItem:item];
    }else{
        url = [NSURL URLWithString:urlString];
        _avPlayer = [AVPlayer playerWithURL:url];
    }
    
//    NSData *data = [[NSFileManager defaultManager] contentsAtPath:_currentTrack.local_file_path];
//    
//    NSString *myPath = [NSString stringWithFormat:@"%@/..",_currentTrack.local_file_path ];
//    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_currentTrack.local_file_path error:NULL];
//    for (int count = 0; count < (int)[directoryContent count]; count++)
//    {
//        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
//    }
    
//    _avPlayer = [AVPlayer playerWithURL:data];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerDidFinishPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:[_avPlayer currentItem]];
    [_avPlayer play];
    [self updatePlayerStateAndUIWithNewSong];
	
	//if you just created the room
	if([SDSAPI getCreateRoomBool]){
		[SDSAPI setCreateRoomBool:false];
		[SDSAPI realtimePlayer:@"play"];
	}
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
    [_delegate playerIsDoneLoadingNextSong];
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
- (void)audioPlayerDidFinishPlaying
{
//    NSError *error;
//    if ([[NSFileManager defaultManager] fileExistsAtPath:_currentTrack.local_file_path])     //Does file exist?
//    {
//        if (![[NSFileManager defaultManager] removeItemAtPath:_currentTrack.local_file_path error:&error])   //Delete it
//        {
//            NSLog(@"Delete file error: %@", error);
//        }
//    }
    
    if(_currentTrackIndex == [[Playlist sharedPlaylist] count] - 1)
    {
        _currentTrack = nil;
        [self updatePlaylist];
        return;
    }
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    _currentTrack = nil;
    [ecstaticPlayer updatePlaylist];
    _currentTrackIndex++;
    _currentTrack = [_playlist objectAtIndex:_currentTrackIndex];
    [self updatePlaylist];
    [self callNextSong];
}

/**
 Does not seek while player is not playing
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
//        [_avPlayer seekToTime:CMTimeMake(value, 1000)];
        [_avPlayer seekToTime:CMTimeMake(value, 1000) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    }
}

-(void) pause
{
    [_avPlayer pause];
}

-(void)next
{
    _avPlayer.rate = 0;
    [self audioPlayerDidFinishPlaying];
}

-(void)last
{
    if(CMTimeGetSeconds([_avPlayer currentTime]) <= 10.0f)
    {
        if(!_currentTrackIndex == 0)
        {
            _currentTrackIndex--;
            _currentTrack = nil;
            [self updatePlaylist];
            [self pause];
            _player_is_paused = YES;
            [self play];
            return;
        }
    }
    
    [_avPlayer seekToTime:CMTimeMake(0.0,1.0)];
    
}

-(BOOL)isPlaying
{
    if(_avPlayer.rate == 0 || _player_is_paused)
    {
        return NO;
    }else{
        return YES;
    }
}

-(void)hidePlayerUIWhenPlaylistIsFinished
{
    [_delegate hideUI];
}

-(void) reloadUI
{
    [_delegate redrawUI];
}

//Sets up the player (elapsed time is in milli)
- (void) joinRoom:(int)index withElapsedTime:(float)elapsed andIsPlaying:(BOOL)is_playing isLocked:(BOOL)isLocked
{
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];

	//if we were just told that the room is locked, and we don't own the room, then lock the room
	if(isLocked && ![username isEqual:[Room currentRoom].host_username]){
		[_delegate lock];
	}

	//if the player is empty or the playlist is empty, return
	if([Playlist sharedPlaylist].playlist.count == 0)
        return;
    _currentTrack = [[Playlist sharedPlaylist].playlist objectAtIndex:index];
    _currentTrackIndex = index;
    [self seek:(elapsed)];
    [_delegate setCurrentSliderValue:_avPlayer];
    [self reloadUI];
    _user_joining_room = YES;
	if(is_playing){
		[self play];
	}
	else{
		[self pause];
	}
}

-(BOOL)playerNotPlayingAudioOrCurrentUserJoiningRoom
{
    if(_avPlayer.rate == 0 || _user_joining_room)
    {
        _user_joining_room = NO;
        return true;
    }else{
        return false;
    }
}

-(BOOL)thereDoesntExistACurrentTrack
{
    return !_currentTrack;
}

-(BOOL)playlistExistsAndIndexIsLessThanPlaylistLength
{
   if( [_playlist count] > 0 && _currentTrackIndex < [_playlist count])
   {
       _currentTrack = [_playlist objectAtIndex:_currentTrackIndex];
       [self updatePlaylist];
       return true;
   }else{
       _avPlayer.rate = 0.0;
       return false;
   }
}

-(void)wasPlayPauseHitByUser:(BOOL)play
{
    if(_user_hit_button){
        [self userHitPlayPauseButtonForPlay:play];
    }
}

-(void)userHitPlayPauseButtonForPlay:(BOOL)play
{
    if(play)
    {
        _user_hit_button = NO;
		[SDSAPI realtimePlayer:@"play"];
    }else{
        _user_hit_button = NO;
		[SDSAPI realtimePlayer:@"pause"];
    }
}

-(void)userDidPause
{
    [_delegate showPlayButton];
    [_avPlayer pause];
    _player_is_paused = YES;
}

-(void)userDidPlay
{
    [_avPlayer play];
    _player_is_paused = NO;
    [_delegate showPauseButton];
}

-(void)playSignalFromUserOrPlayer
{
	[self userDidPlay];
    [self wasPlayPauseHitByUser:true];
}

-(void)pauseSignalFromUserOrPlayer
{
	[self userDidPause];
    [self wasPlayPauseHitByUser:false];
}

-(void)setupAudioForPlayAfterPause
{
//    NSLog(@"User just hit play after being paused");
    [_avPlayer play];
    _player_is_paused = NO;
}

-(void)setLock:(BOOL)player_is_locked{
	self.player_is_locked = player_is_locked;
}

-(void) deleteSongWithDict:(NSDictionary*)remove_song_dict
{
    
}

@end
