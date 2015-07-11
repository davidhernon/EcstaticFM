//
//  PlayerViewController.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Playlist.h"
#import "MediaItemTableViewCell.h"
#import "Utils.h"
#import "Player.h"
#import "GFXUtils.h"
#import "RadialGradientLayer.h"
#import "LocationServices.h"
#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#import "PlayerPageViewController.h"
#import "MWLogging.h"
@class PLayerDelegate;

@interface PlayerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PlayerDelegate, SWTableViewCellDelegate, UIAlertViewDelegate>

- (IBAction)showRooms:(id)sender;
- (IBAction)playerControlsClicked:(id)sender;
- (IBAction)playerControlsUnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *playListTableView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *current_duration;
@property (weak, nonatomic) IBOutlet UILabel *current_time;
@property (weak, nonatomic) IBOutlet UILabel *current_artist;
@property (weak, nonatomic) IBOutlet UILabel *current_track_title;
@property int current_track_index;
@property (weak, nonatomic) IBOutlet UIImageView *current_album_artwork;
@property (weak, nonatomic) IBOutlet UIView *coveralpha;
@property (weak, nonatomic) IBOutlet UIButton *play;
@property (weak, nonatomic) IBOutlet UIButton *last;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *add_songs;
@property (weak, nonatomic) IBOutlet UIButton *add_songs_welcome;
@property (weak, nonatomic) IBOutlet UILabel *playlist_title;
@property (weak, nonatomic) IBOutlet UIImageView *current_user_picture;
@property (weak, nonatomic) IBOutlet UILabel *welcomehome;

@property (strong, nonatomic) MediaItem *track_to_download;

@property (weak,nonatomic) IBOutlet UIButton *playerShowControlsButton;
@property (weak,nonatomic) IBOutlet UIButton *playerHideControlsButton;

@property (weak, nonatomic) IBOutlet UIView *controlsDarkenView;
@property (weak, nonatomic) IBOutlet UIView *controlsView;

@property (weak, nonatomic) IBOutlet UIImageView *playerSpinner;
@property (weak, nonatomic) NSArray *playing_animation;
@property (weak, nonatomic) NSArray *spinner_animation;
@property BOOL loading_next_song;
@property BOOL loading_next_song_has_changed;

@property (retain, nonatomic) IBOutlet UILabel *room_title;
@property (weak, nonatomic) IBOutlet UIButton *download_mix_button;
@property (weak, nonatomic) IBOutlet UILabel *download_label;

//nav bar
@property (weak, nonatomic) IBOutlet UINavigationBar *_playerNavigationBar;
//playlist
//@property (weak, nonatomic) IBOutlet UITableView *_playerTableView;
@property (weak, nonatomic) IBOutlet UIView *_playerTableHeaderView;
@property (weak, nonatomic) IBOutlet UIView *_playerAddMusicCell;

@property (strong, nonatomic) NSMutableArray* playlist;
@property Player* player;
@property (weak, nonatomic) IBOutlet UIImageView *download_spinner;

@property BOOL can_download;

- (IBAction)sliderValueChanged:(UISlider *)sender;
-(void)downloadButtonSwitchSelected;
-(void)setIsDownloading;
-(void)setDownloadFinished;
-(void)updateDownloadProgress:(float)progress;
//- (void) initPlayerUI:(float)duration withTrack:(MediaItem*)currentTrack atIndex:(NSUInteger*)index;

@end