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
    self.playlist = [Playlist sharedPlaylist].playlist;
    self.player = [Player sharedPlayer];
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
    cell.duration.text = [NSString stringWithFormat:@"%@",track.duration ];
    cell.sc_album_image.image =  track.artwork;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


- (IBAction)play:(id)sender
{
    [self.player play];
}

-(void) pause
{
    
}

-(void) skip
{
    
}

@end
