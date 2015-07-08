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
    _username.delegate = self;
    _password.delegate = self;
    _email.delegate = self;
	self.wantsPushNotifications = false;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
	
	_keyboardIsShown = NO;
	//make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
	CGSize scrollContentSize = CGSizeMake(320, 490);
	_signupScrollView.contentSize = scrollContentSize;
    
    _signupLoading.hidden = YES;
    
    // Load images
    NSArray *imageNames = @[@"loading1.png", @"loading2.png", @"loading3.png", @"loading4.png",
                            @"loading5.png", @"loading6.png"];
    
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    // Normal Animation
    // UIImageView *loginLoader = [[UIImageView alloc] initWithFrame:CGRectMake(60, 95, 86, 193)];
    _signupLoading.animationImages = images;
    _signupLoading.animationDuration = 0.5;
    
    
    //   [self.view addSubview:_loginLoading];
    [_signupLoading startAnimating];
}

- (IBAction)signup:(id)sender {
		static NSString *csrf_cookie;
		
		// in a function:
		NSURL *url = [[NSURL alloc] initWithString:@"http://54.173.157.204/"];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
		[request setHTTPShouldHandleCookies:YES];
		
		[request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url]]];
		
		// make GET request are store the csrf
		[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
							   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
								   NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[(NSHTTPURLResponse *)response allHeaderFields] forURL:url];
								   [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:url mainDocumentURL:nil];
								   // for some reason we need to re-store the CSRF token as X_CSRFTOKEN
								   for (NSHTTPCookie *cookie in cookies) {
									   if ([cookie.name isEqualToString:@"csrftoken"]) {
										   csrf_cookie = cookie.value;
										   NSLog(@"cookie.value=%@", cookie.value);
										   break;
									   }
								   }
								   NSString* urlString = @"http://54.173.157.204/auth/createprofileiOS/";
								   NSURL *url = [NSURL URLWithString:urlString];
								   
								   NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
								   [urlRequest setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url]]];
								   [urlRequest addValue:csrf_cookie forHTTPHeaderField:@"X_CSRFTOKEN"];
								   [urlRequest setHTTPMethod:@"POST"];
								   
								   AppDelegate* appDelegate = [[UIApplication sharedApplication]delegate];
								   
								   NSString* bodyData = [NSString stringWithFormat:@"username=%@&password=%@&email=%@&mixpanel_distinct_id=%@", self.username, self.password, self.email, appDelegate.mixpanel.distinctId];
								   [urlRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
								   NSOperationQueue *queue = [[NSOperationQueue alloc] init];
								   
								   [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
									{
										NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
										
										if ([responseString  isEqual: @"True"]) {
											[self performSelectorOnMainThread:@selector(signupSuccess) withObject:nil waitUntilDone:NO];
										}
										else{
											[self performSelectorOnMainThread:@selector(signupFailure:) withObject:responseString waitUntilDone:NO];
										}
									}];
							   }];

	if(self.wantsPushNotifications){
		[self requestPushPermissions];
	}
}

-(void)requestPushPermissions{
	Mixpanel *mixpanel = [Mixpanel sharedInstance];
	
	// Tell iOS you want your app to receive push notifications
	// This code will work in iOS 8.0 xcode 6.0 or later:
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
	{
		[[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
		[[UIApplication sharedApplication] registerForRemoteNotifications];
	}
	// This code will work in iOS 7.0 and below:
	else
	{
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	}
	
	// Call .identify to flush the People record to Mixpanel
	[mixpanel identify:mixpanel.distinctId];
}

-(void)signupSuccess{
	[[NSUserDefaults standardUserDefaults] setObject:self.username.text forKey:@"username"];
	[SSKeychain setPassword:_password.text forService:@"EcstaticFM" account:self.username.text];
	[self performSegueWithIdentifier:@"successfulSignup" sender:self];
//	AppDelegate* appDelegate = [[UIApplication  sharedApplication]delegate];
//	UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//	geoAskViewController *geoAskVC = [sb instantiateViewControllerWithIdentifier:@"geoAskVC"];
//	appDelegate.locationServices.vc=geoAskVC;
//	[self presentViewController:geoAskVC animated:YES completion:nil];
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
    [_email resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)n
{
//	NSDictionary* userInfo = [n userInfo];
//	
//	// get the size of the keyboard
//	CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//	
//	
//	// resize the scrollview
//	CGRect viewFrame = _signupScrollView.frame;
//	// I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
//	viewFrame.size.height += (keyboardSize.height + kTabBarHeight);
//	
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationBeginsFromCurrentState:YES];
//	[_signupScrollView setFrame:viewFrame];
//	[UIView commitAnimations];
//	
//	_keyboardIsShown = NO;
    
}

- (void)keyboardWillShow:(NSNotification *)n
{
    [self.view setFrame:CGRectMake(0,-110,320,460)];
	// This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
//	if (_keyboardIsShown) {
//		return;
//	}
	
//	NSDictionary* userInfo = [n userInfo];
//	
//	// get the size of the keyboard
//	CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//	
//	// resize the noteView
//	CGRect viewFrame = _signupScrollView.frame;
//	// I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
//	viewFrame.size.height -= (keyboardSize.height + kTabBarHeight);
//	
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationBeginsFromCurrentState:YES];
//	[_signupScrollView setFrame:viewFrame];
//	[UIView commitAnimations];
//	_keyboardIsShown = YES;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
}


- (IBAction)pushNotificationSwitch:(id)sender {
	if(self.wantsPushNotifications){
		self.wantsPushNotifications = false;
	}
	else{
		self.wantsPushNotifications = true;
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _username) {
        [textField resignFirstResponder];
        return NO;
    }
    if(textField == _email){
        [textField resignFirstResponder];
        return NO;
    }
    if(textField == _password){
        [textField resignFirstResponder];
        [self signup:self];
        return NO;
    }
    return YES;
}
@end
