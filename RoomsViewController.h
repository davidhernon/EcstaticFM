//
//  RoomsViewController.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-06.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"
#import "GFXUtils.h"
#import "RadialGradientLayer.h"
#import "SDSAPI.h"
#import "LocationServices.h"
@interface RoomsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *roomTableView;
@property NSArray* popular;
@property NSArray* around_me;
@property LocationServices* locationServices;
@end
