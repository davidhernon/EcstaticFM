//
//  SoundCloudSearchView.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-06-07.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "SoundCloudSearchView.h"
#import "soundCloudMediaPickerViewController.h"

@implementation SoundCloudSearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction) search :(id)sender
{
    [_delegate searchSoundcloud:_text_field.text];
    _delegate.soundCloudResultsTableView.hidden = NO;
    [_delegate.soundCloudResultsTableView reloadData];
    [self removeFromSuperview];
}



@end
