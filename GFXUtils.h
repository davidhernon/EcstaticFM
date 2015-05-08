//
//  GFXUtils.h
//  EcstaticFM
//
//  Created by Kizma on 2015-05-02.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RadialGradientLayer.h"

@class RadialGradientLayer;

@interface GFXUtils : NSObject

+(RadialGradientLayer*)getGradient:(CGRect)bounds;
+(RadialGradientLayer*)getGradientPlayer:(CGRect)bounds;
+(RadialGradientLayer*)getGradientChat:(CGRect)bounds;

@end
