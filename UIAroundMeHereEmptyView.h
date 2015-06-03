//
//  UIAroundMeHereEmptyView.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-06-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerPageViewController.h"
@class RoomsViewController;

@interface UIAroundMeHereEmptyView : UIView

@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, weak) RoomsViewController *rooms_view_controller;

- (id) initWithFrame:(CGRect)aRect withEvent:(NSDictionary*)event withRoomController:(RoomsViewController*)sender;

@end
