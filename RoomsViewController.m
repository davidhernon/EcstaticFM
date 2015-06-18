//
//  RoomsViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-06.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "RoomsViewController.h"

@implementation RoomsViewController
#define kDragVelocityDampener .85

// https://api.soundcloud.com/tracks/189670713/stream
// https://api.soundcloud.com/tracks/189917203/stream
// https://api.soundcloud.com/tracks/191160846/stream

-(void)createDummyRooms
{
    _popular = @[[[Room alloc] init]];
    
}

static NSString* popular_event_cell = @"popular_event_cell";
static NSString* around_me_event_cell = @"around_me_cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    int x = 0;
//    int number_of_events = 5;
//    for( int i = 0; i < number_of_events; i++)
//    {
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 234, 234)];
//        UIRoomView *room_view = [[UIRoomView alloc] initWithFrame:CGRectMake(x, 0, 234, 234)];
//        button.tag = i;
//        [button addTarget:self  action:@selector(joinRoom:) forControlEvents:UIControlEventTouchUpInside];
//        [button addSubview:room_view];
//        [_roomsScrollView addSubview:button];
//        x += (234/2) + 15;
//    }
//    
//    _roomsScrollView.contentSize = CGSizeMake(x, _roomsScrollView.frame.size.height);
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if(_upcoming_events == nil)
    {
        _upcoming_events = [SDSAPI getUpcomingEvents];
    }
    
    // if _rooms_around_me is nil then we need to laod the username and go get them
    if(_rooms_around_me == nil)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* username = [defaults objectForKey:@"username"];
        [SDSAPI aroundMe:username withID:self];
    }
    
    int x = 50;
    // get the upcoming events and populate them on screen
    for(NSDictionary *event in _upcoming_events)
    {
        if(event == [NSNull null]){
            continue;
        }
        UIEventView *room_view = [[UIEventView alloc] initWithFrame:CGRectMake(x, 0, 234, 234) withEvent:event withRoomController:self];
        [_roomsScrollView addSubview:room_view];
        x += (234) + 15;
    }
    
    UIAroundMeHereEmptyView *room_view = [[UIAroundMeHereEmptyView alloc] initWithFrame:CGRectMake(x, 0, 234, 234) withEvent:nil withRoomController:self];
    [_roomsScrollView addSubview:room_view];
    x += (234) + 15;

    // get the rooms around me and populate them in their cells
    for( NSDictionary *room in _rooms_around_me)
    {
        if(room == [NSNull null]){
            continue;
        }
		NSDictionary *room_info = [room objectForKey:@"room_info"];
		if(room_info == [NSNull null]){
			continue;
		}
        UIAroundMeView *room_view = [[UIAroundMeView alloc] initWithFrame:CGRectMake(x, 0, 234, 234) withEvent:room withRoomController:self];
        [_roomsScrollView addSubview:room_view];
        x += (234) + 15;
    }
    _roomsScrollView.contentSize = CGSizeMake(x, _roomsScrollView.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showRoomsScrollView:(NSArray*)room_dictionaries
{
    _rooms_around_me = [[NSArray alloc] init];
    _rooms_around_me = room_dictionaries;
    [self viewDidLoad];
    [self viewWillAppear:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    _rooms_around_me = nil;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat kMaxIndex = 23;
    CGFloat targetX = scrollView.contentOffset.x + velocity.x * 60.0;
    CGFloat targetIndex = round(targetX / (234 + 15));
    if (targetIndex < 0)
        targetIndex = 0;
    if (targetIndex > kMaxIndex)
        targetIndex = kMaxIndex;
    targetContentOffset->x = targetIndex * (234 + 15);
}

@end
