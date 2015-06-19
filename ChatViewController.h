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
#import "SDSAPI.h"

@interface ChatViewController : UIViewController <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong)UITapGestureRecognizer *chatTapGestureRecognizer;
@property BOOL keyboardIsShown;
@property (weak, nonatomic) IBOutlet UILabel *people_with_you;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (retain, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) IBOutlet UITextView *chatTextField;
@property (strong, nonatomic) Message *message;

- (IBAction)sendChat:(id)sender;
- (void)addChatText:(NSString*)text;
- (void)didReceiveMemoryWarning;
- (void)keyboardWillHide:(NSNotification *)n;
- (void)addChatText:(NSString*)user content:(NSString*)content;
-(void) addChatLog:(NSString *)user content:(NSArray *)chatLog;

@end
