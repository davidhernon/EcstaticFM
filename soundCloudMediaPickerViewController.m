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

- (id) initWithArray:(NSArray*)tracks
{
    
    self = [super init];
    if(self){
        self.tracksFromSoundCloud = tracks;
    }
    
    return self;
}

- (void)viewDidLoad {
    //[self getFavorites:self];
//    [self makeSoundCloudQuery];
    [super viewDidLoad];
    //[self.soundCloudResultsTableView reloadData];
    // Do any additional setup after loading the view.
    
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
//Do we need this? I dont think so
//    if (cell == nil) {
//        cell = [[MediaItemTableViewCell alloc]
//                initWithStyle:UITableViewCellStyleDefault
//                reuseIdentifier:@"soundCloudCell"];
//    }
    
    NSDictionary *track = [self.tracksFromSoundCloud objectAtIndex:indexPath.row];
    cell.track_title.text = [track objectForKey:@"title"];
    cell.artist.text = [[track objectForKey:@"user"] objectForKey:@"username"];
    cell.duration.text = [NSString stringWithFormat:@"%@", [self convertTimeFromMillis:(int) [[track objectForKey:@"duration"] intValue]]];
    NSString *stringURL = (NSString*)[track objectForKey:@"artwork_url"];
    if([stringURL isEqual:[NSNull null]]){
        stringURL = @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi8MYn94Vl1HVxqMb7u31QSRa3cNCJOYhxw7xI_GGDvcSKQ7xwPA370w";
    }
//    stringURL = [stringURL stringByReplacingOccurrencesOfString:@"large" withString:@"t67x67"];
    NSURL *imageURL = [NSURL URLWithString:stringURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *myImage = [UIImage imageWithData:imageData];
    cell.sc_album_image.image = (UIImage*)myImage;
    return cell;
    
}

-(void) addSoundCloudFavorites:(NSArray*)tracks
{
    self.tracksFromSoundCloud = tracks;
    [self.soundCloudResultsTableView reloadData];
}

-(NSString*)convertTimeFromMillis:(int)millis
{
    NSInteger seconds = (NSInteger) (millis / 1000) % 60 ;
    NSInteger minutes = (NSInteger) ((millis / (1000*60)) % 60);
    NSInteger hours   = (NSInteger) ((millis / (1000*60*60)) % 24);
    if(hours != 0){
        return [NSString stringWithFormat:@"%ld:%ld:%ld",hours,minutes,seconds];
    }else{
        return [NSString stringWithFormat:@"%ld:%ld",minutes,seconds];
    }
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
