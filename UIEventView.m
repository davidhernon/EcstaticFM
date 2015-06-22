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
            _title.text = [event objectForKey:@"city"];
            _location.text = [event objectForKey:@"location"];
            NSNumber *start_time = [event objectForKey:@"start"];
            NSNumber *time_now = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
            double diff = abs([start_time doubleValue] - [time_now doubleValue]);
            NSString *time = [Utils convertSecondsToTime:diff];
            
            self.room_number_label.text = time;
            _room_number = [NSString stringWithFormat:@"%@",[event objectForKey:@"id"]];
        }
        return self;
}

-(IBAction)buttonAction
{
    NSString *negative_room_number = [NSString stringWithFormat:@"%i",[self.room_number intValue] * (-1)];
    [SDSAPI joinRoom:negative_room_number withUser:self.title.text];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerPageViewController *player_page = [sb instantiateViewControllerWithIdentifier:@"pp"];
    
    //initiate a crossfade transition on segue
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromBottom;
    
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    // send me to the player
    [_rooms_view_controller presentViewController:player_page animated:NO completion:nil];
}

@end
