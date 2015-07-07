//
//  DownloadItemManagerViewController.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-07-06.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaItemTableViewCell.h"
#import "PlayerPageViewController.h"
#import "Player.h"

@interface DownloadItemManagerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *downloaded_items_tableview;
@property NSMutableArray *downloaded_items;

@end
