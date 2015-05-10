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
    tableView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.track_title.text = track.track_title;
    cell.artist.text = track.artist;
    cell.duration.text = track.duration;
    cell.sc_album_image.image =  track.artwork;
    cell.backgroundColor = [UIColor clearColor];
    
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
- (void) initPlayerUI:(float)duration withTrack:(MediaItem*)currentTrack
{
    _slider.maximumValue = duration;
    _slider.value = 0.0;
    _current_artist.text = currentTrack.artist;
    _current_track_title.text = currentTrack.track_title;
    _current_duration.text = currentTrack.duration;
    _current_time.text = @"0";
    _current_album_artwork.image = currentTrack.artwork;
    _current_waveform.image = currentTrack.waveform_url;
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

-(IBAction)next:(id)sender
{
    [self.player next];
  //  [self.player play];
    
}

@end
