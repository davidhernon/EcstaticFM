//
//  Message.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-06-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "Message.h"

@implementation Message


- (id) initWithUser:(NSString *)user withContent:(NSString *)content withTime:(NSString*)time
{
    if(self = [super init])
    {
        self.user = [[NSString alloc] initWithString:user];
        self.content = [[NSString alloc] initWithString:content];
        self.time = [[NSString alloc] initWithString:time];
    }
    return self;
}

@end
