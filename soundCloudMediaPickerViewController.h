//
//  soundCloudMediaPickerViewController.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-03-13.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaItemTableViewCell.h"
#import "MediaItem.h"
#import "SCUI.h"
#import "Playlist.h"
#import "GFXUtils.h"
#import "RadialGradientLayer.h"
#import "SDSAPI.h"
#import "SoundCloudAPI.h"
#import "ILTranslucentView.h"

@interface soundCloudMediaPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *sCMediaPickerSpinner;
@property (weak, nonatomic) IBOutlet UIButton *addSongsToPlaylist;
@property (weak, nonatomic) IBOutlet UIButton *closeMediaPickerButton;
@property (weak, nonatomic) IBOutlet UIButton *soundcloudLoginButton;


@property (weak, nonatomic) IBOutlet UITableView *soundCloudResultsTableView;
@property (weak, nonatomic) IBOutlet UIView *connect_to_soundcloud;
@property NSMutableArray *selectedTracks;
@property (strong, nonatomic) NSMutableArray *selectedTrackIndices;

@property (strong, nonatomic) NSArray *tracksFromSoundCloud;
@property (strong, nonatomic) NSMutableArray *soundCloudAlbumImages;
@property (strong, nonatomic) NSArray *soundCloudAlbumUrls;
@property BOOL returned;

-(IBAction)searchSoundcloud:(id)sender;
-(IBAction)showSearchSoundCloudUI:(id)sender;
-(void) addSoundCloudFavorites:(NSArray*)tracks;
-(void) getAlbumImageArray;
-(void)updateTable;



@end
