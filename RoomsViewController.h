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
#import "SDSAPI.h"
#import "LocationServices.h"
#import "AroundMeTableViewCell.h"
#import "UIAroundMeView.h"
#import "UIEventView.h"
#import "UIAroundMeHereEmptyView.h"
#define kUVCellDragInterval 180.f

@interface RoomsViewController : UIViewController <UIScrollViewDelegate>;

@property (weak, nonatomic) IBOutlet UITableView *roomTableView;
@property NSArray* popular;
@property NSArray* around_me;
@property LocationServices* locationServices;
@property NSArray* rooms_around_me;
@property NSArray* upcoming_events;
- (void)showRoomsScrollView:(NSArray*)room_dictionaries;

@property (strong, nonatomic) IBOutlet UIScrollView *roomsScrollView;
@property (weak, nonatomic) IBOutlet UIGestureRecognizer *roomsGestureRecognizer;


@property (weak, nonatomic) IBOutlet UIButton *roomsSwipe;
@property (weak, nonatomic) IBOutlet UIView *roomView;

-(IBAction)buttonPressed:(id)sender;

@end
