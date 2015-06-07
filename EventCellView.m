//
//  EventCellView.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-18.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "EventCellView.h"

@implementation EventCellView
@synthesize titleLabel = _titleLabel;
@synthesize locationLabel = _locationLabel;
@synthesize dateLabel = _dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _titleLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:20];
        _locationLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:20];
        _dateLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:20];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
