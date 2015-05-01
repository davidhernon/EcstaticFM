//
//  LoginViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-16.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "LoginViewController.h"
#import "SCUI.h"
#import "SoundCloudAPI.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) soundCloudLogin:(id) sender
{
    [self getAccessToken];
//    SCLoginViewControllerCompletionHandler handler = ^(NSError *error) {
//        if (SC_CANCELED(error)) {
//            NSLog(@"Canceled!");
//        } else if (error) {
//            NSLog(@"Error: %@", [error localizedDescription]);
//        } else {
//            NSLog(@"Done!");
//        }
//    };
//    
//    // if access token is available
//        // use it to login
//    // else
//        // login using soundcloud details
//    
//    NSString *userAccessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"SC_ACCESS_TOKEN"];
//    NSLog(@"user token: %@",userAccessToken);
//    
//    if(userAccessToken != nil){
//        
//        return;
//    }
//    
//    
//    //Query soundCloud API to log user in
//    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
//        SCLoginViewController *loginViewController;
//        
//        loginViewController = [SCLoginViewController
//                               loginViewControllerWithPreparedURL:preparedURL
//                               completionHandler:handler];
//        [self presentModalViewController:loginViewController animated:YES];
//    }];
    
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
                NSLog(@"Got the token: %@", accessToken);
//                [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:SC_ACCESS_TOKEN_KEY];
//                NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:accessToken,SC_ACCESS_TOKEN_KEY,nil];
//                completion(dict);
                NSObject *account = [SCSoundCloud account];
                NSLog(@"did it work?");
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
    [parameter setObject:@"david.hernon1@gmail.com" forKey:@"username"];
    [parameter setObject:@"Fourfive45Soundcloud" forKey:@"password"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
