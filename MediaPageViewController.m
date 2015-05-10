//
//  MediaPageViewController.m
//  EcstaticFM
//
//  Created by Kizma on 2015-05-10.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "MediaPageViewController.h"

@interface MediaPageViewController ()

@property (nonatomic, retain) soundCloudMediaPickerViewController *first;
@property (nonatomic, retain) UIViewController *second;

@end

@implementation MediaPageViewController {
    NSArray *viewControllers;
}

- (UIViewController *)first {
    if (!_first) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _first = [sb instantiateViewControllerWithIdentifier:@"soundCloudQuery"];
        [SoundCloudAPI getFavorites:_first];
        
    }
    return _first;
}

- (UIViewController *)second {
    if (!_second) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _second = [sb instantiateViewControllerWithIdentifier:@"sdsAPI"];
    }
    return _second;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    
    [self setViewControllers:@[self.first]
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
    
    return nextViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    UIViewController *prevViewController = nil;
    
    if (viewController == self.second) {
        prevViewController = self.first;
    }
    
    return prevViewController;
}

@end