//
//  SignupViewController.h
//  
//
//  Created by Martin Weiss 1 on 2015-06-01.
//
//

#import <UIKit/UIKit.h>
#import "SDSAPI.h"
#import "SSKeychain.h"
#import "AppDelegate.h"
@interface SignupViewController : UIViewController
@property BOOL keyboardIsShown;
@property BOOL wantsPushNotifications;
@property (strong, nonatomic) IBOutlet UIScrollView *signupScrollView;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)pushNotificationSwitch:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *signupLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signupLoading;
- (IBAction)signup:(id)sender;
-(void)signupSuccess;
-(void)signupFailure:(NSString*)error;

@end
