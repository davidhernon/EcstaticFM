//
//  MediaItemTableViewCell.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-03-17.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *trackTitle;

@property (weak, nonatomic) IBOutlet UILabel *artist;

@property (weak, nonatomic) IBOutlet UILabel *max_length;

@end
