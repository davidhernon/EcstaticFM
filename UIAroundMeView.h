//
//  UIAroundMeView.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-30.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerPageViewController.h"
#import "SDSAPI.h"
@class RoomsViewController;

@interface UIAroundMeView : UIView

@property (nonatomic, retain) IBOutlet UIView *view;
@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *other_listeners;
@property (nonatomic, retain) IBOutlet UILabel *room_number_label;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, retain) NSString *room_number;
@property BOOL *is_an_event;

@property (nonatomic, weak) RoomsViewController *rooms_view_controller;

- (id) initWithFrame:(CGRect)aRect withEvent:(NSDictionary*)event withRoomController:(RoomsViewController*)sender;

@end
