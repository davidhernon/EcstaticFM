//
//  PlayerViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "PlayerViewController.h"
#import "PlayerDelegate.h"


@interface PlayerViewController ()

@end

@implementation PlayerViewController

static NSString* cellIdentifier = @"playListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _track_to_download = [[MediaItem alloc] init];
    
    _download_label.text = @"";
    
    _loading_next_song = true;
	_loading_next_song_has_changed = false;
	_controlsView.hidden = YES;
	
    // Load images
    _spinner_animation = @[@"spinner-1.png", @"spinner-2.png", @"spinner-3.png", @"spinner-4.png",
                            @"spinner-5.png", @"spinner-6.png", @"spinner-7.png", @"spinner-8.png", @"spinner-9.png", @"spinner-10.png", @"spinner-11.png", @"spinner-12.png", @"spinner-13.png", @"spinner-14.png", @"spinner-15.png", @"spinner-16.png", @"spinner-17.png", @"spinner-18.png", @"spinner-19.png", @"spinner-20.png", @"spinner-21.png", @"spinner-22.png", @"spinner-23.png", @"spinner-24.png", @"spinner-25.png", @"spinner-26.png", @"spinner-27.png", @"spinner-28.png", @"spinner-29.png", @"spinner-30.png", @"spinner-0.png"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < _spinner_animation.count; i++) {
        [images addObject:[UIImage imageNamed:[_spinner_animation objectAtIndex:i]]];
    }
    
    
    // Normal Animation
   //  UIImageView *_playerSpinner = [[UIImageView alloc] initWithFrame:CGRectMake(60, 95, 86, 193)];
    _playerSpinner.animationImages = images;
    _playerSpinner.animationDuration = 1.2;
    
    [self.view addSubview:_playerSpinner];
    _playerSpinner.hidden = YES;
    
    
    
    _download_spinner.animationImages = images;
    _download_spinner.animationDuration = 1.2;
    
    [self.view addSubview:_download_spinner];
    _download_spinner.hidden = YES;

    

    
 //   _controlsView.hidden = YES;
//    _controlsDarkenView.hidden = YES;
    
    
  //  [self.player updatePlaylist];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // Set AVAudioSession
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    // Change the default output audio route
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                            sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);


    // Hide the slider thumb & background color
    UIImage *img = [UIImage imageNamed:@"image_cursor.png"];
    NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
    UIImage *scaled_image = [[UIImage alloc] initWithData:(NSData *)imageData
                                                    scale:2.0f];
    [_slider setThumbImage:scaled_image forState:UIControlStateNormal];
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
    
    _current_album_artwork.layer.shadowColor = [UIColor colorWithRed:0.549 green:0.227 blue:0.4 alpha:1].CGColor;
    _current_album_artwork.layer.shadowRadius = 5.f;
    _current_album_artwork.layer.shadowOffset = CGSizeMake(0.f, 5.f);
    _current_album_artwork.layer.shadowOpacity = 0.55f;
    _current_album_artwork.clipsToBounds = NO;
    _playListTableView.tableHeaderView = __playerTableHeaderView;
    _playListTableView.tableFooterView = __playerAddMusicCell;
    
    // Allow multiple checkmarks
//     _playListTableView.allowsMultipleSelection = YES;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.playListTableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    if([Room currentRoom].is_owner){
        NSLog(@"you are the room owner");
    }
    
//    MWLogDebug(@"joining room, is event: %@ and is locked: %@", [Room currentRoom].is_event, _player.player_is_locked);
    
    _room_title.text = [NSString stringWithFormat:@"%@'s Room", [Room currentRoom].host_username ];
    NSLog(@"%@",[NSString stringWithFormat:@"%@'s Room", [Room currentRoom].host_username ]);
    [self.player updatePlaylist];
    
    
//	check if is_locked
	NSLog(@"player_is_locked=%hhd",_player.player_is_locked);
	if(_player.player_is_locked && ![Room currentRoom].is_owner){
		_playerShowControlsButton.enabled = NO;
        _add_songs.hidden = YES;
    }else{
        _playerShowControlsButton.enabled = YES;
        _add_songs.hidden = NO;
    }
    
//    // set the state of the download button
    if([Room currentRoom].is_event && ![Room currentRoom].is_owner)
    {
        _download_mix_button.hidden = NO;
        _add_songs.hidden = YES;
    }else if([Room currentRoom].is_event && [Room currentRoom].is_owner){
        _download_mix_button.hidden = NO;
        _add_songs.hidden = NO;
    }else if(![Room currentRoom].is_event){
        _download_mix_button.hidden = YES;
    }
	
    //If no playlist then make buttons hidden
    if([_playlist count] == 0)
    {
        //_playerShowControlsButton.hidden = YES;
        _add_songs_welcome.hidden = NO;
        _slider.hidden = YES;
        _coveralpha.hidden = YES;
        _playlist_title.hidden = YES;
        _current_track_title.hidden = YES;
        _current_duration.hidden = YES;
        _current_time.hidden = YES;
        _current_user_picture.hidden = YES;
        _welcomehome.hidden = NO;

        
        
    }else{
        //_playerShowControlsButton.hidden = NO;
        _play.hidden = NO;
        _last.hidden = NO;
        _next.hidden = NO;
//        _add_songs.hidden = NO;
        _add_songs_welcome.hidden = YES;
        _slider.hidden = NO;
        _coveralpha.hidden = NO;
        _playlist_title.hidden = NO;
        _current_track_title.hidden = NO;
        _current_duration.hidden = NO;
        _current_time.hidden = NO;
        _current_user_picture.hidden = NO;
        _welcomehome.hidden = YES;
        float fl;
        if(_player.currentTrackIndex == 0 && isnan(CMTimeGetSeconds(_player.avPlayer.currentItem.asset.duration))){
            fl = 0.0f;
        }else{
            fl = (1.0f*CMTimeGetSeconds(_player.avPlayer.currentItem.asset.duration));  
        }
        [self initPlayerUI:fl withTrack:_player.currentTrack atIndex:_player.currentTrackIndex];
//        _playListTableView.editing = YES;
//        _playListTableView.allowsMultipleSelectionDuringEditing = NO;
        
    }
    if(![_player isPlaying] && ![_player player_is_paused] && [_playlist count] > 0)
    {
        [_player play];
    }
    
    if(![Room currentRoom].is_event){
        _download_mix_button.hidden = YES;
    }
    
    if([Player sharedPlayer].currentTrack.is_local_item)
    {
        _download_mix_button.hidden = YES;
    }
    
    [self existsLocalTrackInPlaylist];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if(_player.currentTrackIndex != 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_player.currentTrackIndex inSection:0];
        [_playListTableView scrollToRowAtIndexPath:indexPath
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:YES];
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
    
    _playListTableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    cell.track_title.text = track.track_title;
    cell.artist.text = track.artist;
    cell.duration.text = track.duration;
    cell.sc_album_image.image =  track.artwork;
    cell.backgroundColor = [UIColor clearColor];
    cell.song_index_label.text = [NSString stringWithFormat:@"%d",indexPath.row+1];

    
    // If the track added is the track currently playing add other UI
    if((int)_current_track_index == (int)indexPath.row)
    {
        cell.backgroundColor = [UIColor colorWithRed:0.369 green:0.078 blue:0.298 alpha:0.25] /*#5e144c*/;
        cell.song_index_label.text = @"";
        
        // select either the spinner or the playing animation to place on the table view cells
        NSArray *imageNames = [[NSArray alloc] init];;
        if(_loading_next_song)
        {
            imageNames = @[@"spinner-1.png", @"spinner-2.png", @"spinner-3.png", @"spinner-4.png",
                           @"spinner-5.png", @"spinner-6.png", @"spinner-7.png", @"spinner-8.png", @"spinner-9.png", @"spinner-10.png", @"spinner-11.png", @"spinner-12.png", @"spinner-13.png", @"spinner-14.png", @"spinner-15.png", @"spinner-16.png"];
        }
        else
        {
            imageNames = @[@"wave1.png", @"wave2.png", @"wave3.png", @"wave4.png", @"wave5.png", @"wave6.png", @"wave7.png"];
        }
        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (int i = 0; i < imageNames.count; i++) {
            [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
        }
        
        // Normal Animation
        cell.playing_animation.animationImages = images;
        cell.playing_animation.animationDuration = 0.7;
        [cell.playing_animation startAnimating];
    }
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
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
- (void) initPlayerUI:(float)duration withTrack:(MediaItem*)currentTrack atIndex:(int)index
{
    NSLog(@"Is the index null? : %d",index);
    if(!isnan(duration)){
        _slider.maximumValue = duration;
    }
    _slider.value = 0.0;
    _current_artist.text = currentTrack.artist;
    _current_track_title.text = currentTrack.track_title;
    _current_duration.text = currentTrack.duration;
    _current_time.text = @"0";
    _current_album_artwork.image = currentTrack.artwork;
//    _current_waveform.image = currentTrack.waveform_url;
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
- (void) setCurrentSliderValue:(AVPlayer*)childPlayer
{
    float sec = CMTimeGetSeconds([childPlayer currentTime]);
    [_slider setValue:sec animated:YES];
    _current_time.text = [Utils convertTimeFromMillis:(int)1000*_slider.value];
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
    _player.user_hit_button = YES;
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
	[SDSAPI realtimePlayer:@"back"];
}

-(IBAction)next:(id)sender
{
    [self playerIsLoadingNextSong];
    [self.player next];
	[SDSAPI realtimePlayer:@"skip"];
}

-(void)hideUI
{
    _current_album_artwork = nil;
    _current_track_title = @"";
}

-(void)redrawUI
{
    _playlist = [Playlist sharedPlaylist].playlist;
    [self viewDidDisappear:YES];
    [self viewWillAppear:YES];
}

- (IBAction)showRooms:(id)sender {
    //removed GEOask so we just show rooms:
    [self performSegueWithIdentifier:@"roomsViewSegue" sender:self];
    
//    AppDelegate* appDelegate = [[UIApplication  sharedApplication]delegate];
//before doing anything
    //check if the user has given permissions to use location services
//    if([appDelegate.locationServices checkForPermissions]){
//        [self performSegueWithIdentifier:@"roomsViewSegue" sender:self];
//    }
//    //if they haven't ask them to in the geoAsk uiviewcontroller
//    else{
//		UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//		geoAskViewController *geoAskVC = [sb instantiateViewControllerWithIdentifier:@"geoAskVC"];
//		appDelegate.locationServices.vc=geoAskVC;
//		[self presentViewController:geoAskVC animated:YES completion:nil];
//    }
}
- (IBAction)playerControlsClicked:(id)sender {
    if([[Playlist sharedPlaylist] count] == 0)
        return;
    _controlsView.hidden = NO;
    _controlsDarkenView.hidden = NO;
    _playerShowControlsButton.hidden = YES;
    _playerHideControlsButton.hidden = NO;
    
}
- (IBAction)playerControlsUnClicked:(id)sender {
    _controlsView.hidden = YES;
    _controlsDarkenView.hidden = YES;
    _playerHideControlsButton.hidden = YES;
    _playerShowControlsButton.hidden = NO;
    
}

-(void)showPlayButton {
    [_play setImage:[UIImage imageNamed:@"button_playnew.png"] forState:UIControlStateNormal];
    [_play setSelected:NO];
}

-(void)showPauseButton {
    [_play setImage:[UIImage imageNamed:@"button_pausenew.png"] forState:UIControlStateSelected];
    [_play setSelected:YES];
}

-(void)playerIsLoadingNextSong
{
    _loading_next_song = YES;
    _loading_next_song_has_changed = YES;
    [_playListTableView reloadData];
}

//method ends up getting called everytime by updateTime
-(void)playerIsDoneLoadingNextSong
{
    
    _loading_next_song = NO;
    //Keeps track of old state of _loading_next_song_boolean
    //If _loading_next_song has changed since the last time through this loop, reloadData, otherwise ignore the signal
    //_loading_next_song_has_changed gets set under _playerIsLoadingNextSong
    if(_loading_next_song != _loading_next_song_has_changed){
        _loading_next_song_has_changed = _loading_next_song;
        [_playListTableView reloadData];
    }
}

//Lock the room, and if you dont own the room you cannot use the controls
-(void)lock{
	
	//if you don't own the room, then the lock affects whether you can use the controls
	if(![Room currentRoom].is_owner){
		_playerShowControlsButton.enabled = NO;
		_add_songs.enabled = NO;
		_add_songs.alpha = 0;
	}
}

//unlock the room, and if you dont own the room you can now use the controls
-(void)unlock{
	[[Player sharedPlayer] setLock:NO];
	if(![Room currentRoom].is_owner){
		_playerShowControlsButton.enabled = YES;
		_add_songs.enabled = YES;
		_add_songs.alpha = 1;
	}
}

//creates the array of buttons that will be shown when the tablecell is swiped
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
       [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSLog(@"EcstaticFM - Player Module - PlayerViewController - swipeableTableViewCell: didTriggerRightUtilityButtonWithIndex - with index: %li", (long)index);
    
    
    switch (index) {
        case 0:
        {
            //Get index of cell
            NSIndexPath* cellIndexPath = [_playListTableView indexPathForCell:cell];
            // delete song from local playlist
//            [_playlist removeObjectAtIndex:cellIndexPath.row];
//            [_playListTableView deleteRowsAtIndexPaths:@[cellIndexPath]
//                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            //reload data - do I need this?
            //    [_playListTableView reloadData];
            // delete song from sharedPlaylist
            //    [Playlist sharedPlaylist] removeTrack:<#(MediaItem *)#>
            // send delete to API
            [SDSAPI deleteSong:cellIndexPath.row];
            // make sure next song plays
            if(_current_track_index == cellIndexPath.row)
            {
                [self next:self];
            }
            [_playlist removeObjectAtIndex:cellIndexPath.row];
            [_playListTableView reloadData];
            break;
        }
    }
}

-(void)deleteSongAtIndex:(int)index
{
    NSLog(@"EcstaticFM - Player Module - PlayerViewController - deleteSongAtIndex:index - with index: %i", index);
    
    //make sure songs play accordingly
    if(_current_track_index == index)
    {
        [self next];
    }
    [_playlist removeObjectAtIndex:index];
    [_playListTableView reloadData];
}


//Currently is only selecting the first song in the playlist
- (IBAction)downloadMix:(id)sender {
    for( MediaItem *track in _playlist )
    {
        NSLog(@"Media Item title: %@", track.track_title);
        NSLog(@"player counter %lu", (unsigned long)[[Playlist sharedPlaylist].playlist count]);
        if (track.downloadable && track.is_event_mix)
        {
                        int megabytes = [track.size intValue] / 1000000;
                        NSString *message = [NSString stringWithFormat:@"File to download is %i megabytes. Do you want to continue?",megabytes];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download File" message:message delegate:self cancelButtonTitle:@"Nevermind" otherButtonTitles:nil];
                        // optional - add more buttons:
                        [alert addButtonWithTitle:@"Download!"];
                        [alert show];
//            NSString *sc_url = [NSString stringWithFormat:@"https://api.soundcloud.com/tracks/%@/download?client_id=%@",track.sc_id,[SoundCloudAPI getClientID]];
//            [Utils downloadSongFromURL:sc_url withRoomNumber:[Room currentRoom].room_number withMediaItem:track withSender:self];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self performSelectorOnMainThread:@selector(download) withObject:nil waitUntilDone:NO];
    }
}

-(void)download
{
    for( MediaItem *track in _playlist )
    {
        if (track.downloadable && track.is_event_mix)
        {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *sc_url = [NSString stringWithFormat:@"https://api.soundcloud.com/tracks/%@/download?client_id=%@",track.sc_id,[SoundCloudAPI getClientID]];
                NSLog(@"sc_url: %@",sc_url);
                [Utils downloadSongFromURL:sc_url withRoomNumber:[Room currentRoom].room_number withMediaItem:track withSender:self];
//                });
        }
    }
        

}

-(IBAction)swipeToChat:(id)sender
{
    [(PlayerPageViewController*)self.parentViewController swipeToChatViewControllerForward];
}

-(void)downloadButtonSwitchSelected
{
    _download_mix_button.selected = ![_download_mix_button isSelected];
}

-(void)setIsDownloading
{
    NSLog(@"is downloading");
    
    NSArray *imageNames = @[@"spinner-1.png", @"spinner-2.png", @"spinner-3.png", @"spinner-4.png",
                   @"spinner-5.png", @"spinner-6.png", @"spinner-7.png", @"spinner-8.png", @"spinner-9.png", @"spinner-10.png", @"spinner-11.png", @"spinner-12.png", @"spinner-13.png", @"spinner-14.png", @"spinner-15.png", @"spinner-16.png"];

    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }

    // Normal Animation
    _download_spinner.animationImages = images;
    _download_spinner.animationDuration = 0.7;
    [_download_spinner startAnimating];
    _download_spinner.hidden = NO;
    
    [_download_mix_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_download_mix_button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    [_download_mix_button setTitle:@"Title" forState:UIControlStateNormal];
    [_download_mix_button setTitle:@"Title" forState:UIControlStateHighlighted];
    _download_mix_button.hidden = YES;
    _download_label.text = @"Download in Progress";
}

-(void)setDownloadFinished
{
    NSLog(@"download finished");
    _download_spinner.hidden = YES;
    _download_label.text = @"Download Finished :)";
}

-(void)updateDownloadProgress:(float)progress
{
    float prog = progress*100;
    NSLog(@"updating progress %f", prog);
    int p_int = floor(prog);
    _download_label.text = [NSString stringWithFormat:@"In Progress: %i%%", p_int];
}

-(void)clearDownloadFinishedUI
{
    NSLog(@"Clearing download finished message");
    _download_label.text = @"";
}

-(void)existsLocalTrackInPlaylist
{
    for( MediaItem *track in _playlist )
    {
        if (track.is_local_item)
        {
            _download_label.text = @"Local Item Downloaded :)";
        }
    }
}

@end


