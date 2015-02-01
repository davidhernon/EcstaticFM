//
//  MusicTableViewController.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-01.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@protocol PassInformation <NSObject>
-(void) setTrack:(MPMediaItem*)song;
@end

@interface MusicTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
    MPMediaItem *song;
}
@property (nonatomic, unsafe_unretained) id<PassInformation> delegate;
@end
