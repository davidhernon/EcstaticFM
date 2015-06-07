//
//  HomeTableViewController.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-18.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventViewController.h"
#import "AppDelegate.h"
#import "EventCellView.h"
#import "Utils.h"

@interface HomeTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
    EventViewController *dest;
}
@property (nonatomic, retain) NSArray *eventDict;
@end
