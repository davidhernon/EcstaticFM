//
//  LoginViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-16.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "LoginViewController.h"
#import "EcstaticFM-Swift.h"

#define kTabBarHeight 100.0

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
	_sent = false;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    NSString *cached_user = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if(cached_user)
    {
        _username.text = cached_user;
        _password.text = [SSKeychain passwordForService:@"EcstaticFM" account:_username.text];
        [SDSAPI login: self.username.text password:self.password.text ID:self];
    }
    _username.delegate = self;
    _password.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
   //     _originalCenter = _loginView.center;
    
    
    _loginLoading.hidden = YES;
    
    // Load images
    NSArray *imageNames = @[@"loading1.png", @"loading2.png", @"loading3.png", @"loading4.png",
                            @"loading5.png", @"loading6.png"];
    
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    // Normal Animation
   // UIImageView *loginLoader = [[UIImageView alloc] initWithFrame:CGRectMake(60, 95, 86, 193)];
    _loginLoading.animationImages = images;
    _loginLoading.animationDuration = 0.5;

    
 //   [self.view addSubview:_loginLoading];
    [_loginLoading startAnimating];

    
    
    // Add the gradient to the view
    [self.view.layer insertSublayer:[GFXUtils getGradient:self.view.bounds] atIndex:0];
    
    
//    // Tap gesture for keyboard dismiss
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                          action:@selector(dismissKeyboard)];
//    
//    [self.view addGestureRecognizer:tap];
    
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
    
    
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) soundCloudLogin:(id) sender
{
//    [self getAccessToken];
    SCLoginViewControllerCompletionHandler handler = ^(NSError *error) {
        if (SC_CANCELED(error)) {
            NSLog(@"Canceled!");
        } else if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            NSLog(@"Done!");
        }
    };
    
    // if access token is available
        // use it to login
    // else
        // login using soundcloud details
    
    NSString *userAccessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"SC_ACCESS_TOKEN"];
    NSLog(@"user token: %@",userAccessToken);
    
    if(userAccessToken != nil){
        
        return;
    }
    
    //Query soundCloud API to log user in
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
        SCLoginViewController *loginViewController;
        
        loginViewController = [SCLoginViewController
                               loginViewControllerWithPreparedURL:preparedURL
                               completionHandler:handler];
        [self presentModalViewController:loginViewController animated:YES];
    }];
    
}

- (void)getAccessToken
{
    NSString *BaseURI = @"https://api.soundcloud.com";
    NSString *OAuth2TokenURI = @"/oauth2/token";
    
    NSString *requestURL = [BaseURI stringByAppendingString:OAuth2TokenURI];
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        if (!jsonError)
        {
            NSLog(@"output of getToken\n%@",jsonResponse);
            NSDictionary* serverResponse = (NSDictionary*)jsonResponse;
            if ([serverResponse objectForKey:@"access_token"])
            {
                NSString *accessToken = [serverResponse objectForKey:@"access_token"];
                NSLog(@"Got the non-expiring token: %@", accessToken);
                [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"SC_ACCESS_TOKEN_KEY"];
//                NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:accessToken,SC_ACCESS_TOKEN_KEY,nil];
//                completion(dict);
            }
            else{
//                completion(nil);
            }
        }
    };
    
    NSMutableDictionary *parameter=[[NSMutableDictionary alloc]init];
    [parameter setObject:@"password" forKey:@"grant_type"];
    [parameter setObject:@"230ccb26b40f7c87eb65fc03357ffa81" forKey:@"client_id"];
    [parameter setObject:@"4a50ef64acc242ce02e9abc5e370c064" forKey:@"client_secret"];
    [parameter setObject:@"" forKey:@"username"];
    [parameter setObject:@"" forKey:@"password"];
    [parameter setObject:@"non-expiring" forKey:@"scope"];
    
    
    [SCRequest performMethod:SCRequestMethodPOST
                  onResource:[NSURL URLWithString:requestURL]
             usingParameters:parameter
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:handler];
}

- (void)signInWithAccessToken
{
    
    
    
}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // resize the scrollview
    CGRect viewFrame = _loginView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height + kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [_loginView setFrame:viewFrame];
    [UIView commitAnimations];
    
    _keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{

    _loginView.center = CGPointMake(1,1);
 
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
 //   if (_keyboardIsShown) {
 //       return;
//    }
    
 //   NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
 //   CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    
    //move view
    
//    CGPoint newCenter = CGPointMake(1.0,1.0);
    
//    [UIView animateWithDuration: 15
//                          delay: 0
//                        options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
//                     animations:^{_loginView.center = newCenter ;
//                                    //_loginView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
//                     }
//                     completion:^(BOOL finished) { }
//     ];
 

    
    
    
    // resize the noteView
  //  CGRect viewFrame = _loginView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
 //   viewFrame.size.height -= (keyboardSize.height + kTabBarHeight);
    
 //   [UIView beginAnimations:nil context:NULL];
  //  [UIView setAnimationBeginsFromCurrentState:YES];
  //  [_loginView setFrame:viewFrame];
  //  [UIView commitAnimations];
  //  _keyboardIsShown = YES;
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


- (IBAction)SDSLogin:(id)sender {
    _loginLoading.hidden = NO;
	[self requestPushPermissions];
	[SDSAPI login: self.username.text password:self.password.text ID:self];
}

//This method gets called when SDSAPI's login method returns with a true if the login was succesful
- (void) loginReturnedTrue
{
	Mixpanel *mixpanel = [Mixpanel sharedInstance];
	[mixpanel track:@"login"];

    [[NSUserDefaults standardUserDefaults] setObject:self.username.text forKey:@"username"];
    [SSKeychain setPassword:_password.text forService:@"EcstaticFM" account:self.username.text];
    
    [SDSAPI createRoom: self.username.text];
	AppDelegate* appDelegate = [[UIApplication  sharedApplication]delegate];
	//check if the user has given permissions to use location services
	if([appDelegate.locationServices checkForPermissions]){
		[self performSegueWithIdentifier:@"roomsSegue" sender:self];
	}
	//if they haven't ask them to in the geoAsk uiviewcontroller
	else{
		UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		geoAskViewController *geoAskVC = [sb instantiateViewControllerWithIdentifier:@"geoAskVC"];
        
        //initiate a crossfade transition on segue
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromBottom;
        
        [self.view.window.layer addAnimation:transition forKey:kCATransition];
        //send me to the geoask
		appDelegate.locationServices.vc=geoAskVC;
		[self presentViewController:geoAskVC animated:YES completion:nil];
	}
    NSNumber *lat = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSNumber *lon;
    if(lat)
    {
        lon = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    }else{
        lat = [NSNumber numberWithDouble:-45.5017];
        lon = [NSNumber numberWithDouble:-73.5637];
    }
    [SDSAPI postLocation:_username.text withLatitude:[lat floatValue] withLongitude:[lon floatValue]];
}

- (void) loginReturnedFalse
{
    _loginLoading.hidden=true;
    self.loginLabel.text = @"Incorrect username or password.";
}

- (void) loginTimedOut
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Timed Out"
                                                    message:@"Please Check Your Internet Connection and Try Again"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)fbLogin:(id)sender {
    [SDSAPI fbLogin];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _username) {
        [textField resignFirstResponder];
        return NO;
    }
    if(textField == _password){
        [textField resignFirstResponder];
        [self SDSLogin:self];
        return NO;
    }
    return YES;
}

- (IBAction)forgotPassword:(id)sender {
	_dialog = [[UIAlertView alloc] init];
	[_dialog setDelegate:self];
	[_dialog setTitle:@"Enter your Email"];
	[_dialog setMessage:@" "];
	[_dialog addButtonWithTitle:@"Cancel"];
	[_dialog addButtonWithTitle:@"Submit"];
	_dialog.tag = 5;
	_dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
	CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 0.0);
	[_dialog setTransform: moveUp];
	[_dialog show];
	
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(!_sent){
		NSLog(@"%ld", (long)buttonIndex);
		self.email = [_dialog textFieldAtIndex:0].text;
		[self submit:self];
		_sent = true;
	}
}

-(void) forgotPasswordReturnedTrue
{
	NSLog(@"true");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder Sent!"
													message:@"An email was sent to you with your password, please reset it and try again. Thanks!"
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles: nil];
	    [alert addButtonWithTitle:@"OK"];
	    [alert show];
}

- (void)submit:(id)sender {
	// at the top
	static NSString *csrf_cookie;
	
	// in a function:
	
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
							   
							   NSString* urlString = @"http://54.173.157.204/auth/forgotpassword.html/";
							   NSURL *url = [NSURL URLWithString:urlString];
							   
							   NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
							   [urlRequest setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url]]];
							   [urlRequest addValue:csrf_cookie forHTTPHeaderField:@"X_CSRFTOKEN"];
							   [urlRequest setHTTPMethod:@"POST"];
							   NSString* bodyData = [NSString stringWithFormat:@"email=%@", self.email];
							   [urlRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
							   NSOperationQueue *queue = [[NSOperationQueue alloc] init];
							   
							   [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
								{
									dispatch_async(dispatch_get_main_queue(),
												   ^{
													   [self performSelector:@selector(forgotPasswordReturnedTrue) withObject:nil withObject:NO];
												   });
									
								}];
						   }];
}

@end
