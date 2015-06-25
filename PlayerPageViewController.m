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
@property (nonatomic, retain) UIViewController *settings;

@end

@implementation PlayerPageViewController {
    NSArray *viewControllers;
}

NSString* player_me_view_identifier = @"player";
NSString* chat_view_identifier = @"chat";
NSString* settings_view_identifier = @"settings";

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

- (UIViewController *) settings {
    if( !_settings) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _settings = [sb instantiateViewControllerWithIdentifier:settings_view_identifier];
    }
    return _settings;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    [self swipeToPlayerViewControllerForward];
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
    if(viewController == self.chat) {
        nextViewController = self.settings;
    }
    return nextViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    UIViewController *prevViewController = nil;
    if(viewController == self.settings) {
        prevViewController = self.chat;
    }
    if (viewController == self.chat) {
        prevViewController = self.player;
    }
    return prevViewController;
}


//Begin block of programmatic swipes between UIViewControllers
//These functions can be called from a childVC to swipe to other view controllers in this PageViewController in Forward and Reverse directions
//Currently they are called from functions in the respective child vc which are hooked up to UI buttons
-(void)swipeToChatViewControllerForward
{
    [self setViewControllers:@[self.chat]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
}

-(void)swipeToChatViewControllerReverse
{
    [self setViewControllers:@[self.chat]
                   direction:UIPageViewControllerNavigationDirectionReverse
                    animated:YES
                  completion:nil];
}

-(void)swipeToPlayerViewControllerReverse
{
    [self setViewControllers:@[self.player]
                   direction:UIPageViewControllerNavigationDirectionReverse
                    animated:YES
                  completion:nil];
}

-(void)swipeToPlayerViewControllerForward
{
    [self setViewControllers:@[self.player]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
}

-(void)swipeToSettingsViewControllerForward
{
    [self setViewControllers:@[self.settings]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
}
//End block of programmatic swipes

@end

