//
//  SoundCloudAPI.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "SoundCloudAPI.h"
#import "soundCloudMediaPickerViewController.h"
#import "EventView.h"


@implementation SoundCloudAPI

+(NSString*)getClientID
{
    return @"230ccb26b40f7c87eb65fc03357ffa81";
}


+(void) getFavorites:(soundCloudMediaPickerViewController*)sender
{
    sender.soundCloudAlbumImages = [[NSMutableArray alloc] init];
    sender.tracksFromSoundCloud = [[NSArray alloc] init];
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
            [sender getAlbumImageArray];
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
    sender.soundCloudAlbumImages = [[NSMutableArray alloc] init];
    sender.tracksFromSoundCloud = [[NSArray alloc] init];
    [sender getAlbumImageArray];
    [sender.soundCloudResultsTableView reloadData];
    
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

+(void)getSDSPlaylistsFromSoundCloud:(soundCloudMediaPickerViewController*)sender
{
    sender.soundCloudAlbumImages = [[NSMutableArray alloc] init];
    sender.tracksFromSoundCloud = [[NSArray alloc] init];
    [sender getAlbumImageArray];
    [sender.soundCloudResultsTableView reloadData];
    
    
    [SCRequest performMethod:SCRequestMethodGET onResource:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.soundcloud.com/users/silentdiscosquad/tracks"]] usingParameters:nil withAccount:[SCSoundCloud account] sendingProgressHandler:nil responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
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
//  pi.soundcloud.com/users/silentdiscosquad/tracks.json?client_id=230ccb26b40f7c87eb65fc03357ffa81
}

+(void)getSoundCloudTrackFromURL:(NSString*)string_url fromSender:(EventView*)sender
{
    //api.soundcloud.com/resolve.json?url=https://soundcloud.com/daveisrising/sets/mumt-303-assignment-one&client_id=230ccb26b40f7c87eb65fc03357ffa81
//    HTTP GET: https//api.soundcloud.com/resolve.json?url=URL&client_id=CLIENTID
    __block BOOL finished = NO;
//    string_url = [string_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *request = [NSString stringWithFormat:@"https://api.soundcloud.com/resolve.json?url=%@&client_id=%@",string_url,[self getClientID]];
    NSLog(@"FOR REQUEST !!!!! %@",request);
    
    
    [SCRequest performMethod:SCRequestMethodGET onResource:[NSURL URLWithString:request] usingParameters:nil withAccount:[SCSoundCloud account] sendingProgressHandler:nil responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if(error){
            NSLog(@"error: %@",error.localizedDescription);
        }
        
        NSError *jsonError;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if(!jsonError){
            sender.sc_event_song = jsonResponse;
            NSString *album_location = [jsonResponse objectForKey:@"artwork_url"];
            NSString *download_url = [jsonResponse objectForKey:@"download_url"];
            if(album_location)
                [sender setAlbumImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:album_location]]]];
            [sender setDownloadURL:download_url];
            [sender setEventDict:jsonResponse];
        }else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

+(void)getSoundCloudTrackFromURL:(NSNumber*)sc_id fromMediaItem:(MediaItem*)sender
{
    NSString *request = [NSString stringWithFormat:@"https://api.soundcloud.com/tracks/%@?client_id=%@",sc_id,[self getClientID]];
    NSLog(@"FOR REQUEST !!!!! %@",request);
    
    
    [SCRequest performMethod:SCRequestMethodGET onResource:[NSURL URLWithString:request] usingParameters:nil withAccount:[SCSoundCloud account] sendingProgressHandler:nil responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if(error){
            NSLog(@"error: %@",error.localizedDescription);
        }
        
        NSError *jsonError;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if(!jsonError){
            sender.sc_event_song = jsonResponse;
            sender.size = [jsonResponse objectForKey:@"original_content_size"];
        }else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}



//+(void)getSoundCloudTrackFromURL:(NSString*)string_url withMediaItemd:(MediaItem*)sender
//{
//    
//    NSString *request = [NSString stringWithFormat:@"https://api.soundcloud.com/resolve.json?url=%@&client_id=%@",string_url,[self getClientID]];
//    NSLog(@"FOR REQUEST !!!!! %@",request);
//    
//    
//    [SCRequest performMethod:SCRequestMethodGET onResource:[NSURL URLWithString:request] usingParameters:nil withAccount:[SCSoundCloud account] sendingProgressHandler:nil responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        
//        if(error){
//            NSLog(@"error: %@",error.localizedDescription);
//        }
//        
//        NSError *jsonError;
//        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//        
//        if(!jsonError){
//            sender.sc_event_song = jsonResponse;
//        }else{
//            NSLog(@"%@", error.localizedDescription);
//        }
//    }];
//}

//+(void)getSoundCloudTracKImageFromURL:(MediaItem*)track
//{
//    
//}

@end
