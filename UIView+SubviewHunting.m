//
//  UIView+SubviewHunting.m
//  LargeTableGrip
//
//  Created by Tom Parry on 21/08/13.
//
//

#import "UIView+SubviewHunting.h"

@implementation UIView (SubviewHunting)

- (UIView*) huntedSubviewWithClassName:(NSString*) className
{
	if([[[self class] description] isEqualToString:className])
		return self;
	
	for(UIView* subview in self.subviews)
	{
		UIView* huntedSubview = [subview huntedSubviewWithClassName:className];
		
		if(huntedSubview != nil)
			return huntedSubview;
	}
	
	return nil;
}

- (void) debugSubviews
{
	[self debugSubviews:0];
}

- (void) debugSubviews:(NSUInteger) count
{
	if(count == 0)
		printf("\n\n\n");
	
	for(int i = 0; i <= count; i++)
		printf("--");
	
	printf(" %s\n", [[self class] description].UTF8String);
	
	for(UIView* x in self.subviews)
		[x debugSubviews:(count + 1)];
	
	if(count == 0)
		printf("\n\n\n");
}

@end
