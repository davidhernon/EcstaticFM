//
//  MessageTests.m
//  MessageTests
//
//  Created by David Hernon on 2015-01-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import <XCTest/XCTest.h>

@interface MessageTest : XCTestCase

@end

@implementation MessageTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)messageCreatedWithTimeAsNumberNotString {
    // This is an example of a functional test case.
    NSMutableDictionary *chatDict = [[NSMutableDictionary alloc] init];
    [chatDict setValue:[NSNumber numberWithDouble:1111111.0] forKey:@"timestamp"];
    Message * mess = [[Message alloc] initWithUser:@"user" withContent:@"content" withTime:[chatDict objectForKey:@"timestamp"]];
    if([mess.time isKindOfClass:[NSString class]]){
        XCTAssert(YES, @"Pass");
    }else{
        XCTAssert(NO, @"Failure");
    }
    
}

@end