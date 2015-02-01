//
//  Event.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-01-31.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "Event.h"

@implementation Event

- (id) init
{
    self = [super init];
    if(self != NULL)
    {
        self.title = @"";
        self.location = @"";
        self.myDateString = @"";
    }
    return self;
}

- (id)initWithDict:(NSArray*)eventDict atIndex:(NSInteger)index
{
    self = [super init];
    if(self != NULL)
    {
        //set cell title
        NSMutableDictionary *jsonDict = [eventDict objectAtIndex:index];
        self.title = [jsonDict objectForKey:@"title"];
        self.location = [jsonDict objectForKey:@"location"];
        NSString *d = [jsonDict objectForKey:@"start"];
        
        //Dat formatting
        double date = d.doubleValue +(4*3600);
        NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        self.myDateString = [dateFormatter stringFromDate:messageDate];
        
    }
    return self;
}

@end
