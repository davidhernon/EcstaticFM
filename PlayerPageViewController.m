//
//  PlayerPageViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-09.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "PlayerPageViewController.h"

@interface PlayerPageViewController ()

@property (nonatomic, retain) UIViewController *first;
@property (nonatomic, retain) UIViewController *second;
@property (nonatomic, retain) UIViewController *third;

@end

@implementation PlayerPageViewController {
    NSArray *viewControllers;
}

- (UIViewController *)first {
    if (!_first) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _first = [sb instantiateViewControllerWithIdentifier:@"aroundMe"];
    }
    return _first;
}

- (UIViewController *)second {
    if (!_second) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _second = [sb instantiateViewControllerWithIdentifier:@"player"];
    }
    return _second;
}
- (UIViewController *)third {
    if (!_third) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _third = [sb instantiateViewControllerWithIdentifier:@"chat"];
    }
    return _third;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
 
    [self setViewControllers:@[self.second]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    UIViewController *nextViewController = nil;
    
    if (viewController == self.first) {
        nextViewController = self.second;
    }
    if (viewController == self.second) {
        nextViewController = self.third;
    }
    
    return nextViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    UIViewController *prevViewController = nil;
    
    if (viewController == self.third) {
        prevViewController = self.second;
    }
    if (viewController == self.second) {
        prevViewController = self.first;
    }
    
    return prevViewController;
}

@end
