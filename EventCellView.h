//
//  EventCellView.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-18.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCellView : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
