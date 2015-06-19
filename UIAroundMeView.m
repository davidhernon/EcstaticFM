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
    NSArray *users = [event objectForKey:@"users"];
    NSDictionary *room_info = [event objectForKey:@"room_info"];
    if([room_info count]==0){
        NSLog(@"Ecstatic - UIAroundMeView - initWithFrame - room_info count returned from server was empty");
    }
    if((self = [super initWithFrame:aRect]))
    {
        NSString *className = NSStringFromClass([self class]);
        self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        self.other_listeners.text = [NSString stringWithFormat:@"%@ and %i other(s)", [room_info objectForKey:@"host_username"], [users count] - 1];
        self.room_number_label.text = [NSString stringWithFormat:@"Room Number: %@", [room_info objectForKey:@"room_number"]];
        self.room_number = [room_info objectForKey:@"room_number"];
        self.rooms_view_controller = sender;
        self.title.text = [room_info objectForKey:@"room_name"];
        [self addSubview:self.view];
    }
    return self;
}

-(IBAction)buttonAction
{
    [SDSAPI joinRoom:self.room_number];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerPageViewController *player_page = [sb instantiateViewControllerWithIdentifier:@"pp"];
    
    [_rooms_view_controller presentViewController:player_page animated:YES completion:nil];
    
}

@end
