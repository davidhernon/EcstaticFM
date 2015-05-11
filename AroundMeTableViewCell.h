//
//  AroundMeTableViewCell.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-11.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AroundMeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UILabel *owner_and_others_label;
@property (strong, nonatomic) UILabel *owner;
@property (strong, nonatomic) UILabel *title;
@property int listener_count;

@end
