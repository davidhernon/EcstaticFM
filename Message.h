//
//  Message.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-06-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWLogging.h"

@interface Message : NSObject

@property (retain, nonatomic) NSString *user;
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *time;

- (id) initWithUser:(NSString *)user withContent:(NSString *)content withTime:(NSString*)time;

@end
