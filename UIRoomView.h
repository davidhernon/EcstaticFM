//
//  UIRoomView.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-27.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIRoomView : UIView

@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *other_listeners;
@property (nonatomic, weak) IBOutlet UILabel *room_number;
@property (nonatomic, weak) IBOutlet UIButton *button;

-(void)buttonAction;

@end
