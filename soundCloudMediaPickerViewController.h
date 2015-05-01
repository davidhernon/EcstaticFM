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


@interface soundCloudMediaPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *soundCloudResultsTableView;

@property (strong, nonatomic) NSArray *tracksFromSoundCloud;
@property BOOL returned;

-(void)searchSC;
-(void) addSoundCloudFavorites:(NSArray*)tracks;

@end
