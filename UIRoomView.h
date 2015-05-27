//
//  UIRoomView.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-27.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerPageViewController.h"
#import "SDSAPI.h"

@interface UIRoomView : UIView

@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *other_listeners;
@property (nonatomic, weak) IBOutlet UILabel *room_number;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, weak) NSString *raw_room_number;

-(void)buttonAction;

@end
