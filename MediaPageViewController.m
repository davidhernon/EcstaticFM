//
//  MediaPageViewController.m
//  EcstaticFM
//
//  Created by Kizma on 2015-05-10.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "MediaPageViewController.h"

@interface MediaPageViewController ()

@property (nonatomic, retain) soundCloudMediaPickerViewController *sound_cloud_media_picker;
@property (nonatomic, retain) UIViewController *sds_media_picker;

@end

@implementation MediaPageViewController {
    NSArray *viewControllers;
}

- (UIViewController *)sound_cloud_media_picker {
    if (!_sound_cloud_media_picker) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _sound_cloud_media_picker = [sb instantiateViewControllerWithIdentifier:@"soundCloudQuery"];
        [SoundCloudAPI getFavorites:_sound_cloud_media_picker];
        
    }
    return _sound_cloud_media_picker;
}

- (UIViewController *)sds_media_picker {
    if (!_sds_media_picker) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _sds_media_picker = [sb instantiateViewControllerWithIdentifier:@"sdsAPI"];
    }
    return _sds_media_picker;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    
    [self setViewControllers:@[self.sound_cloud_media_picker]
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
    
//    if (viewController == self.sound_cloud_media_picker) {
//        nextViewController = self.sds_media_picker;
//    }
    
    return nextViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    UIViewController *prevViewController = nil;
    
//    if (viewController == self.sds_media_picker) {
//        prevViewController = self.sound_cloud_media_picker;
//    }
    
    return prevViewController;
}

@end