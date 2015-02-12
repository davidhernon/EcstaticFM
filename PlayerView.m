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
    AVPlayerItem *currentItem = _player.currentItem;
    Float64 currentTime = CMTimeGetSeconds(currentItem.currentTime); //playing time
    Float64 duration = CMTimeGetSeconds(currentItem.duration); //total time
    
    //create a pair of labels
    _playTimeLabel.text = [Utils floatToText:currentTime];
    _durationLabel.text = [Utils floatToText:duration];
    _slider.value = currentTime/duration;
}

// Stuff that needs to be moved to Player:
///
//
//
//
//
//

-(void) initializeAudio{
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    // Change the default output audio route
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                            sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
}

-(void) stream:(NSString*) streamURL
{
    NSLog(@"Stream.");
    //Get the Stream URL
    NSURL *url = [NSURL URLWithString:streamURL];
    _avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:_avAsset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    double serverTime = [self calculateNetworkLatency];
    double eta = _startprop - serverTime;
    NSLog(@"eta=%f", eta);
    [_player play];
   // [self createTimeLabels]; THIS LINE IS NOT NEEDED ANYMORE BECAUSE WE CREATE THEM IN THE .XIB
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    
}

- (double)calculateNetworkLatency
{
    if(self.j < 10)
    {
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL * url = [NSURL URLWithString:[Utils getWebsiteURL]];
        _requestStart = [NSDate date];
        
        NSURLSessionDataTask *dataTask = [delegateFreeSession dataTaskWithURL:url
                                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                if(error == nil)
                                                                {
                                                                    self.serverTimestamp = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                           options:kNilOptions
                                                                                                                             error:&error];
                                                                }
                                                                for(NSDictionary *item in _serverTimestamp) {
                                                                    self.serverTimestampString = [item valueForKey:@"timeStamp"];
                                                                }
                                                                self.serverTimestampString = [self.serverTimestampString stringByReplacingOccurrencesOfString: @"T" withString:@" "];
                                                                
                                                                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
                                                                self.serverTimestampDate = [formatter dateFromString:self.serverTimestampString];
                                                                self.serverTimeSinceEpoch = [self.serverTimestampDate timeIntervalSince1970];
                                                                [self.serverTimestampsArray addObject: [[NSNumber alloc] initWithDouble:self.serverTimeSinceEpoch]];
                                                                
                                                                [self.durations addObject: [[NSNumber alloc] initWithDouble:self.requestDuration]];
                                                                self.requestDuration = [[NSDate date] timeIntervalSinceDate:_requestStart];
                                                                self.j = self.j + 1;
                                                                [self calculateNetworkLatency];
                                                            }];
        [dataTask resume];
    }
    else
    {
        float average = 0;
        for(int i = 2; i < self.j; i++)
        {
            NSLog(@"Trial = %i", i);
            NSLog(@"Duration = %f", [[self.durations objectAtIndex:i]doubleValue]);
            NSLog(@"ServerTime = %f", [[self.serverTimestampsArray objectAtIndex:i]doubleValue]);
            
            average = average + [[self.durations objectAtIndex:i]doubleValue];
        }
        average = average/(self.j-2);
        self.requestDuration = average;
        self.serverTimeSinceEpoch = [[self.serverTimestampsArray objectAtIndex:(self.j-1)]doubleValue];
        return self.serverTimeSinceEpoch + self.requestDuration/2.0;
    }
    return -193234;
}

@end
