//
//  soundCloudMediaPickerViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-03-13.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "soundCloudMediaPickerViewController.h"

@interface soundCloudMediaPickerViewController ()

@end

@implementation soundCloudMediaPickerViewController

static NSString* cellIdentifier = @"soundCloudTrackCell";

//- (id) initWithArray:(NSArray*)tracks
//{
//    
//    self = [super init];
//    if(self){
//        self.tracksFromSoundCloud = tracks;
//    }
//    
//    return self;
//}

- (void)viewDidLoad {

    [super viewDidLoad];
    // Add the gradient to the view
    [self.view.layer insertSublayer:[GFXUtils getGradient:self.view.bounds] atIndex:0];
    
    // Remove line between cells
    self.soundCloudResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.soundCloudResultsTableView.allowsMultipleSelectionDuringEditing = YES;
    self.selectedTracks = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tracksFromSoundCloud.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MediaItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *track = [self.tracksFromSoundCloud objectAtIndex:indexPath.row];
    tableView.backgroundColor = [UIColor clearColor];
    cell.track_title.text = [track objectForKey:@"title"];
    cell.artist.text = [[track objectForKey:@"user"] objectForKey:@"username"];
    cell.duration.text = [NSString stringWithFormat:@"%@", [Utils convertTimeFromMillis:(int) [[track objectForKey:@"duration"] intValue]]];
    [cell setAlbumArtworkFromStringURL:[track objectForKey:@"artwork_url"]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MediaItem* mediaItemSelected = [self mediaItemFromCell:indexPath.row];
    NSDictionary *itemOne = [self.tracksFromSoundCloud objectAtIndex:indexPath.row];
    MediaItem* mediaItemSelected = [[MediaItem alloc] initWithSoundCloudTrack:[self.tracksFromSoundCloud objectAtIndex:indexPath.row]];
//    MediaItem* mediaItemSelected = [[MediaItem alloc] init];
    
    if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
//        cell clicked and it was previously selected
        [self removeMediaItemFromSelectedTracks:mediaItemSelected];
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    }else{
        
//        cell clicked and it was not previously selected
        if(![self itemAlreadySelected:mediaItemSelected])
            [self.selectedTracks addObject:mediaItemSelected];
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [self printSelectedTracks];
}

-(void) addSoundCloudFavorites:(NSArray*)tracks
{
    self.tracksFromSoundCloud = tracks;
    [self.soundCloudResultsTableView reloadData];
}

//-(MediaItem*)mediaItemFromCell:(NSInteger)index
//{
//    NSDictionary *selectedTrack = [self.tracksFromSoundCloud objectAtIndex:index];
//    MediaItem* mediaItem = [[MediaItem alloc] init];
//    mediaItem.track_title = [selectedTrack objectForKey:@"title"];
//    mediaItem.artist = [selectedTrack objectForKey:@"user"];
//    mediaItem.duration = [selectedTrack objectForKey:@"duration"];
//    NSString *stringURL = (NSString*)[selectedTrack objectForKey:@"artwork_url"];
//    if([stringURL isEqual:[NSNull null]]){
//        stringURL = @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi8MYn94Vl1HVxqMb7u31QSRa3cNCJOYhxw7xI_GGDvcSKQ7xwPA370w";
//    }
//    //    stringURL = [stringURL stringByReplacingOccurrencesOfString:@"large" withString:@"t67x67"];
//    NSURL *imageURL = [NSURL URLWithString:stringURL];
//    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//    UIImage *myImage = [UIImage imageWithData:imageData];
//    mediaItem.artwork = (UIImage*)myImage;
//    
//    return mediaItem;
//}

-(void)printSelectedTracks
{
    NSLog(@"Printing the tracks selected by the user");
    for(MediaItem* mediaItem in self.selectedTracks){
        NSLog(@"%@", mediaItem.track_title);
    }
}

-(BOOL)itemAlreadySelected:(MediaItem*)selected
{
    for(MediaItem * mediaItem in self.selectedTracks)
    {
        if(selected.track_title == mediaItem.track_title && selected.artist == mediaItem.artist)
        {
            return true;
        }
    }
    return false;
}

-(void)removeMediaItemFromSelectedTracks:(MediaItem *)itemToRemove
{
    NSUInteger indexToDelete = -1;
    NSUInteger counter = 0;
    for(MediaItem * mediaItem in self.selectedTracks)
    {
        if(itemToRemove.track_title == mediaItem.track_title && itemToRemove.artist == mediaItem.artist)
        {
            indexToDelete = counter;
        }
        counter++;
    }
    if(indexToDelete!=-1){
        [self.selectedTracks removeObjectAtIndex:indexToDelete];
    }
}

-(IBAction)addSelectedTracksToPlaylist:(id)sender
{
    [[Playlist sharedPlaylist] addTracks:self.selectedTracks];
}


// The close button

-(IBAction)closeMediaPicker:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
