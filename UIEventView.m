//
//  UIEventView.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-30.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "UIEventView.h"
#import "RoomsViewController.h"

@implementation UIEventView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
            _title.text = @"title";
            _location.text = [event objectForKey:@"city"];
            //id might actually be an int already
            _room_number_label.text = [NSString stringWithFormat:@"Room Identifier: %@", [event objectForKey:@"id"]];
            _room_number = _room_number_label.text;
        }
        return self;
}


-(IBAction)buttonAction
{
    [SDSAPI joinRoom:self.room_number];
    [Room currentRoom].room_number = self.room_number;
    [SDSAPI getPlaylist:self.room_number];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerPageViewController *player_page = [sb instantiateViewControllerWithIdentifier:@"pp"];
    
    [_rooms_view_controller presentViewController:player_page animated:YES completion:nil];
    
}

@end
