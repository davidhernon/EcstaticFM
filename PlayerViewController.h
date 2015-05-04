//
//  PlayerViewController.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playlist.h"
#import "MediaItemTableViewCell.h"
#import "Utils.h"
#import "Player.h"

@interface PlayerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *playListTableView;
@property (weak, nonatomic) NSArray* playlist;
@property (weak, nonatomic) Player* player;

@end
