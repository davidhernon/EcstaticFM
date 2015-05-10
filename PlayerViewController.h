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


@interface PlayerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PlayerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *playListTableView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *current_duration;
@property (weak, nonatomic) IBOutlet UILabel *current_time;
@property (weak, nonatomic) IBOutlet UILabel *current_artist;
@property (weak, nonatomic) IBOutlet UILabel *current_track_title;
@property (weak, nonatomic) IBOutlet UIImageView *current_album_artwork;
@property (weak, nonatomic) IBOutlet UIImageView *current_waveform;
@property (weak, nonatomic) IBOutlet UIImageView *waveform;
@property (weak, nonatomic) IBOutlet UIButton *play;
@property (weak, nonatomic) IBOutlet UIButton *last;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *add_songs;


//nav bar
@property (weak, nonatomic) IBOutlet UINavigationBar *_playerNavigationBar;
//playlist
//@property (weak, nonatomic) IBOutlet UITableView *_playerTableView;
@property (weak, nonatomic) IBOutlet UIView *_playerTableHeaderView;
@property (weak, nonatomic) IBOutlet UIView *_playerAddMusicCell;


@property (weak, nonatomic) NSArray* playlist;
@property Player* player;

- (IBAction)sliderValueChanged:(UISlider *)sender;

@end