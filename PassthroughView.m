//
//  PassthroughView.m
//  EcstaticFM
//
//  Created by Kizma on 2015-06-22.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "PassthroughView.h"

@implementation PassthroughView

- (void)viewDidLoad {
    
    
}


-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}
@end
