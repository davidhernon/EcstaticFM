//
//  LoginViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-16.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "LoginViewController.h"
#import "EcstaticFM-Swift.h"

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
    
    // Add the gradient to the view
    [self.view.layer insertSublayer:[GFXUtils getGradient:self.view.bounds] atIndex:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    NSString *cached_user = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if(cached_user)
    {
        _username.text = cached_user;
        _password.text = [SSKeychain passwordForService:@"EcstaticFM" account:_username.text];
    }
    
    
    
}

//Dismisses keyboard
-(void)dismissKeyboard {
    [_username resignFirstResponder];
    [_password resignFirstResponder];
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

//This method gets called when SDSAPI's login method returns with a true if the login was succesful
- (void) loginReturnedTrue
{
//		[self performSegueWithIdentifier:@"succesfulLogin" sender:self];
		UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		PlayerPageViewController *player_page = [sb instantiateViewControllerWithIdentifier:@"pp"];
		[self presentViewController:player_page animated:YES completion:nil];
}

- (void) loginReturnedFalse
{
	NSLog(@"unsuccessful login");
}

- (IBAction)SDSLogin:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.username.text forKey:@"username"];
    [SSKeychain setPassword:_password.text forService:@"EcstaticFM" account:self.username.text];
	[SDSAPI login: self.username.text password:self.password.text ID:self];
    [SDSAPI createRoom: self.username.text];
}

- (IBAction)fbLogin:(id)sender {
    [SDSAPI fbLogin];
}
@end
