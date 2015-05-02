//
//  RoomViewController.m
//  EcstaticFM
//
//  Created by Kizma on 2015-05-01.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "RoomViewController.h"

@interface RoomViewController ()

@end

@implementation RoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // This draws a background gradient
    
    // Add the gradient to the view
    [self.view.layer insertSublayer:[GFXUtils getGradient:self.view.bounds] atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
