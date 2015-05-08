//
//  SwipeBetweenAPIViewControllers.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-03-12.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol SwipeBetweenViewControllersDelegate <NSObject>

@end


#import <UIKit/UIKit.h>
#import "soundCloudMediaPickerViewController.h"
#import "SCUI.h"

@interface SwipeBetweenViewControllers : UINavigationController <UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *viewControllerArray;
@property (nonatomic, weak) id<SwipeBetweenViewControllersDelegate> navDelegate;
@property (nonatomic, strong) UIView *selectionBar;
@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong)UIView *navigationView;
@property (nonatomic, strong)NSArray *buttonText;
@property (nonatomic, strong)soundCloudMediaPickerViewController* soundCloudAPI;

@end
