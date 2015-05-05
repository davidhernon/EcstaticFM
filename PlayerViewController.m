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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[Playlist sharedPlaylist] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MediaItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    MediaItem *track = [self.playlist objectAtIndex:indexPath.row];
    cell.track_title.text = track.track_title;
    cell.artist.text = track.artist;
    cell.duration.text = track.duration;
    cell.sc_album_image.image =  track.artwork;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void) initPlayerUI:(float)duration withTrack:(MediaItem*)currentTrack
{
    _slider.maximumValue = duration;
    _slider.value = 0.0;
    _current_artist.text = currentTrack.artist;
    _current_track_title.text = currentTrack.track_title;
    _current_duration.text = currentTrack.duration;
    _current_time.text = @"0";
    _current_album_artwork.image = currentTrack.artwork;
}

- (void) setCurrentSliderValue:(AVAudioPlayer*)childPlayer
{
    NSLog(@"current time: %f", childPlayer.currentTime);
    _slider.value = childPlayer.currentTime;
    _current_time.text = [Utils convertTimeFromMillis:(int)1000*childPlayer.currentTime];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    [_player seek:sender.value];
}

- (void)updatePlaylistTable
{
    [self.playListTableView reloadData];
}


- (IBAction)play:(id)sender
{
    [self.player play];
}

-(void) pause
{
    [self.player pause];
}

-(void) skip
{
    
}

@end
