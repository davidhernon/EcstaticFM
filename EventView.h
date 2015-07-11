//
//  UIEventView.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-30.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerPageViewController.h"
#import "SDSAPI.h"
#import "UIRoomView.h"
#import <MapKit/MapKit.h>
@class RoomsViewController;

@interface EventView : UIRoomView

@property (strong, nonatomic) IBOutlet UIImageView *album_image_for_event;

@property (nonatomic, retain) IBOutlet UIView *view;
@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *location;
@property (nonatomic, retain) IBOutlet UILabel *hostname;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UILabel *room_number_label;
@property (nonatomic, retain) NSString *room_number;
@property (nonatomic, retain) NSDictionary *event_dictionary;
@property (nonatomic, retain) NSDictionary *sc_event_song;
@property (nonatomic, retain) NSString *download_url;

//@property (nonatomic, retain) NSString *distance_or_time_for_event;

@property (nonatomic, weak) RoomsViewController *rooms_view_controller;

- (id) initWithFrame:(CGRect)aRect withEvent:(NSDictionary*)event withRoomController:(RoomsViewController*)sender;
-(void)setAlbumImage:(UIImage*)artwork;
-(void)setDownloadURL:(NSString*)downloadurl;
-(void)setEventDict:(NSDictionary*)trackDict;


@end
