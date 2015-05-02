//
//  GFXUtils.m
//  EcstaticFM
//
//  Created by Kizma on 2015-05-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "GFXUtils.h"


@implementation GFXUtils

// Our COLORS! :D
#define UIColorOrange [UIColor colorWithRed:0.949 green:0.584 blue:0.216 alpha:1] /*#f29537*/
#define UIColorPink [UIColor colorWithRed:0.757 green:0.302 blue:0.62 alpha:1] /*#c14d9e*/


// The Main Background !
// This draws a background gradient
+(RadialGradientLayer*)getGradient:(CGRect)bounds
{
    // Create the gradient
    RadialGradientLayer *gradient = [RadialGradientLayer layer];
    
    // Set colors
    gradient.colors = [NSArray arrayWithObjects:
                       (id)UIColorOrange.CGColor,
                       (id)UIColorPink.CGColor,
                       nil];
    
    // Set locations
    gradient.startPoint = CGPointMake(1,0);
    gradient.endPoint = CGPointMake(0,1);
    
    // Set bounds
    gradient.frame = bounds;
    
    return gradient;
}

@end
