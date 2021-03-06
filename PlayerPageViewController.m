//
//  PlayerPageViewController.m
//  EcstaticFM
//
//  Created by Kizma on 2015-05-10.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "PlayerPageViewController.h"

@interface PlayerPageViewController ()

@property (nonatomic, retain) UIViewController *player;
@property (nonatomic, retain) UIViewController *chat;

@end

@implementation PlayerPageViewController {
    NSArray *viewControllers;
}

NSString* player_me_view_identifier = @"player";
NSString* chat_view_identifier = @"chat";

- (UIViewController *)player {
    if (!_player) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _player = [sb instantiateViewControllerWithIdentifier:player_me_view_identifier];
    }
    return _player;
}
- (UIViewController *)chat {
    if (!_chat) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _chat = [sb instantiateViewControllerWithIdentifier:chat_view_identifier];
    }
    return _chat;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    
    [self setViewControllers:@[self.player]
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
    
    if (viewController == self.player) {
        nextViewController = self.chat;
    }
    return nextViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    UIViewController *prevViewController = nil;
    
    if (viewController == self.chat) {
        prevViewController = self.player;
    }
    return prevViewController;
}

@end

