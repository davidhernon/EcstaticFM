//
//  AroundMeTableViewCell.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-11.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "AroundMeTableViewCell.h"

@implementation AroundMeTableViewCell

-(id)init
{
    self = [super init];
    if(self)
    {
        
        _distance.text = @"0";
        _owner_and_others_label = [[UILabel alloc] init];
        _owner = [[UILabel alloc] init];
        _title = [[UILabel alloc] init];
        _listener_count = 0;;
    }
    return self;
}

@end
