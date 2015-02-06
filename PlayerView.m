//
//  PlayerView.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-05.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "PlayerView.h"
#import "Utils.h"

@implementation PlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createVolumeView{
    volumeView.backgroundColor = [Utils colorWithHexString:@"0EA48B"];
    
    //put the trackname on the view
    UILabel *tracknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    NSLog(@"Track name: %@", tracknameLabel.text);
    tracknameLabel.text = self->songTitle;
    tracknameLabel.textAlignment = NSTextAlignmentCenter;
    [tracknameLabel setTextColor:[UIColor whiteColor]];
    [tracknameLabel setBackgroundColor:[UIColor clearColor]];
    [tracknameLabel setFont:[UIFont fontWithName: @"Dosis-Bold" size: 14.0f]];
    [self->volumeView addSubview:tracknameLabel];
    
    //create slider
    CGRect frame = CGRectMake(30.0, 40.0, 260.0, 10.0);
    self->slider = [[UISlider alloc] initWithFrame:frame];
    //[slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    slider.continuous = YES;
    slider.value = 0.0;
    [self->volumeView addSubview:slider];
    
}

- (void) createTimeLabels{
    self->playtimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 75, 100, 20)];
    self->durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 75, 100, 20)];
    [self->volumeView addSubview:playtimeLabel];
    [self->volumeView addSubview:durationLabel];
    [self->volumeView bringSubviewToFront:playtimeLabel];
}
//returns the exact time that the server thinks it is, adjusted for network latency :)
- (double)calculateNetworkLatency
{
    if(self.j < 10)
    {
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL * url = [NSURL URLWithString:[Utils getWebsiteURL]];
        self.requestStart = [NSDate date];
        
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
