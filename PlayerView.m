//
//  PlayerView.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-11.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

-(void)awakeFromNib {
    //Note That You Must Change @”BNYSharedView’ With Whatever Your Nib Is Named
    [[NSBundle mainBundle] loadNibNamed:@"PlayerView" owner:self options:nil];
    [self addSubview: self.contentView];
}

- (void) updateSlider
{
    NSLog(@"Came here to update slider");
    AVPlayerItem *currentItem = self->player.currentItem;
    Float64 currentTime = CMTimeGetSeconds(currentItem.currentTime); //playing time
    Float64 duration = CMTimeGetSeconds(currentItem.duration); //total time
    
    //create a pair of labels
    self.playTimeLabel.text = [Utils floatToText:currentTime];
    self.durationLabel.text = [Utils floatToText:duration];
    if(duration == NAN)
        self.slider.value = 0;
    else
        self.slider.value = currentTime/duration;
}

-(void) initializeAudio
{
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    // Change the default output audio route
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                            sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
}

-(void) stream:(NSString*) streamURL withNetworkLatency:(double)network
{
    NSLog(@"Stream.");
    //Get the Stream URL
    NSURL *url = [NSURL URLWithString:streamURL];
    self->avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *commonMeta = [avAsset commonMetadata];
    for(AVMetadataItem *metaItem in commonMeta)
    {
        NSLog(@"common meta: %@", [metaItem commonKey]);
    }
    self->playerItem = [AVPlayerItem playerItemWithAsset:self->avAsset];
    self->player = [AVPlayer playerWithPlayerItem:self->playerItem];
    
    //double serverTime = [self calculateNetworkLatency];
    double serverTime = network;
    double eta = _startprop - serverTime;
    NSLog(@"eta=%f", eta);
    [self->player play];
    
    [self updateSlider];
    
    //[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    
}

@end
