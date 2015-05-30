//
//  SoundCloudAPI.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "SoundCloudAPI.h"
#import "soundCloudMediaPickerViewController.h"


@implementation SoundCloudAPI

+(NSString*)getClientID
{
    return @"230ccb26b40f7c87eb65fc03357ffa81";
}


+(void) getFavorites:(soundCloudMediaPickerViewController*)sender
{
    SCAccount *account = [SCSoundCloud account];
    if (account == nil) {
        NSLog(@"tried to get favorites when no user was signed into soundcloud");
        return;
    }
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        NSLog(@"We returned from SC");
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            NSLog(@"did succeed in SC query");
            [sender addSoundCloudFavorites:((NSArray*)jsonResponse)];
            // reload table data?
            [sender.soundCloudResultsTableView reloadData];
//            [sender viewDidLoad];
//            [sender viewWillAppear:YES];
            
        }else{
            NSLog(@"did not succeed in SC query");
        }
    };
    NSLog(@"starting request");
    NSString *resourceURL = @"https://api.soundcloud.com/me/favorites.json";
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
    
}

+ (void)getAccessTokenWithCompletion
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
                NSLog(@"received non expiron token");
                NSString *accessToken = [serverResponse objectForKey:@"access_token"];
                [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"SC_ACCESS_TOKEN"];
//                NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:accessToken,@"SC_ACCESS_TOKEN_KEY",nil];
             //what to do on complete
            }
            else{
              //what to do on complete
                NSLog(@"There was no token to be had");
            }
        }
    };
    
    //get non expiring key
    //DOESNT WORK
    NSMutableDictionary *parameter=[[NSMutableDictionary alloc]init];
    [parameter setObject:@"non-expiring" forKey:@"scope"];
    
    //Could be problematic as I have not tested parameters + SC account
    [SCRequest performMethod:SCRequestMethodPOST
                  onResource:[NSURL URLWithString:requestURL]
             usingParameters:nil
                 withAccount:[SCSoundCloud account]
      sendingProgressHandler:nil
             responseHandler:handler];
}

+(void)login:(id)sender
{
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
        [sender presentModalViewController:loginViewController animated:YES];
    }];
}

+(void)searchSoundCloud:(NSString*)search_text withSender:(soundCloudMediaPickerViewController*)sender
{
    //query SC with text
    
    //when we get the response reload soundCloudMediaPicker
    NSString *search = [search_text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [SCRequest performMethod:SCRequestMethodGET onResource:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.soundcloud.com/me/tracks?q=%@&format=json", search]] usingParameters:nil withAccount:[SCSoundCloud account] sendingProgressHandler:nil responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSError *jsonError;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            
            [sender addSoundCloudFavorites:((NSArray*)jsonResponse)];
            // reload table data?
            [sender.soundCloudResultsTableView reloadData];
            [sender getAlbumImageArray];
        }
        else {
            
            NSLog(@"%@", error.localizedDescription);
            
        }
    }];
}

@end
