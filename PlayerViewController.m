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
    
    _loading_next_song = true;
    
        _controlsView.hidden = YES;
    
    
    // Load images
    _spinner_animation = @[@"spinner-1.png", @"spinner-2.png", @"spinner-3.png", @"spinner-4.png",
                            @"spinner-5.png", @"spinner-6.png", @"spinner-7.png", @"spinner-8.png", @"spinner-9.png", @"spinner-10.png", @"spinner-11.png", @"spinner-12.png", @"spinner-13.png", @"spinner-14.png", @"spinner-15.png", @"spinner-16.png"];
    
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



        
//            int64_t delayInSeconds = 1.0f;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//           
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//               [_playerSpinner stopAnimating];
//                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Gestures" message:@"Long Gesture Detected" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                   [alertView show];
//                    });
//        }
        



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.playListTableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    _room_title.text = [NSString stringWithFormat:@"%@'s Room", [Room currentRoom].host_username ];
    NSLog(@"%@",[NSString stringWithFormat:@"%@'s Room", [Room currentRoom].host_username ]);
    [self.player updatePlaylist];
	
	//check if is_locked
	NSLog(@"player_is_locked=%hhd",_player.player_is_locked);
	if(_player.player_is_locked && ![Room currentRoom].is_owner){
		_playerShowControlsButton.enabled = NO;
		_add_songs.enabled = NO;
	}
	
	//if you are not the room owner then you cannot toggle the room lock
	if(![Room currentRoom].is_owner){
		_lock.hidden = YES;
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
        _add_songs.hidden = NO;
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
    
    _playListTableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.23];
    
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
    _slider.maximumValue = duration;
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
    AppDelegate* appDelegate = [[UIApplication  sharedApplication]delegate];
//before doing anything
    //check if the user has given permissions to use location services
    if([appDelegate.locationServices checkForPermissions]){
        [self performSegueWithIdentifier:@"roomsViewSegue" sender:self];
    }
    //if they haven't ask them to in the geoAsk uiviewcontroller
    else{
		UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		geoAskViewController *geoAskVC = [sb instantiateViewControllerWithIdentifier:@"geoAskVC"];
		appDelegate.locationServices.vc=geoAskVC;
		[self presentViewController:geoAskVC animated:YES completion:nil];
    }
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
    [_playListTableView reloadData];
}

-(void)playerIsDoneLoadingNextSong
{
    _loading_next_song = NO;
    [_playListTableView reloadData];
}

- (IBAction)lockAction:(id)sender {
	[self lockToggle];
}
-(void)lockToggle{
	NSLog(@"%u", _lock.on);
	if(_lock.on){
		[_lock setOn:YES];
		[[Player sharedPlayer] setLock:YES];
		
		//if you don't own the room, then the lock affects whether you can use the controls
		if(![Room currentRoom].is_owner){
			_playerShowControlsButton.enabled = NO;
			_add_songs.enabled = NO;
		}
	}
	else{
		[_lock setOn:NO];
		[[Player sharedPlayer] setLock:NO];
		if(![Room currentRoom].is_owner){
			_playerShowControlsButton.enabled = YES;
			_add_songs.enabled = YES;
		}
	}
}
@end


