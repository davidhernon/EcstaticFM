//
//  UIEventView.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-30.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "EventView.h"
#import "RoomsViewController.h"

@implementation EventView

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
            _event_dictionary = event;
            NSString *sc_url = [event objectForKey:@"soundcloudLink"];
            if(sc_url)
                [SoundCloudAPI getSoundCloudTrackFromURL:sc_url fromSender:self];
            
            
            NSString *className = NSStringFromClass([self class]);
            self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
            [self addSubview:self.view];
            _rooms_view_controller = sender;
            NSString *city_title =[event objectForKey:@"city"];
            _title.text = city_title;
            _location.text = [event objectForKey:@"location"];
            NSNumber *start_time = [event objectForKey:@"start"];
            NSNumber *time_now = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
            double diff = abs([start_time doubleValue] - [time_now doubleValue]);
            NSString *time = [Utils convertSecondsToCountdownString:diff];
            self.distance_or_time_for_event = time;
            self.room_number_label.text = [event objectForKey:@"id"];
            _room_number = [NSString stringWithFormat:@"%@",[event objectForKey:@"id"]];
            
            
            _sc_event_song = nil;
            
			
			self.hostname = [event objectForKey:@"host_username"];
        }
        return self;
}

-(void)setAlbumImage:(UIImage*)artwork
{
    MWLogDebug(@"Rooms - EventView - setAlbumImage - setting album image for room: %@", self.title.text);

    _album_image_for_event.image = artwork;
}

-(IBAction)buttonAction
{
//    NSString *sc_url = [_event_dictionary objectForKey:@"soundcloudLink"];
//    [SoundCloudAPI getSoundCloudTrackFromURL:sc_url withSender:self];
//    
    //wait while we get the sc track, wait a max time of 10 seconds
    int counter = 0;
    while(!_sc_event_song && counter < 10)
    {
        MWLogDebug(@"Rooms - EventView - buttonAction - sleeping until we have an event song");

        // SEt spinner while we get the SC track
        [NSThread sleepForTimeInterval:0.01f];
        counter ++;
    }
    
    
    
    NSString *negative_room_number = [NSString stringWithFormat:@"%i",[self.room_number intValue] * (-1)];
    
    //if no event track
    if(!_sc_event_song)
    {
        MWLogDebug(@"Rooms - EventView - buttonAction - no event song so we join Room with Track = nil");
        
        [SDSAPI joinRoom:negative_room_number withUser:[self.event_dictionary objectForKey:@"host_username"] isEvent:true withTrack:nil]; //WIthTrackForRoomParsedFromEvent];
        //else there is an event track
    }else{
        MWLogDebug(@"Rooms - EventView - buttonAction - event song exists so joinRoom with Track");
        
        MediaItem *event_track = [[MediaItem alloc] initWithSoundCloudTrack:_sc_event_song];
        event_track.is_event_mix = YES;
        NSString *host_username = [self.event_dictionary objectForKey:@"host_username"];
        [SDSAPI joinRoom:negative_room_number withUser:host_username isEvent:true withTrack:event_track];
    }
    
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
