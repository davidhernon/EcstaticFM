//
//  PlayerViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "PlayerViewController.h"
#import "Room.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

static NSString* cellIdentifier = @"playListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Initialize the long press gesture
    
    self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    self.lpgr.minimumPressDuration = 1.0f;
    self.lpgr.allowableMovement = 100.0f;
    
    [self.view addGestureRecognizer:self.lpgr];
    
    
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
    [_slider setThumbImage:[UIImage alloc] forState:UIControlStateNormal];
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
    
    //_current_album_artwork.layer.shadowColor = [UIColor blackColor].CGColor;
//    _current_album_artwork.layer.shadowRadius = 10.f;
//    _current_album_artwork.layer.shadowOffset = CGSizeMake(0.f, 5.f);
//    _current_album_artwork.layer.shadowOpacity = 1.f;
    _current_album_artwork.clipsToBounds = NO;
    _playListTableView.tableHeaderView = __playerTableHeaderView;
    _playListTableView.tableFooterView = __playerAddMusicCell;
    
    // Allow multiple checkmarks
//     _playListTableView.allowsMultipleSelection = YES;
    
}

- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
{
    if ([sender isEqual:self.lpgr]) {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Gestures" message:@"Long Gesture Detected" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
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
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
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
        cell.song_index_label.text = [NSString stringWithFormat:@"%d",indexPath.row+1];

    // If the track added is the track currently playing add other UI
    if((int)_current_track_index == (int)indexPath.row && _player.isPlaying)
    {
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
        cell.song_index_label.text = @"";
        NSArray *imageNames = @[@"wave1.png", @"wave2.png", @"wave3.png", @"wave4.png", @"wave5.png", @"wave6.png", @"wave7.png"];
        
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


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}


// This method gets called when a row in the table is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_c removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (_playListTableView.editing)
    {
        return UITableViewCellEditingStyleNone;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"More button was pressed");
            break;
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [_playListTableView indexPathForCell:cell];
            
//            [_testArray removeObjectAtIndex:cellIndexPath.row];
            [_playListTableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default:
            break;
    }
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //	Grip customization code goes in here...
    UIView* reorderControl = [cell huntedSubviewWithClassName:@"UITableViewCellReorderControl"];
    
    UIView* resizedGripView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(reorderControl.frame), CGRectGetMaxY(reorderControl.frame))];
    [resizedGripView addSubview:reorderControl];
    [cell addSubview:resizedGripView];
    
    CGSize sizeDifference = CGSizeMake(resizedGripView.frame.size.width - reorderControl.frame.size.width, resizedGripView.frame.size.height - reorderControl.frame.size.height);
    CGSize transformRatio = CGSizeMake(resizedGripView.frame.size.width / reorderControl.frame.size.width, resizedGripView.frame.size.height / reorderControl.frame.size.height);
    
    //	Original transform
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    //	Scale custom view so grip will fill entire cell
    transform = CGAffineTransformScale(transform, transformRatio.width, transformRatio.height);
    
    //	Move custom view so the grip's top left aligns with the cell's top left
    transform = CGAffineTransformTranslate(transform, -sizeDifference.width / 2.0, -sizeDifference.height / 2.0);
    
    [resizedGripView setTransform:transform];
    
    for(UIImageView* cellGrip in reorderControl.subviews)
    {
        if([cellGrip isKindOfClass:[UIImageView class]])
            [cellGrip setImage:nil];
    }
}

-(IBAction)reorder:(id)sender
{
    if(_playListTableView.editing)
        _playListTableView.editing = NO;
    else
        _playListTableView.editing = YES;
}
/**
 Initialize the Player UI with information from the currentTrack
 @param currentTrack
 MediaItem of the currently playing track
 */
- (void) initPlayerUI:(float)duration withTrack:(MediaItem*)currentTrack atIndex:(int)index
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
- (void) setCurrentSliderValue:(AVPlayer*)childPlayer
{
    float sec = CMTimeGetSeconds([childPlayer currentTime]);
    NSLog(@"float: %f",sec);
    NSLog(@"int: %d",(int)sec);
    [_slider setValue:sec animated:YES];
//    _slider.value = sec;
    NSLog(@"slider: %f",_slider.value);
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
    [SDSAPI play];
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

-(IBAction)next:(id)sender
{
    [self.player next];
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
@end
