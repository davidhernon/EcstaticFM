//
//  SoundCloudSearchView.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-06-07.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILTranslucentView.h"
@class soundCloudMediaPickerViewController;

@interface SoundCloudSearchView : ILTranslucentView

@property (weak, nonatomic) soundCloudMediaPickerViewController *delegate;
@property (weak, nonatomic) IBOutlet UITextField *text_field;
@property (weak, nonatomic) IBOutlet UIButton *search_button;

@end
