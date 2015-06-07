//
//  Event.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-01-31.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *myDateString;
- (id)initWithDict:(NSArray*)eventDict atIndex:(NSInteger)index;



@end
