//
//  UIView+SubviewHunting.h
//  LargeTableGrip
//
//  Created by Tom Parry on 21/08/13.
//
//

#import <UIKit/UIKit.h>

@interface UIView (SubviewHunting)

- (UIView*) huntedSubviewWithClassName:(NSString*) className;
- (void) debugSubviews;

@end
