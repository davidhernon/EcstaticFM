//
//  LoginViewController.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-16.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SCUI.h"
#import "SoundCloudAPI.h"
#import "GFXUtils.h"
#import "RadialGradientLayer.h"
#import "SDSAPI.h"
#import "SSKeychain.h"

@interface LoginViewController : UIViewController

-(void)getAccessToken;
- (void) loginReturnedFalse;
- (void) loginReturnedTrue;

@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property BOOL keyboardIsShown;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *loginLoading;



@end
