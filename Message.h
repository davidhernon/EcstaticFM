//
//  Message.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-06-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (retain, nonatomic) NSString *user;
@property (retain, nonatomic) NSString *content;

- (id) initWithUser:(NSString *)user withContent:(NSString *)content;

@end
