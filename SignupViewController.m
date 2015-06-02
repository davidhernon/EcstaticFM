//
//  SignupViewController.m
//  
//
//  Created by Martin Weiss 1 on 2015-06-01.
//
//

#import "SignupViewController.h"

@implementation SignupViewController

- (IBAction)signup:(id)sender {
	[SDSAPI signup:self.username.text password:self.password.text email:self.email.text ID:self];
}

-(void)signupSuccess{
	NSLog(@"gets called if signup was succesful");
	[self performSegueWithIdentifier:@"successfulSignup" sender:self];
}
-(void)signupFailure:(NSString*)error{
	NSLog(@"Signup failure error = %@", error);
	NSLog(@"gets called if signup  failed");

}



@end
