//
//  ForgotPasswordViewController.h
//  EcstaticFM
//
//  Created by Martin Weiss 1 on 2015-06-18.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *email;
- (IBAction)submit:(id)sender;

@end
