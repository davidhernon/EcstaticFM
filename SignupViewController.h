//
//  SignupViewController.h
//  
//
//  Created by Martin Weiss 1 on 2015-06-01.
//
//

#import <UIKit/UIKit.h>
#import "SDSAPI.h"

@interface SignupViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)signup:(id)sender;
-(void)signupSuccess;
-(void)signupFailure:(NSString*)error;

@end
