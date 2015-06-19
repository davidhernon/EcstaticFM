//
//  UIAroundMeHereEmptyView.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-06-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerPageViewController.h"
#import "UIRoomView.h"
#import "MediaPageViewController.h";
@class RoomsViewController;

@interface UIAroundMeHereEmptyView : UIRoomView

@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UILabel *room_number_label;
@property (nonatomic, weak) RoomsViewController *rooms_view_controller;
- (id) initWithFrame:(CGRect)aRect withEvent:(NSDictionary*)event withRoomController:(RoomsViewController*)sender;

@end
