//
//  UIRoomView.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-26.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "UIRoomView.h"

@implementation UIRoomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *views = [mainBundle loadNibNamed:@"RoomView"
                                        owner:nil
                                      options:nil];
    [self addSubview:views[0]];
    
    return self;
}

@end
