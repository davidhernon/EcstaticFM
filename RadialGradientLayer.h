//
//  RadialGradientLayer.h
//  EcstaticFM
//
//  Created by Kizma on 2015-05-01.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "GFXUtils.h"


@interface RadialGradientLayer : CAGradientLayer

- (void)drawInContext:(CGContextRef)ctx;

@end