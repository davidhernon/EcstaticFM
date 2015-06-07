//
//  Message.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-06-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "Message.h"

@implementation Message

- (id) initWithUser:(NSString *)user withContent:(NSString *)content
{
    if(self = [super init])
    {
        self.user = user;
        self.content = content;
    }
    return self;
}

@end
