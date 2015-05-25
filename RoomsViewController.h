//
//  RoomsViewController.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-06.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"
#import "GFXUtils.h"
#import "RadialGradientLayer.h"

#define kUVCellDragInterval 180.f

@interface RoomsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>;


@property (weak, nonatomic) IBOutlet UITableView *roomTableView;
@property NSArray* popular;
@property NSArray* around_me;

@property (weak, nonatomic) IBOutlet UIScrollView *roomsScrollView;
@property (weak, nonatomic) IBOutlet UIGestureRecognizer *roomsGestureRecognizer;


@property (weak, nonatomic) IBOutlet UIButton *roomsSwipe;

-(IBAction)buttonPressed:(id)sender;

@end
