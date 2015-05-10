//
//  ChatViewController.h
//  EcstaticFM
//
//  Created by Kizma on 2015-05-08.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GFXUtils.h"
#import "RadialGradientLayer.h"


@interface ChatViewController : UIViewController


// @property (nonatomic, strong)UITapGestureRecognizer *chatTapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIScrollView *chatScrollView;
@property (weak, nonatomic) IBOutlet UITextField *chatTextField;
@property BOOL keyboardIsShown;

- (void)didReceiveMemoryWarning;
- (void)keyboardWillHide:(NSNotification *)n;

@end
