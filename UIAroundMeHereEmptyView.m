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
        self.room_number_label.text = @"Here";
    }
    return self;
}

-(IBAction)buttonAction
{
	if([[Player sharedPlayer] playlist].count > 0){
		UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		PlayerPageViewController *player_page = [sb instantiateViewControllerWithIdentifier:@"pp"];
		[_rooms_view_controller presentViewController:player_page animated:NO completion:nil];
	}
	else{
		UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		MediaPageViewController *mediaPageViewController = [sb instantiateViewControllerWithIdentifier:@"mediaPageViewController"];
		PlayerPageViewController *player_page = [sb instantiateViewControllerWithIdentifier:@"pp"];
		
        //initiate a crossfade transition on segue
		CATransition* transition = [CATransition animation];
		transition.duration = 0.3;
		transition.type = kCATransitionFade;
		transition.subtype = kCATransitionFromBottom;
		
		[self.view.window.layer addAnimation:transition forKey:kCATransition];
		
        //send me to geoask
		[_rooms_view_controller presentViewController:player_page animated:NO completion:^{
			[player_page presentViewController:mediaPageViewController animated:NO completion:nil];
		}];

	}
}

@end
