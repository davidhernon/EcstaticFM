//
//  SoundCloudAPI.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "SoundCloudAPI.h"


@implementation SoundCloudAPI

+(NSArray*) getFavorites
{
    __block BOOL returned = FALSE;
    __block NSArray* favorites;
    SCAccount *account = [SCSoundCloud account];
    if (account == nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Not Logged In"
                              message:@"You must login first"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return [[NSArray alloc]init];
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
            returned = TRUE;
            favorites = (NSArray *)jsonResponse;
        }
    };
    
    NSString *resourceURL = @"https://api.soundcloud.com/me/favorites.json";
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
    
    while(returned == FALSE){
        [NSThread sleepForTimeInterval:0.1f];
    }
    
    return (NSArray*)favorites;
    
}

@end
