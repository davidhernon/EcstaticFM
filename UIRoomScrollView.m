//
//  UIRoomScrollView.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-27.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "UIRoomScrollView.h"

@implementation UIRoomScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}

@end
