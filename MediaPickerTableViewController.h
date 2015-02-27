//
//  MediaPickerTableViewController.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-25.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MediaPickerTableViewController : UITableViewController<AVAudioPlayerDelegate>
@property NSJSONSerialization* favorites;

@property (nonatomic, strong) NSArray *tracks;

@end
