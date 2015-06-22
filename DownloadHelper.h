//
//  DownloadHelper.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-06-22.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloadHelperDelegate <NSObject>
@required
- (void) didReceiveData: (NSData *) theData;
- (void) didReceiveFilename: (NSString *) aName;
- (void) dataDownloadFailed: (NSString *) reason;
- (void) dataDownloadAtPercent: (NSNumber *) aPercent;
@end

@interface DownloadHelper : NSObject
{
    NSURLResponse *response;
    NSMutableData *data;
    NSString *urlString;
    NSURLConnection *urlconnection;
    id <DownloadHelperDelegate> delegate;
    BOOL isDownloading;
}
@property (retain) NSURLResponse *response;
@property (retain) NSURLConnection *urlconnection;
@property (retain) NSMutableData *data;
@property (retain) NSOutputStream *stream;
@property (retain) NSString *urlString;
@property (retain) id delegate;
@property (assign) BOOL isDownloading;

+ (DownloadHelper *) sharedInstance;
+ (void) download:(NSString *) aURLString;
+ (void) cancel;
@end
