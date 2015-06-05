//
//  ChatViewController.h
//  EcstaticFM
//
//  Created by Kizma on 2015-05-08.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GFXUtils.h"
#import "RadialGradientLayer.h"
#import "Room.h"
#import "MessageTableViewCell.h"
#import "Message.h"

@interface ChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong)UITapGestureRecognizer *chatTapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIScrollView *chatScrollView;
@property (weak, nonatomic) IBOutlet UITextField *chatTextField;
@property BOOL keyboardIsShown;
@property (weak, nonatomic) IBOutlet UILabel *people_with_you;

@property (weak, nonatomic) IBOutlet UITableView *chat_table_view;

@property (retain, nonatomic) NSMutableArray *messages;

- (void)didReceiveMemoryWarning;
- (void)keyboardWillHide:(NSNotification *)n;

@end
