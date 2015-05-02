//
//  RadialGradientLayer.m
//  EcstaticFM
//
//  Created by Kizma on 2015-05-01.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "RadialGradientLayer.h"

@implementation RadialGradientLayer


- (void)drawInContext:(CGContextRef)ctx
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray* colors = @[(id)[UIColor whiteColor].CGColor, (id)[UIColor blackColor].CGColor];
    CGFloat locations[] = {.25, .75};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, locations);
    CGPoint center = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height  / 2};
    CGContextDrawRadialGradient(ctx, gradient, center, 20, center, 40, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end