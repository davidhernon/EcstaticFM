//
//  SoundCloudAPI.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicServiceAPI.h"
#import "MediaPickerTableViewController.h"
#import <UIKit/UIKit.h>
#import "SCUI.h"
#import "soundCloudMediaPickerViewController.h"

@interface SoundCloudAPI : NSObject<MusicServiceAPI>


//+(NSArray*)searchSC;
+(void)getFavorites:(soundCloudMediaPickerViewController*)sender;
+ (void)getAccessTokenWithCompletion;
+ (void)storeUserDefaults;

@end
