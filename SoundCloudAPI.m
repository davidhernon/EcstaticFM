//
//  SoundCloudAPI.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "SoundCloudAPI.h"


@implementation SoundCloudAPI


+(void) getFavorites:(soundCloudMediaPickerViewController*)sender
{
    SCAccount *account = [SCSoundCloud account];
    if (account == nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Not Logged In"
                              message:@"You must login first"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
       // return [[NSArray alloc]init];
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
        }else{
            NSLog(@"did not succeed in SC query");
        }
    };
    
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

@end
