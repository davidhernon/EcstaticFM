//
//  PlayerView.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-11.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "PlayerView.h"
#import "MediaPickerTableViewController.h"


@implementation PlayerView

/*!
 Runs specific code upon call from associated .xib file
 Loads the appropriate Nib into the mainBundle and adds contentView as the subview
 */
-(void)awakeFromNib {
    //Note That You Must Change @”BNYSharedView’ With Whatever Your Nib Is Named
    [[NSBundle mainBundle] loadNibNamed:@"PlayerView" owner:self options:nil];
    [self addSubview: self.contentView];
}

/*!
 Updates PlayerView's UISlider for to indicate duration through the current item
 */
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

/*!
 Prepares iOS audio with appropriate parameters and changes default audio output
 */
-(void) initializeAudio
{
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                            sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
}

/*!
 Begins playing audio over a streaming protocol
 @params streamURL NSString indicating location of streaming media
 @params network A double indicating the network latency in milliseconds
 */
-(void) stream:(NSString*) streamURL withNetworkLatency:(double)network
{

    NSURL *url = [NSURL URLWithString:streamURL];
    self->avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    self->playerItem = [AVPlayerItem playerItemWithAsset:self->avAsset];
    self->player = [AVPlayer playerWithPlayerItem:self->playerItem];
    [self->player play];
    
     double eta = _startprop - network;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    
}

-(IBAction)soundCloudRequest:(id)sender
{
    
    SCAccount *account = [SCSoundCloud account];
    
    if(account == nil){
        // TODO:
        NSLog(@"SoundCloud account was nil, need to sign in!");
        return;
    }
    
    NSString *resourceURL = @"https://api.soundcloud.com/me/favorites.json";
    
    id obj = [SCRequest performMethod:SCRequestMethodGET
                           onResource:[NSURL URLWithString:resourceURL]
                      usingParameters:nil
                          withAccount:account
               sendingProgressHandler:nil
                      responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                          // Handle the response
                          if (error) {
                              NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                          } else {
                              // Check the statuscode and parse the data
                              NSError *jsonError = nil;
                              NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                                                   JSONObjectWithData:data
                                                                   options:0
                                                                   error:&jsonError];
                                  if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
                                      NSLog(@"json %@",(NSArray *)jsonResponse);
                                      
                                  }
                              
                          }
                      }];
    
    
}

-(IBAction)nextScreen
{
   
}

@end
