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
    
    
   // return (NSArray*)favorites;
    
}

+(NSArray*) searchSC
{
    __block NSArray* favorites;
    __block BOOL returned = FALSE;
    [SCRequest performMethod:SCRequestMethodGET onResource:[NSURL URLWithString:@"https://api.soundcloud.com/me/favorites.json"] usingParameters:nil withAccount:[SCSoundCloud account] sendingProgressHandler:nil responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSError *jsonError;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            //sender.tracksFromSoundCloud = (NSArray *)jsonResponse;
            returned = TRUE;
            NSLog(@"Returned Favorites!");
            favorites = (NSArray *)jsonResponse;
        }
        
        else {
            
            NSLog(@"%@", error.localizedDescription);
            
        }
        
    }];
    

    while(returned == FALSE){
        [NSThread sleepForTimeInterval:0.1f];
    }
    
    return favorites;
}


@end
