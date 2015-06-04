//
//  UIAroundMeView.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-30.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "UIAroundMeView.h"
#import "RoomsViewController.h"

@implementation UIAroundMeView

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
        self.other_listeners = [event objectForKey:@"host_username"];
        self.room_number = [event objectForKey:@"room_number"];
        self.rooms_view_controller = sender;
        [self addSubview:self.view];
        _rooms_view_controller = sender;
        _title.text = [event objectForKey:@"city"];
        _other_listeners.text = @"Is there other listeners?";
        //id might actually be an int already
        _room_number_label.text = [NSString stringWithFormat:@"Room Identifier: %@", [event objectForKey:@"id"]];
        _room_number = _room_number_label.text;
    }
    return self;
}

//UIRoomView *room_view = [[UIRoomView alloc] initWithFrame:CGRectMake(x, 0, 234, 234)];
//room_view.rooms_view_controller = self;
//room_view.title.text = [event objectForKey:@"city"];
//room_view.other_listeners.text =  @"fix it Dave";
//room_view.room_number.text = @"More Text";
//room_view.raw_room_number = [NSString stringWithFormat:@"%d",[[event objectForKey:@"id"] intValue]*(-1)];

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
