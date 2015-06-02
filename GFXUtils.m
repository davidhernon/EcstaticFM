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
#define UIColorPurple [UIColor colorWithRed:0.757 green:0.302 blue:0.62 alpha:1] /*#c14d9e*/

#define UIColorPinkTop [UIColor colorWithRed:0.867 green:0.467 blue:0.384 alpha:1] /*#dd7762*/
#define UIColorPinkBottom [UIColor colorWithRed:0.827 green:0.4 blue:0.475 alpha:1] /*#d36679*/

#define UIColorWhite [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1] /*#fff*/



// The Main Background !
// This draws a background gradient
+(RadialGradientLayer*)getGradient:(CGRect)bounds
{
    // Create the gradient
    RadialGradientLayer *gradient = [RadialGradientLayer layer];
    
    // Set colors
    gradient.colors = [NSArray arrayWithObjects:
                       (id)UIColorOrange.CGColor,
                       (id)UIColorPurple.CGColor,
                       nil];
    
    // Set locations
    gradient.startPoint = CGPointMake(1,0);
    gradient.endPoint = CGPointMake(0,1);
    
    // Set bounds
    gradient.frame = bounds;
    
    return gradient;
}

// nav controller view
+(RadialGradientLayer*)getGradientNav:(CGRect)bounds
{
    // Create the gradient
    RadialGradientLayer *gradient = [RadialGradientLayer layer];
    
    // Set colors
    gradient.colors = [NSArray arrayWithObjects:
                       (id)UIColorOrange.CGColor,
                       (id)UIColorWhite.CGColor,
                       nil];
    
    // Set locations
    gradient.startPoint = CGPointMake(2,0);
    gradient.endPoint = CGPointMake(0,1);
    
    // Set bounds
    gradient.frame = bounds;
    
    return gradient;
}



// The Player's gradient
+(RadialGradientLayer*)getGradientPlayer:(CGRect)bounds
{
    // Create the gradient
    RadialGradientLayer *gradient = [RadialGradientLayer layer];
    
    // Set colors
    gradient.colors = [NSArray arrayWithObjects:
                       (id)UIColorOrange.CGColor,
                       (id)UIColorPurple.CGColor,
                       nil];
    
    // Set locations
    gradient.startPoint = CGPointMake(1,0);
    gradient.endPoint = CGPointMake(0,1);
    
    // Set bounds
    gradient.frame = bounds;
    
    return gradient;
}



// The Chat's gradient
+(RadialGradientLayer*)getGradientChat:(CGRect)bounds
{
    // Create the gradient
    RadialGradientLayer *gradient = [RadialGradientLayer layer];
    
    // Set colors
    gradient.colors = [NSArray arrayWithObjects:
                       (id)UIColorOrange.CGColor,
                       (id)UIColorPurple.CGColor,
                       nil];
    
    // Set locations
    gradient.startPoint = CGPointMake(0,0);
    gradient.endPoint = CGPointMake(1,1);
    
    // Set bounds
    gradient.frame = bounds;
    
    return gradient;
}

@end

