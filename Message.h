//
//  Message.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-06-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (weak, nonatomic) NSString *user;
@property (weak, nonatomic) NSString *content;

@end
