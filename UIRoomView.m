//
//  UIRoomView.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-27.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "UIRoomView.h"


@implementation UIRoomView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSString *className = NSStringFromClass([self class]);
        self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        [self addSubview:self.view];
        return self;
    }
    return nil;
}

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        NSString *className = NSStringFromClass([self class]);
        self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        [self addSubview:self.view];
    }
    return self;
}

// Move the User to the Room associated with the screen that they just clicked
-(IBAction)buttonAction
{
//    PlayerPageViewController *player = [[PlayerPageViewController alloc] init];
//    
//    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:player animated:YES completion:nil];
    [SDSAPI joinRoom:self.raw_room_number];
    [Room currentRoom].room_number = self.raw_room_number;
    [SDSAPI getPlaylist:self.raw_room_number];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
