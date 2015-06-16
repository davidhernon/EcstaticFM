//
//  Settings.m
//  EcstaticFM
//
//  Created by Martin Weiss 1 on 2015-06-16.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "Settings.h"

@implementation Settings

- (IBAction)Logout:(id)sender {
	[SDSAPI logout];
	//should transition to loginview
}
@end
