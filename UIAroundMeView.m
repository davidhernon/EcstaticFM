//
//  UIAroundMeView.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-30.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "UIAroundMeView.h"
#import "RoomsViewController.h"
#import "EcstaticFM-Swift.h"

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
    NSDictionary *host_location = [event objectForKey:@"host_location"];
    if([room_info count]==0){
        MWLogDebug(@"Ecstatic - UIAroundMeView - initWithFrame - room_info count returned from server was empty");
    }
    if((self = [super initWithFrame:aRect]))
    {

		NSString *className = NSStringFromClass([self class]);
        self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        self.other_listeners.text = [NSString stringWithFormat:@"%u", [users count] ];
        self.room_number_label.text = [NSString stringWithFormat:@"Room Number: %@", [room_info objectForKey:@"room_number"]];
        self.room_number = [room_info objectForKey:@"room_number"];
        self.rooms_view_controller = sender;
        NSString *room_n = [room_info objectForKey:@"room_name"];
        self.title = room_n;
        self.distance_or_time_for_event = [room_info objectForKey:@"distance"];
        
        NSNumber *host_lat = [host_location objectForKey:@"latitude"];
        NSNumber *host_lon = [host_location objectForKey:@"longitude"];
        
        if(host_lat == [NSNull null]){
            host_lat = [NSNumber numberWithDouble:45.5017];
            host_lon = [NSNumber numberWithDouble:-73.5673];
        }
        
        _coord.latitude = [host_lat doubleValue];
        _coord.longitude = [host_lon doubleValue];
        
        // Set _coord
        NSNumber *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
        NSNumber *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
        
        if(latitude == nil)
        {
            latitude = [NSNumber numberWithDouble:45.5017];
        }
        if(longitude == nil)
        {
            longitude = [NSNumber numberWithDouble:-73.5673];
        }
        
        CLLocationCoordinate2D coord2;
        coord2.latitude = (CLLocationDegrees)[latitude doubleValue];
        coord2.longitude = (CLLocationDegrees)[longitude doubleValue];
        
        MKMapPoint point1 = MKMapPointForCoordinate(_coord);
        MKMapPoint point2 = MKMapPointForCoordinate(coord2);
        CLLocationDistance distance = MKMetersBetweenMapPoints(point1, point2);
        
        NSLog(@"distance: %f", distance);
        
        self.distance_or_time_for_event = [NSString stringWithFormat:@"%i meters", (int)distance];
        _hostname = [room_info objectForKey:@"host_username"];
        
        [self addSubview:self.view];
    }
    return self;
}

-(void)setLocation:(NSDictionary*)location_dict_from_server
{
    MWLogDebug(@"Ecstatic - UIAroundMeView - setLocation - setting location for room: %@", self.title);
    
    NSNumber *lat = [location_dict_from_server objectForKey:@"latitude"];
    NSNumber *lon = [location_dict_from_server objectForKey:@"longitude"];
    _coord.latitude = [lat doubleValue];
    _coord.longitude = [lon doubleValue];
}

-(IBAction)joinRoomButton
{
    MWLogDebug(@"Ecstatic - UIAroundMeView - buttonAction - client clicked on the around me view button for: %@", self.title);

    
	//make sure that the room_number we have is actually a string
	if([self.room_number isKindOfClass:[NSNumber class]])
	{
		// clean the server data
		self.room_number = [(NSNumber*)self.room_number stringValue];
	}
    
	if([[Room currentRoom].room_number isKindOfClass:[NSNumber class]]){
		[Room currentRoom].room_number = [(NSNumber*)[Room currentRoom].room_number stringValue];
	}

	//if you're actually gonna join a new room, then call join_room to the server
	if(![[Room currentRoom].room_number isEqualToString: self.room_number]){
        MWLogDebug(@"Ecstatic - UIAroundMeView - buttonAction - joining new room: %@", self.room_number);
        [SDSAPI joinRoom:self.room_number withUser:_hostname isEvent:false withTrack:nil];
	}
	
	//if you're actually just returning to the room you're already in, then local transition
    MWLogDebug(@"Ecstatic - UIAroundMeView - buttonAction - rejoining the room we were already in");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerPageViewController *player_page = [sb instantiateViewControllerWithIdentifier:@"pp"];
    
    //initiate a crossfade transition on segue
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromBottom;
    
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    //send me to the player
    [_rooms_view_controller presentViewController:player_page animated:NO completion:nil];
    
}

@end
