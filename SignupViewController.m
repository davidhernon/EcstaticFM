//
//  SignupViewController.m
//  
//
//  Created by Martin Weiss 1 on 2015-06-01.
//
//

#import "SignupViewController.h"
#define kTabBarHeight 100.0

@implementation SignupViewController

-(void)viewDidLoad{
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
																		  action:@selector(dismissKeyboard)];
	
	[self.view addGestureRecognizer:tap];
	
	// register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:self.view.window];
	// register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:self.view.window];
	
	_keyboardIsShown = NO;
	//make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
	CGSize scrollContentSize = CGSizeMake(320, 490);
	_signupScrollView.contentSize = scrollContentSize;
}

- (IBAction)signup:(id)sender {
	[SDSAPI signup:self.username.text password:self.password.text email:self.email.text ID:self];
}

-(void)signupSuccess{
	AppDelegate* appDelegate = [[UIApplication  sharedApplication]delegate];
	UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	geoAskViewController *geoAskVC = [sb instantiateViewControllerWithIdentifier:@"geoAskVC"];
	appDelegate.locationServices.vc=geoAskVC;
	[self presentViewController:geoAskVC animated:YES completion:nil];
}

-(void)signupFailure:(NSString*)error{
	NSLog(@"Signup failure error = %@", error);
	if ([error containsString:@"<django.utils.functional.__proxy__ object"]) {
		self.signupLabel.text = @"All fields are required!";
	} else if ([error containsString:@"[u'Enter a valid email address.']"]) {
		self.signupLabel.text = @"Enter a valid email address!";
	}
	else if ([error containsString:@"[u'Email addresses must be unique.']"]){
		self.signupLabel.text = @"Email Addresses must be unique!";
	}
	else if ([error containsString:@"duplicate key value violates unique constraint"]){
		self.signupLabel.text = @"Usernames must be unique!";
	}
	else{
		self.signupLabel.text = @"Problem with signup!";
	}
}
//Dismisses keyboard
-(void)dismissKeyboard {
	[_username resignFirstResponder];
	[_password resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)n
{
	NSDictionary* userInfo = [n userInfo];
	
	// get the size of the keyboard
	CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	
	// resize the scrollview
	CGRect viewFrame = _signupScrollView.frame;
	// I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
	viewFrame.size.height += (keyboardSize.height + kTabBarHeight);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[_signupScrollView setFrame:viewFrame];
	[UIView commitAnimations];
	
	_keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
	// This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
	if (_keyboardIsShown) {
		return;
	}
	
	NSDictionary* userInfo = [n userInfo];
	
	// get the size of the keyboard
	CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	// resize the noteView
	CGRect viewFrame = _signupScrollView.frame;
	// I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
	viewFrame.size.height -= (keyboardSize.height + kTabBarHeight);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[_signupScrollView setFrame:viewFrame];
	[UIView commitAnimations];
	_keyboardIsShown = YES;
}




@end
