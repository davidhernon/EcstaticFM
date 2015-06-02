//
//  UIAroundMeHereEmptyView.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-06-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "UIAroundMeHereEmptyView.h"
#import "RoomsViewController.h"

@implementation UIAroundMeHereEmptyView

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

- (id) initWithFrame:(CGRect)aRect withEvent:(NSDictionary*)event withRoomController:(RoomsViewController*)sender
{
    if((self = [super initWithFrame:aRect]))
    {
        NSString *className = NSStringFromClass([self class]);
        self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        [self addSubview:self.view];
        _rooms_view_controller = sender;
    }
    return self;
}

-(IBAction)buttonAction
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerPageViewController *player_page = [sb instantiateViewControllerWithIdentifier:@"pp"];
    
    [_rooms_view_controller presentViewController:player_page animated:YES completion:nil];
    
}

@end
