//
//  PlayerViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "PlayerViewController.h"


@interface PlayerViewController ()

@end

@implementation PlayerViewController

static NSString* cellIdentifier = @"playListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
  //  [self.player updatePlaylist];
    
    
    // Set AVAudioSession
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    // Change the default output audio route
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                            sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);


    // Hide the slider thumb & background color
    
    UIImage *empty = [UIImage new];
    [_slider setThumbImage:[UIImage alloc] forState:UIControlStateNormal];
    
//    UIImage *progressbar = [UIImage imageNamed:[NSString stringWithFormat:@"image_progressbarcolors.png"]];
//    [_slider setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    
    _slider.maximumTrackTintColor = [UIColor colorWithRed:0.541 green:0.267 blue:0.435 alpha:1] /*#8a446f*/;
    
    
    // Make playerTableView & it's header transparent
    
    _playListTableView.backgroundColor = [UIColor clearColor];
    __playerTableHeaderView.backgroundColor = [UIColor clearColor];
    
    // Make the nav bar transparent

    [self._playerNavigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self._playerNavigationBar.shadowImage = [UIImage new];
    self._playerNavigationBar.translucent = YES;

    // Add the gradient to the view
    [self.view.layer insertSublayer:[GFXUtils getGradientPlayer:self.view.bounds] atIndex:0];
    
    // Remove line between cells
    self.playListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //initialize some basic values, slider values and init playlist and player
    self.slider.value = 0.0;
    self.playlist = [Playlist sharedPlaylist].playlist;
    self.player = [Player sharedPlayer];
    [self.player addDelegate:self];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _current_album_artwork.layer.shadowColor = [UIColor blackColor].CGColor;
    _current_album_artwork.layer.shadowRadius = 10.f;
    _current_album_artwork.layer.shadowOffset = CGSizeMake(0.f, 5.f);
    _current_album_artwork.layer.shadowOpacity = 1.f;
    _current_album_artwork.clipsToBounds = NO;
    _playListTableView.tableHeaderView = __playerTableHeaderView;
    _playListTableView.tableFooterView = __playerAddMusicCell;
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.playListTableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.player updatePlaylist];
    //If no playlist then make buttons hidden
    if([_playlist count] == 0)
    {
        _play.hidden = YES;
        _last.hidden = YES;
        _next.hidden = YES;
        _add_songs.hidden = YES;
        _add_songs_welcome.hidden = NO;
        _slider.hidden = YES;
        _coveralpha.hidden = YES;
        _playlist_title.hidden = YES;
        _current_track_title.hidden = YES;
        _current_duration.hidden = YES;
        _current_time.hidden = YES;
        _current_user_picture.hidden = YES;
        
    }else{
        _play.hidden = NO;
        _last.hidden = NO;
        _next.hidden = NO;
        _add_songs.hidden = NO;
        _add_songs_welcome.hidden = YES;
        _slider.hidden = NO;
        _coveralpha.hidden = NO;
        _playlist_title.hidden = NO;
        _current_track_title.hidden = NO;
        _current_duration.hidden = NO;
        _current_time.hidden = NO;
        _current_user_picture.hidden = NO;
    }
    if(![_player isPlaying] && ![_player isPaused] && [_playlist count] > 0)
    {
        [_player play];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Return the number of rows in the section
// The number of rows is equal to the number of MediaItems in the playlist
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[Playlist sharedPlaylist] count];
}

// Initialize a new cell for each media item in the playlist
// basic setting and getting for all fields to display
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MediaItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    MediaItem *track = [self.playlist objectAtIndex:indexPath.row];
    
    _playListTableView.backgroundColor = [UIColor clearColor];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    cell.track_title.text = track.track_title;
    cell.artist.text = track.artist;
    cell.duration.text = track.duration;
    cell.sc_album_image.image =  track.artwork;
    cell.backgroundColor = [UIColor clearColor];
    
    
    if((int)_current_track_index == (int)indexPath.row && _player.isPlaying)
    {
        cell.playing_animation.image = [UIImage animatedImageNamed:@"wave" duration:0.6f];
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    }
    
    return cell;
    
}

// This method gets called when a row in the table is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

/**
 Initialize the Player UI with information from the currentTrack
 @param currentTrack
 MediaItem of the currently playing track
 */
- (void) initPlayerUI:(float)duration withTrack:(MediaItem*)currentTrack atIndex:(NSUInteger*)index
{
    _slider.maximumValue = duration;
    _slider.value = 0.0;
    _current_artist.text = currentTrack.artist;
    _current_track_title.text = currentTrack.track_title;
    _current_duration.text = currentTrack.duration;
    _current_time.text = @"0";
    _current_album_artwork.image = currentTrack.artwork;
    _current_waveform.image = currentTrack.waveform_url;
    _current_track_index = index;
    [self.playListTableView reloadData];
}

/**
 sets the current UISlider value based on the audio player
 Example usage:
 @code
 [yourPlayerViewController setCurrentSliderValue:[self Player.avPlayer]];
 @endcode
 @param childPlayer
 the AVAudioPlayer which is a parameter of the EcstaticPlayer
 @return void
 */
- (void) setCurrentSliderValue:(AVAudioPlayer*)childPlayer
{
    NSLog(@"current time: %f", childPlayer.currentTime);
    _slider.value = childPlayer.currentTime;
    _current_time.text = [Utils convertTimeFromMillis:(int)1000*childPlayer.currentTime];
}

/**
 callback for UISlider when the slider value changes. Calls method in player to seek to part of the song.
 @param (UISlider*)sender
 The UISlider which sets this sliderValueChanged as a callback on a user action
 */
- (IBAction)sliderValueChanged:(UISlider *)sender {
    [_player seek:sender.value];
}

/**
 Used in the delegate classes to update the playlist Table when the Player's playlist changes
 Example usage:
 @code
 [delegate updatePlaylistTable];
 @endcode
 @return void, only calls the reloadData method on the tableView
 */
- (void)updatePlaylistTable
{
    [self.playListTableView reloadData];
}

/**
 A button callback used to update the playlist and call the play/pause functionality
 Example usage:
 Hooked up to a button and called when the button is selected
 @param sender
 (id) of the object who selected the sender
 */
- (IBAction)play:(id)sender
{
    [self.player updatePlaylist];
    [self.player play];
}

-(void) pause
{
    [self.player pause];
}

-(IBAction)last:(id)sender
{
    [self.player last];
}

-(void) skip
{
    
}

@end
