//
//  UIAroundMeHereEmptyView.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-06-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "CreateRoomView.h"
#import "RoomsViewController.h"

@implementation CreateRoomView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    MWLogDebug(@"Rooms - CreateRoomView - initWithCoder - initializing Create Room View from Coder");
    
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
    MWLogDebug(@"Rooms - CreateRoomView - initWithFrame - initializing Create Room View with Frame");

    
    if ((self = [super initWithFrame:aRect])) {
        NSString *className = NSStringFromClass([self class]);
        self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        [self addSubview:self.view];
    }
    return self;
}

- (id) initWithFrame:(CGRect)aRect withEvent:(NSDictionary*)event withRoomController:(RoomsViewController*)sender
{
    MWLogDebug(@"Rooms - CreateRoomView - initWithFrame:withEvent:withRoomController - initializing Create Room View");
    
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

-(IBAction)createRoomButton
{
    MWLogDebug(@"Rooms - CreateRoomView - buttonAction - user selected a room button, leaving old room and entering room now. Will Present player and MediaPicker on top of it");
    
    // is not the default room
    //if(![[Room currentRoom].room_number isEqualToString: [NSString stringWithFormat:@"0" ]] ){
        NSLog(@"leave Room");
        [SDSAPI leaveRoom];
    //}
    
	[SDSAPI setCreateRoomBool:true];
	NSString *usr = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];

	//if the playlist is empty, and you are the owner of the room,
	[SDSAPI createRoom: usr];

	UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	MediaPageViewController *mediaPageViewController = [sb instantiateViewControllerWithIdentifier:@"mediaPageViewController"];
	PlayerPageViewController *player_page = [sb instantiateViewControllerWithIdentifier:@"pp"];
	
	CATransition* transition = [CATransition animation];
	transition.duration = 0.3;
	transition.type = kCATransitionFade;
	transition.subtype = kCATransitionFromBottom;
	
	[self.view.window.layer addAnimation:transition forKey:kCATransition];
	
	[_rooms_view_controller presentViewController:player_page animated:NO completion:^{
		[player_page presentViewController:mediaPageViewController animated:NO completion:nil];
	}];
}

@end
