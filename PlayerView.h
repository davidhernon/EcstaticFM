//
//  PlayerView.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-11.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "Utils.h"
#import "SCUI.h"

@interface PlayerView : UIView
{
    AVPlayer *player;
    AVAsset *avAsset;
    AVPlayerItem *playerItem;
}
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak,nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *soundCloudRequest;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
//@property (strong, atomic) AVPlayer *player;
// PLAYER STUFF TO REFACTOR:

-(void) initializeAudio;
-(void) stream:(NSString*)streamURL withNetworkLatency:(double)network;

@property double startprop;
//
-(void)updateSlider;
-(IBAction)soundCloudRequest:(id)sender;
@end
