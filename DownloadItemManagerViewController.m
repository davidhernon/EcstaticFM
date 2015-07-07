//
//  DownloadItemManagerViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-07-06.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "DownloadItemManagerViewController.h"

@interface DownloadItemManagerViewController ()

@end

@implementation DownloadItemManagerViewController

static NSString* cellIdentifier = @"deletecell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewWillAppear:YES];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _downloaded_items = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:documentsPath];
    
    //Get the url for the absolute file path
    for (NSString *filename in fileEnumerator) {
        [_downloaded_items addObject:filename];
    }
    
    _downloaded_items_tableview.editing = YES;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_downloaded_items count];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MediaItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSString *item = [_downloaded_items objectAtIndex:indexPath.row];
    
    
    
    NSArray* foo = [item componentsSeparatedByString: @"."];
    NSString* song_id = [foo firstObject];
    
    //get metadata from song id, saved in user defaults when the song is saved
    NSDictionary *song_metadata = [[NSUserDefaults standardUserDefaults] objectForKey:song_id];
    
    cell.track_title.text = [song_metadata objectForKey:@"track_title"];
    cell.artist.text = [song_metadata objectForKey:@"artist"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //if the song is the current playing song then we cant delete it
    NSArray* parsed_download_title_array = [[_downloaded_items objectAtIndex:indexPath.row] componentsSeparatedByString: @"."];
    NSString* parsed_download_title = [parsed_download_title_array firstObject];
    
    if([[NSString stringWithFormat:@"%@", [Player sharedPlayer].currentTrack.sc_id] isEqualToString:parsed_download_title]){
        UIAlertView *deleteCurrentSongAlert=[[UIAlertView alloc]initWithTitle:@"Error:" message:@"Cannot Delete Currently Playing Track" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [deleteCurrentSongAlert show];
        return;
    }
    
    //set the media item to not be local and remove its metadata
    [[Playlist sharedPlaylist] removeLocalSongById:[_downloaded_items objectAtIndex:indexPath.row]];
    
    //delete item from list
    [_downloaded_items removeObjectAtIndex:indexPath.row];
    
    //prepare to delete the file on disk
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:documentsPath];
    //Get the url for the absolute file path
    for (NSString *filename in fileEnumerator) {
        if([((MediaItemTableViewCell*)[tableView cellForRowAtIndexPath:indexPath]).track_title.text isEqualToString:filename]){
            NSLog(@"delte it here!");
            NSString *absolute_path = [NSString stringWithFormat:@"%@/%@",documentsPath,filename];
            
            //delete the file
            NSError *error;
            BOOL success = [manager removeItemAtPath:absolute_path error:&error];
            if (success) {
                UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
                [removeSuccessFulAlert show];
            }
            else
            {
                NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
            }
        }
    }
    
    
    [tableView reloadData];
}
- (IBAction)backButton:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerPageViewController *player_page = [sb instantiateViewControllerWithIdentifier:@"pp"];

    [self presentViewController:player_page animated:NO completion:nil];
//        [player_page swipeToSettingsViewControllerForward];
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
