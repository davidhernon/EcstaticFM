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
    
    //hide add button
    _addSongsToPlaylist.hidden = YES;
    _sCMediaPickerSpinner.hidden = NO;
    
    // Transparency
    
    _soundCloudResultsTableView.backgroundColor = [UIColor clearColor];
    
    // Add the gradient to the view
    [self.view.layer insertSublayer:[GFXUtils getGradientMediaPicker:(CGRect)self.view.bounds] atIndex:0];
    
    
    // Remove line between cells
    self.soundCloudResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.soundCloudResultsTableView.allowsMultipleSelectionDuringEditing = YES;
    self.selectedTracks = [[NSMutableArray alloc] init];
    self.selectedTrackIndices = [[NSMutableArray alloc] init];
    self.soundCloudAlbumImages = [[NSMutableArray alloc] init];
    self.selected_favorites_indices = [[NSMutableArray alloc] init];
    self.selected_sds_indices = [[NSMutableArray alloc] init];
    self.selected_search_indices = [[NSMutableArray alloc] init];
//    [self getAlbumImageArray];

    _current_media_picker_type = @"favorites";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    //used to hold highlighting when switching between pickers
    // starts on favorites as we show the users favorites first
    
    
    // Load images
    NSArray *imageNames = @[@"spinner-1.png", @"spinner-2.png", @"spinner-3.png", @"spinner-4.png",
                            @"spinner-5.png", @"spinner-6.png", @"spinner-7.png", @"spinner-8.png", @"spinner-9.png", @"spinner-10.png", @"spinner-11.png", @"spinner-12.png", @"spinner-13.png", @"spinner-14.png", @"spinner-15.png", @"spinner-16.png", @"spinner-17.png", @"spinner-18.png", @"spinner-19.png", @"spinner-20.png", @"spinner-21.png", @"spinner-22.png", @"spinner-23.png", @"spinner-24.png", @"spinner-25.png", @"spinner-26.png", @"spinner-27.png", @"spinner-28.png", @"spinner-29.png", @"spinner-30.png", @"spinner-0.png"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    
    _sCMediaPickerSpinner.animationImages = images;
    _sCMediaPickerSpinner.animationDuration = 0.5;
    [_sCMediaPickerSpinner startAnimating];
    
    
    if([SCSoundCloud account] == nil)
    {
        _connect_to_soundcloud.hidden = NO;
        _sCMediaPickerSpinner.hidden = YES;
    }else{
        _connect_to_soundcloud.hidden = YES;
        _soundcloudLoginButton.hidden = YES;
        _sCMediaPickerSpinner.hidden = NO;
    }
//    _tracksFromSoundCloud = nil;
//    [SoundCloudAPI getFavorites:self];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        while(_tracksFromSoundCloud == nil){
//            [NSThread sleepForTimeInterval:0.1f];
//        }
//    });
    [self getAlbumImageArray];
    
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
    
    //remove spinner
    _addSongsToPlaylist.hidden = NO;
    _sCMediaPickerSpinner.hidden = YES;

    if(indexPath.row < [_soundCloudAlbumImages count])
    {
        cell.sc_album_image.image = [_soundCloudAlbumImages objectAtIndex:indexPath.row];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < _selectedTrackIndices.count; i++) {
        NSUInteger num = [[_selectedTrackIndices objectAtIndex:i] intValue];
        
        if (num == indexPath.row) {
//            [self setCellColor:[UIColor whiteColor] ForCell:cell];
            cell.backgroundColor = [UIColor colorWithRed:0.369 green:0.078 blue:0.298 alpha:0.25];;
            // Once we find a match there is no point continuing the loop

            
            break;
        }
    }
    
    
    
    return cell;
    

    
}

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Add your Colour.
//    MediaItemTableViewCell *cell = (MediaItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [self setCellColor:[UIColor whiteColor] ForCell:cell];  //highlight colour
//}
//
//- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Reset Colour.
//    MediaItemTableViewCell *cell = (MediaItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [self setCellColor:[UIColor clearColor] ForCell:cell]; //normal color
//    
//}
//
//- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
//    cell.contentView.backgroundColor = color;
//    cell.backgroundColor = color;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MediaItem* mediaItemSelected = [self mediaItemFromCell:indexPath.row];
//    NSDictionary *itemOne = [self.tracksFromSoundCloud objectAtIndex:indexPath.row];
    MediaItem* mediaItemSelected = [[MediaItem alloc] initWithSoundCloudTrack:[self.tracksFromSoundCloud objectAtIndex:indexPath.row]];
    
    if([tableView cellForRowAtIndexPath:indexPath].backgroundColor != [UIColor clearColor]){
//        cell clicked and it was previously selected
        [self removeMediaItemFromSelectedTracks:mediaItemSelected];
//        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor clearColor];
        [_selectedTrackIndices removeObject:@(indexPath.row)];
    }else{
//        cell clicked and it was not previously selected
        if(![self itemAlreadySelected:mediaItemSelected])
            [self.selectedTracks addObject:mediaItemSelected];
//        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor colorWithRed:0.369 green:0.078 blue:0.298 alpha:0.25];
        //skip over this step if we are on search
        if(![_current_media_picker_type isEqualToString:@"search"])
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

//Checks to see if the MediaItem selected was already selected
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

//Change which list we track selections with
-(void)changeSelectedListWithString:(NSString*)new_list from:(NSString*)old_list
{
    //save the current track indices into the proper lists
    if([_current_media_picker_type isEqualToString:@"favorites"]){
        _selected_favorites_indices = _selectedTrackIndices;
    }else if([_current_media_picker_type isEqualToString:@"sds_mixes"]){
        _selected_sds_indices = _selectedTrackIndices;
    }else{
        _selected_search_indices = _selectedTrackIndices;
    }
    
    //change which current indices list we are holding
    _current_media_picker_type  = new_list;
    
    //set the selectedIndices to the new list selected indices
    if([new_list isEqualToString:@"favorites"]){
        _selectedTrackIndices = _selected_favorites_indices;
    }else if([new_list isEqualToString:@"sds_mixes"]){
        _selectedTrackIndices = _selected_sds_indices;
    }else{
        //search
        _selectedTrackIndices = _selected_search_indices;
    }
    
    _selected_search_indices = @[];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _soundCloudAlbumImages = nil;
        _soundCloudAlbumImages = [[NSMutableArray alloc] init];
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
	if([Playlist sharedPlaylist].count > 0){
		[self dismissViewControllerAnimated:YES completion:nil];
	}
	else{
		UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		RoomsViewController *aroundMe = [sb instantiateViewControllerWithIdentifier:@"aroundMe"];
		[self presentViewController:aroundMe animated:NO completion:nil];
	}
}

-(NSString*)getLargestArtwork:(NSString*)providedURLString
{
    
    return nil;
}

-(IBAction)soundcloudLogin:(id)sender
{

    [SoundCloudAPI login:self];


    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                while([SCSoundCloud account] == nil)
                {
                    [NSThread sleepForTimeInterval:0.1f];
                }
//        [SoundCloudAPI getFavorites:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getFaves];
        });
        
    });

}

-(IBAction)showSearchSoundCloudUI:(id)sender
{
    // May break if there is more than one UIView in the NIB
    
    ILTranslucentView *search_soundcloud = [[[NSBundle mainBundle] loadNibNamed:@"SoundCloudSearchView" owner:self options:nil] objectAtIndex:0];
    search_soundcloud.translucentAlpha = 0;
    search_soundcloud.translucentStyle = UIBarStyleDefault;
    search_soundcloud.translucentTintColor = [UIColor clearColor];
    search_soundcloud.backgroundColor = [UIColor clearColor];
    
    [search_soundcloud addSender:self];
    
    [self.view addSubview:search_soundcloud];

    _soundCloudResultsTableView.hidden = YES;
}

-(void)searchSoundcloud:(NSString*)search_text
{
    //SWITCH switch from _old_list to search
    
    [self changeSelectedListWithString:@"search" from:_current_media_picker_type];
    
    [SoundCloudAPI searchSoundCloud:search_text withSender:self];
//    [self viewDidLoad];
    [self viewWillAppear:YES];
}

-(void)updateTable
{
//    self.selectedTracks = [[NSMutableArray alloc] init];
//    self.selectedTrackIndices = [[NSMutableArray alloc] init];
    [self.soundCloudResultsTableView reloadData];
    self.soundCloudAlbumImages = [[NSMutableArray alloc] init];
    [self getAlbumImageArray];
    
}

-(IBAction)getFaves
{
    //SWITCH switch from old_list to favorites
    [self changeSelectedListWithString:@"favorites" from:_current_media_picker_type];

    [SoundCloudAPI getFavorites:self];
}

-(IBAction)getSDSEventTracks
{
    //SWITCH switch from old_list to sds_mixes
    [self changeSelectedListWithString:@"sds_mixes" from:_current_media_picker_type];

    [SoundCloudAPI getSDSPlaylistsFromSoundCloud:self];
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
