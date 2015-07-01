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

-(void)createDummyRooms
{
    _popular = @[[[Room alloc] init]];
    
}

static NSString* popular_event_cell = @"popular_event_cell";
static NSString* around_me_event_cell = @"around_me_cell";


- (void)viewDidLoad {
    
    //set up some vars
    _scroll_view_margin_padding = 42;
    _event_view_height = 234;
    _event_view_width = 234;
    _event_view_padding = 15;
    
    [super viewDidLoad];
    _distance_or_time_label.text = @"Here";
    _location_icon.hidden = YES;
    _time_icon.hidden = YES;
    
    // Add the gradient to the view
    [self.view.layer insertSublayer:[GFXUtils getGradientPlayer:self.view.bounds] atIndex:0];
    
   // self.hostname. = [event objectForKey:@"host_username"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _center_points = [[NSMutableArray alloc] init];
    _event_item_list = [[NSMutableArray alloc] init];
    
    if(_upcoming_events == nil)
    {
		//Query the Django SDS server and get upcoming events
		__block NSArray *eventD;
		__block BOOL returned;
		NSURLSession *defaultSession = [NSURLSession sharedSession];
		
		NSURL * url = [NSURL URLWithString:@"http://54.173.157.204/appindex/"];
		NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
													   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
														   eventD = [NSJSONSerialization JSONObjectWithData:data
																									options:kNilOptions
																									  error:&error];
														   for(NSDictionary *item in eventD) {
															   NSLog (@"nsdic = %@", item);
														   }
														   returned = TRUE;
													   }];
		[dataTask resume];
		returned = FALSE;
		while(returned == FALSE){
			[NSThread sleepForTimeInterval:0.1f];
		}
        _upcoming_events = eventD;
    }
    
    // if _rooms_around_me is nil then we need to laod the username and go get them
    if(_rooms_around_me == nil)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* username = [defaults objectForKey:@"username"];
        [SDSAPI aroundMe:username withID:self];
    }
    
    float current_scroll_view_offset = _scroll_view_margin_padding;
    // get the upcoming events and populate them on screen
    for(NSDictionary *event in _upcoming_events)
    {
        if(event == [NSNull null]){
            continue;
        }
        
        [_center_points addObject:[NSNumber numberWithFloat:current_scroll_view_offset]];
        EventView *room_view = [[EventView alloc] initWithFrame:CGRectMake(current_scroll_view_offset, 0, _event_view_width, _event_view_height) withEvent:event withRoomController:self];
        [_event_item_list addObject:room_view];
        [_roomsScrollView addSubview:room_view];
        current_scroll_view_offset += (_event_view_width) + _event_view_padding;
        NSString *soundcloudLink = [event objectForKey:@"soundcloudLink"];
        NSLog(@"%@",soundcloudLink);
    }
    
    
    [_center_points addObject:[NSNumber numberWithFloat:current_scroll_view_offset]];
    CreateRoomView *room_view = [[CreateRoomView alloc] initWithFrame:CGRectMake(current_scroll_view_offset, 0, _event_view_width, _event_view_height) withEvent:nil withRoomController:self];
    [_event_item_list addObject:room_view];
    [_roomsScrollView addSubview:room_view];
    current_scroll_view_offset += (_event_view_width) + _event_view_padding;
    
    // Set the offset to start on the Your ROOM screen
    _center_point = CGPointMake(current_scroll_view_offset-_event_view_width-(4*_event_view_padding),0);
    

    // get the rooms around me and populate them in their cells
    for( NSDictionary *room in _rooms_around_me)
    {
        
        if(room == [NSNull null]){
            continue;
        }
        
		NSDictionary *room_info = (NSDictionary*)[room objectForKey:@"room_info"];
        
		if(room_info == [NSNull null] || [((NSDictionary*)room_info) count]==0 || [room_info objectForKey:@"room_number"] < 0){
			continue;
		}
        [_center_points addObject:[NSNumber numberWithFloat:current_scroll_view_offset]];
        UIAroundMeView *room_view = [[UIAroundMeView alloc] initWithFrame:CGRectMake(current_scroll_view_offset, 0, _event_view_width, _event_view_height) withEvent:room withRoomController:self];
        [_event_item_list addObject:room_view];
        [_roomsScrollView addSubview:room_view];
        current_scroll_view_offset += (_event_view_width) + _event_view_padding;
    }

    //plus 42 to anticipate margins on either end so we can center it properly
    current_scroll_view_offset += _scroll_view_margin_padding;
    [_roomsScrollView setContentOffset:_center_point animated:NO];
    _roomsScrollView.contentSize = CGSizeMake(current_scroll_view_offset, _roomsScrollView.frame.size.height);
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
    //Some maths about how to scroll and lock onto the proper event cell
    CGFloat kMaxIndex = 23;
    CGFloat targetX = scrollView.contentOffset.x + velocity.x * 60.0;
    CGFloat targetIndex = round(targetX / (_event_view_width + _event_view_padding));
    if (targetIndex < 0)
        targetIndex = 0;
    if (targetIndex > kMaxIndex)
        targetIndex = kMaxIndex;
    targetContentOffset->x = targetIndex * (_event_view_width + _event_view_padding);
    
    //
    [self setRoomsViewUIToMatchRoom:targetX];
    
    //Depending on where the target of the swipe is we can set our labels to show or hided
    if(_center_point.x - (_event_view_width/2) <= targetX && targetX <= _center_point.x+(_event_view_width/2)){
        _location_icon.hidden = NO;
        _time_icon.hidden = YES;
    }else if(targetX <= _center_point.x)
    {
        _location_icon.hidden = YES;
        _time_icon.hidden = NO;
    }else
    {
        _location_icon.hidden = NO;
        _time_icon.hidden = YES;
    }
}


//Display the Title or Distance UI for the whole controller depending on which page the user is currently looking at
-(void)setRoomsViewUIToMatchRoom:(float)position
{
    int counter = 0;
    for(NSNumber *position_from_array in _center_points)
    {
        //if you hit any page in the array
        if((position >= [[_center_points objectAtIndex:counter] floatValue] - (_event_view_width/2.0f)-_event_view_padding/2.0f) && (position <= [[_center_points objectAtIndex:counter] floatValue] + (_event_view_width/2.0f)+_event_view_padding/2.0f) )
        {
            
            //Figure out which class our room is and do label accordingly
            if([[_event_item_list objectAtIndex:counter] isKindOfClass:[EventView class]]){
                EventView *room = [_event_item_list objectAtIndex:counter];
                _room_header.text = [room.event_dictionary objectForKey:@"city"];
            }else if([[_event_item_list objectAtIndex:counter] isKindOfClass:[UIAroundMeView class]]){
                UIAroundMeView *room = [_event_item_list objectAtIndex:counter];
            }else{
                //WE are on the create room
                _room_header.text = @"Create Room";
                _distance_or_time_label.text = @"Here";
            }
            
            
//            UIRoomView* room = (UIRoomView*)[_event_item_list objectAtIndex:counter];
//            NSString* label_string = room.room_number_label.text;
//            
//            _distance_or_time_label.text = room.distance_or_time_for_event;
//            
//            //if the label is nil that means we assigned it from the create room view
//            //we should set the text to "create room"
//            if(_room_header.text == nil){
//                _room_header.text = @"Create Room";
//                _distance_or_time_label.text = @"Here";
//            }
        }
        
        //if the position you swiped to is below the beginning of the array
        else if( (position < [[_center_points objectAtIndex:0] floatValue] - (_event_view_width/2.0f)-_event_view_padding/2.0f))
        {
            _room_header.text = ((UIRoomView*)[_event_item_list objectAtIndex:0]).room_number_label.text;
        }
        //if the position you swiped to is beyond the end of the array
        else if((position > [[_center_points objectAtIndex:[_center_points count]-1] floatValue] + (_event_view_width/2.0f)+_event_view_padding/2.0f))
        {
            _room_header.text = ((UIRoomView*)[_event_item_list objectAtIndex:[_event_item_list count]-1]).room_number_label.text;
        }
        counter++;
    }
}

@end
