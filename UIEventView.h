//
//  UIEventView.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-30.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerPageViewController.h"
#import "SDSAPI.h"
@class RoomsViewController;

@interface UIEventView : UIView

@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *location;
@property (nonatomic, weak) IBOutlet UILabel *hostname;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, weak) IBOutlet UILabel *room_number_label;
@property (nonatomic, retain) NSString *room_number;

@property (nonatomic, weak) RoomsViewController *rooms_view_controller;

- (id) initWithFrame:(CGRect)aRect withEvent:(NSDictionary*)event withRoomController:(RoomsViewController*)sender;


@end
