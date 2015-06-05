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
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
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
    
    
    NSString *cached_user = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if(cached_user)
    {
        _username.text = cached_user;
        _password.text = [SSKeychain passwordForService:@"EcstaticFM" account:_username.text];
    }
    
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



- (IBAction)SDSLogin:(id)sender {
    _loginLoading.hidden = NO;
    

    
    [[NSUserDefaults standardUserDefaults] setObject:self.username.text forKey:@"username"];
    [SSKeychain setPassword:_password.text forService:@"EcstaticFM" account:self.username.text];
	[SDSAPI login: self.username.text password:self.password.text ID:self];
}

//This method gets called when SDSAPI's login method returns with a true if the login was succesful
- (void) loginReturnedTrue
{
    //		[self performSegueWithIdentifier:@"succesfulLogin" sender:self];
    [SDSAPI createRoom: self.username.text];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerPageViewController *player_page = [sb instantiateViewControllerWithIdentifier:@"pp"];
    [self presentViewController:player_page animated:YES completion:nil];
}

- (void) loginReturnedFalse
{
    NSLog(@"returned here");
	self.loginLabel.text = @"Incorrect username or password.";
}

- (IBAction)fbLogin:(id)sender {
    [SDSAPI fbLogin];
}
@end
