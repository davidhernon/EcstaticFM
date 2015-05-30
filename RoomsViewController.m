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
    _upcoming_events = [SDSAPI getUpcomingEvents];
	self.locationServices = [[LocationServices alloc]init];
	[self.locationServices start_location_services];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if(_upcoming_events == nil)
    {
        _upcoming_events = [SDSAPI getUpcomingEvents];
    }
    
    if(_rooms_around_me == nil)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* username = [defaults objectForKey:@"username"];
        [SDSAPI aroundMe:username withID:self];
    }
    NSLog(@"room cards: %@", _rooms_around_me);
    
        int x = 0;
//        int number_of_events = [_rooms_around_me count];
    
        for(NSDictionary *event in _upcoming_events)
        {
            UIEventView *room_view = [[UIEventView alloc] initWithFrame:CGRectMake(x, 0, 234, 234) withEvent:event withRoomController:self];
//            UIRoomView *room_view = [[UIRoomView alloc] initWithFrame:CGRectMake(x, 0, 234, 234)];
//            room_view.rooms_view_controller = self;
//            room_view.title.text = [event objectForKey:@"city"];
//            room_view.other_listeners.text =  @"fix it Dave";
//            room_view.room_number.text = @"More Text";
//            room_view.raw_room_number = [NSString stringWithFormat:@"%d",[[event objectForKey:@"id"] intValue]*(-1)];
            [_roomsScrollView addSubview:room_view];
            x += (234) + 15;
        }
    
        for( NSDictionary *room in _rooms_around_me)
        {
            UIRoomView *room_view = [[UIRoomView alloc] initWithFrame:CGRectMake(x, 0, 234, 234)];
            room_view.rooms_view_controller = self;
            room_view.title.text = [room objectForKey:@"room_name"];
            room_view.other_listeners.text = [NSString stringWithFormat:@"%@ & %d Other(s)",[room objectForKey:@"host_username"], [[room objectForKey:@"number_of_users"] intValue]-1];
            room_view.room_number.text = [NSString stringWithFormat:@"Room Number %@",[room objectForKey:@"room_number"]];
            room_view.raw_room_number = [room objectForKey:@"room_number"];
            [_roomsScrollView addSubview:room_view];
            x += (234) + 15;
        }
    _roomsScrollView.contentSize = CGSizeMake(x, _roomsScrollView.frame.size.height);
}

-(void)joinRoom
{
    
    NSLog(@"*******  !!!!!!!!!!!! Holy fuck we clicked a button !!!!!!!!!!! ****** ");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    if (section == 1)
        return [_rooms_around_me count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AroundMeTableViewCell *cell = [[AroundMeTableViewCell alloc] init];
//    tableView.backgroundColor = [UIColor clearColor];
//    cell.backgroundColor = [UIColor clearColor];
//    cell.contentView.backgroundColor = [UIColor clearColor];
//    cell.backgroundColor = [UIColor clearColor];
    
    
    if (indexPath.section == 0){
        cell = [self.roomTableView dequeueReusableCellWithIdentifier:@"popular_event_cell"];
        //cell.textLabel.text = [_popular objectAtIndex:indexPath.row];
        if(cell==nil){
                // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PopularTableCellView" owner:self options:nil];
                // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            
        }
    }
    
    if (indexPath.section == 1){
        cell = [self.roomTableView dequeueReusableCellWithIdentifier:@"around_me_cell"];
        
        //cell.textLabel.text = [_around_me objectAtIndex:indexPath.row];
        if(cell==nil){
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AroundMeTableCellView" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        NSDictionary *json_for_cell = [_rooms_around_me objectAtIndex:indexPath.row];
        cell.distance.text = [NSString stringWithFormat:@"%@",[json_for_cell objectForKey:@"distance"] ];
        NSString *user = [json_for_cell objectForKey:@"user"];
        NSLog(@"user: %@", user );
        cell.owner.text = user;
        cell.title.text = [json_for_cell objectForKey:@"title"];
        cell.listener_count = [[json_for_cell objectForKey:@"number_of_users"] integerValue];
        cell.owner_and_others_label.text = [NSString stringWithFormat:@"%@ and %d others",user,(int)cell.listener_count];
        
        
    }
    
    tableView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Popular right now";
    
        
    if (section == 1)
        return @"Around Me";
    return @"undefined";
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
