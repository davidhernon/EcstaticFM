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
    
    // Transparency
    
    _soundCloudResultsTableView.backgroundColor = [UIColor clearColor];
    
    // Add the gradient to the view
    [self.view.layer insertSublayer:[GFXUtils getGradientPlayer:(CGRect)self.view.bounds] atIndex:0];
    
    // Remove line between cells
    self.soundCloudResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.soundCloudResultsTableView.allowsMultipleSelectionDuringEditing = YES;
    self.selectedTracks = [[NSMutableArray alloc] init];
    self.selectedTrackIndices = [[NSMutableArray alloc] init];
    self.soundCloudAlbumImages = [[NSMutableArray alloc] init];
    [self getAlbumImageArray];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if([SCSoundCloud account] == nil)
    {
        _connect_to_soundcloud.hidden = NO;
    }else{
        _connect_to_soundcloud.hidden = YES;
    }
    
    [SoundCloudAPI getFavorites:self];
    
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *track = [self.tracksFromSoundCloud objectAtIndex:indexPath.row];
    tableView.backgroundColor = [UIColor clearColor];
    cell.track_title.text = [track objectForKey:@"title"];
    cell.artist.text = [[track objectForKey:@"user"] objectForKey:@"username"];
    cell.duration.text = [NSString stringWithFormat:@"%@", [Utils convertTimeFromMillis:(int) [[track objectForKey:@"duration"] intValue]]];

    if(indexPath.row < [_soundCloudAlbumImages count])
    {
        cell.sc_album_image.image = [_soundCloudAlbumImages objectAtIndex:indexPath.row];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    for (int i = 0; i < _selectedTrackIndices.count; i++) {
        NSUInteger num = [[_selectedTrackIndices objectAtIndex:i] intValue];
        
        if (num == indexPath.row) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            // Once we find a match there is no point continuing the loop
            break;
        }
    }
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MediaItem* mediaItemSelected = [self mediaItemFromCell:indexPath.row];
    NSDictionary *itemOne = [self.tracksFromSoundCloud objectAtIndex:indexPath.row];
    MediaItem* mediaItemSelected = [[MediaItem alloc] initWithSoundCloudTrack:[self.tracksFromSoundCloud objectAtIndex:indexPath.row]];
    
    if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
//        cell clicked and it was previously selected
        [self removeMediaItemFromSelectedTracks:mediaItemSelected];
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [_selectedTrackIndices removeObject:@(indexPath.row)];
    }else{
//        cell clicked and it was not previously selected
        if(![self itemAlreadySelected:mediaItemSelected])
            [self.selectedTracks addObject:mediaItemSelected];
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [_selectedTrackIndices addObject:@(indexPath.row)];
    }
    [self printSelectedTracks];
}

-(void) addSoundCloudFavorites:(NSArray*)tracks
{
    self.tracksFromSoundCloud = tracks;
    [self.soundCloudResultsTableView reloadData];
}

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
    for(MediaItem* item in self.selectedTracks)
    {
        [SDSAPI sendMediaItemToServer:item];
    }
}

-(void) getAlbumImageArray
{
//    @property (strong, nonatomic) NSArray *soundCloudAlbumImages;
//    @property (strong, nonatomic) NSArray *soundCloudAlbumUrls;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(_tracksFromSoundCloud == nil)
        {
            [NSThread sleepForTimeInterval:0.1f];
        }
        
        for(NSDictionary *track in _tracksFromSoundCloud)
        {
            NSString *url = [track objectForKey:@"artwork_url"];
            if([url isEqual:[NSNull null]]){
                url = @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi8MYn94Vl1HVxqMb7u31QSRa3cNCJOYhxw7xI_GGDvcSKQ7xwPA370w";
            }
            NSURL *imageURL = [NSURL URLWithString:url];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage *myImage = [UIImage imageWithData:imageData];
            [_soundCloudAlbumImages addObject:myImage];
            NSLog(@"reload!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            [_soundCloudResultsTableView performSelectorOnMainThread:@selector(reloadData)
                                             withObject:nil
                                          waitUntilDone:NO];
            

        }
        
    });
    
}

// selected state checkmark



// The close button

-(IBAction)closeMediaPicker:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString*)getLargestArtwork:(NSString*)providedURLString
{
    
    return nil;
}

-(IBAction)soundcloudLogin:(id)sender
{
    [SoundCloudAPI login:self];
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
