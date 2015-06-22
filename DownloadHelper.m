//
//  DownloadHelper.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-06-22.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "DownloadHelper.h"

#define DELEGATE_CALLBACK(X, Y) if (sharedInstance.delegate && [sharedInstance.delegate respondsToSelector:@selector(X)]) [sharedInstance.delegate performSelector:@selector(X) withObject:Y];
#define NUMBER(X) [NSNumber numberWithFloat:X]

static DownloadHelper *sharedInstance = nil;

@implementation DownloadHelper
@synthesize response;
@synthesize data;
@synthesize delegate;
@synthesize urlString;
@synthesize urlconnection;
@synthesize isDownloading;
@synthesize stream;

- (void) start
{
    
    stream = [[NSOutputStream alloc] initToFileAtPath:urlString append:YES];
    [stream open];
    
    self.isDownloading = NO;
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    if (!url)
    {
        NSString *reason = [NSString stringWithFormat:@"Could not create URL from string %@", self.urlString];
        DELEGATE_CALLBACK(dataDownloadFailed:, reason);
        return;
    }
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    if (!theRequest)
    {
        NSString *reason = [NSString stringWithFormat:@"Could not create URL request from string %@", self.urlString];
        DELEGATE_CALLBACK(dataDownloadFailed:, reason);
        return;
    }
    
    self.urlconnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (!self.urlconnection)
    {
        NSString *reason = [NSString stringWithFormat:@"URL connection failed for string %@", self.urlString];
        DELEGATE_CALLBACK(dataDownloadFailed:, reason);
        return;
    }
    
    self.isDownloading = YES;
    
    // Create the new data object
    self.data = [NSMutableData data];
    self.response = nil;
    
    [self.urlconnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) cleanup
{
    self.data = nil;
    self.response = nil;
    self.urlconnection = nil;
    self.urlString = nil;
    self.isDownloading = NO;
    [self.stream close];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
    // store the response information
    self.response = aResponse;
    
    // Check for bad connection
    if ([aResponse expectedContentLength] < 0)
    {
        NSString *reason = [NSString stringWithFormat:@"Invalid URL [%@]", self.urlString];
        DELEGATE_CALLBACK(dataDownloadFailed:, reason);
        [connection cancel];
        [self cleanup];
        return;
    }
    
    if ([aResponse suggestedFilename])
        DELEGATE_CALLBACK(didReceiveFilename:, [aResponse suggestedFilename]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    //ORIGINAL FROM OWNER
//    // append the new data and update the delegate
//    [self.data appendData:theData];
//    if (self.response)
//    {
//        float expectedLength = [self.response expectedContentLength];
//        float currentLength = self.data.length;
//        float percent = currentLength / expectedLength;
//        DELEGATE_CALLBACK(dataDownloadAtPercent:, NUMBER(percent));
//    }
    
    //NEW METHOD
    NSUInteger left = [theData length];
    NSUInteger nwr = 0;
    do {
        nwr = [stream write:[theData bytes] maxLength:left];
        if (-1 == nwr) break;
        left -= nwr;
    } while (left > 0);
    if (left) {
        NSLog(@"stream error: %@", [stream streamError]);
    }
    
    if (self.response)
    {
        float expectedLength = [self.response expectedContentLength];
        float currentLength = self.data.length;
        float percent = currentLength / expectedLength;
        DELEGATE_CALLBACK(dataDownloadAtPercent:, NUMBER(percent));
    }
    NSLog(@"got more!");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // finished downloading the data, cleaning up
    self.response = nil;
    
    // Delegate is responsible for releasing data
    if (self.delegate)
    {
        NSData *theData = self.data;
        DELEGATE_CALLBACK(didReceiveData:, theData);
    }
    [self.urlconnection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self cleanup];
    NSLog(@"Did finish downloading");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.isDownloading = NO;
    NSLog(@"Error: Failed connection, %@", [error localizedDescription]);
    DELEGATE_CALLBACK(dataDownloadFailed:, @"Failed Connection");
    [self cleanup];
}

+ (DownloadHelper *) sharedInstance
{
    if(!sharedInstance) sharedInstance = [[self alloc] init];
    return sharedInstance;
}

+ (void) download:(NSString *) aURLString
{
    if (sharedInstance.isDownloading)
    {
        NSLog(@"Error: Cannot start new download until current download finishes");
        DELEGATE_CALLBACK(dataDownloadFailed:, @"");
        return;
    }
    
    sharedInstance.urlString = aURLString;
    [sharedInstance start];
}

+ (void) cancel
{
    if (sharedInstance.isDownloading) [sharedInstance.urlconnection cancel];
}
@end
