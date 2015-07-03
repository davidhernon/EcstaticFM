#import <QuartzCore/QuartzCore.h>
#import "ChatViewController.h"

#define kTabBarHeight 0.0


@interface ChatViewController ()


@end

@implementation ChatViewController

- (void)viewDidLoad {
    MWLogDebug(@"Chat - ChatViewController - viewDidLoad - Loading the Chat  View Controller");
    [super viewDidLoad];
    
    _chatTableView.estimatedRowHeight = 72.0;
    _chatTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.chatTextField.delegate = self;
    // Do any additional setup after loading the view.
    
    AppDelegate* appDelegate =  (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.chatViewController = self;
    
    // Add the gradient to the view
    [self.view.layer insertSublayer:[GFXUtils getGradientChat:self.view.bounds] atIndex:0];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    _keyboardIsShown = NO;

    //Register tap gesture for dimissing the keyboard
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    _messages = [[NSMutableArray alloc] init];
    
    MWLogDebug(@"Chat - ChatViewController - viewDidLoad - Completed loading the Chat  View Controller");
    
}

-(void) viewDidAppear:(BOOL)animated
{
    MWLogDebug(@"Chat - ChatViewController - viewDidAppear - Chat View Did Appear, setting _people_with_you label text");
    
    int people = [[Room currentRoom] getNumberOfListenersInRoom];
    if(people == 1)
    {
        _people_with_you.text = [NSString stringWithFormat:@"1"];
    }else{
        _people_with_you.text = [NSString stringWithFormat:@"%d",people];
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
    
    MWLogDebug(@"Chat - ChatViewController - viewWillAppear : About to get Chat Backlog");
	
	// Get Messages and Display them
	[SDSAPI getChatBacklog]; 
	
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MWLogDebug(@"Chat - ChatViewController - tableView:numberOfRowsInSection - Returning number of rows in section, number of rows is = %i", [_messages count]);
    return [_messages count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    Message *message = [_messages objectAtIndex:indexPath.row];
    NSString *usr = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    MessageTableViewCell *cell = [[MessageTableViewCell alloc] init];
    if([usr isEqualToString:message.user])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"myMessageCell"];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyMessageView" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"otherUserMessageCell"];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"OtherUserMessageView" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
    }
    
    MWLogDebug(@"Chat - ChatViewController - tableView:cellForRowAtIndexPath: - setting up MessageTableaViewCell for user: %@ with content: %@ at timestamp:%@", message.user, message.content, message.time);
    
    cell.user.text = message.user;
    cell.content.text = message.content;
    cell.timestamp.text = message.time;
    cell.clipsToBounds = YES;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendChat:(id)sender
{
    MWLogDebug(@"Chat - ChatViewController - sendChat: - sending chat message from client");
    
    if(_chatTextField.text.length > 0)
        [SDSAPI sendText:self.chatTextField.text];
    //empty the text field
    _chatTextField.text = nil;
    //close the keyboard
    [self.view endEditing:YES];
}

-(void) addChatLog:(NSString *)user content:(NSArray *)chatLog{
    
    MWLogDebug(@"Chat - ChatViewController - addChatLog:content - removing current messages and adding chat messages from server");
    
    [_messages removeAllObjects];
    for(NSString* chat in chatLog){
        NSData *objectData = [chat dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *chatDict = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
        
        
        //Format the time back from the server
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:[(NSNumber*)[chatDict objectForKey:@"timestamp"] intValue] ];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        NSString *stringFromDate = [formatter stringFromDate:date];
        
        Message* m = [[Message alloc]initWithUser:[chatDict objectForKey:@"username"] withContent:[chatDict objectForKey:@"textMessage"] withTime:stringFromDate];
        NSLog(@"%@", [chatDict objectForKey:@"textMessage"]);
        [_messages addObject:m];
    }
    
}

- (void) addChatText:(NSString *)user content:(NSString *)content
{
    MWLogDebug(@"Chat - ChatViewController - addChatText:content - adding chat text sent to user and scrolling to last row");
    
    //Format the time back from the server
    NSNumber *time_now = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    _message = [[Message alloc] initWithUser:user withContent:content withTime:[NSString stringWithFormat:@"%@",time_now ]];
    [_messages addObject:_message];
    [_chatTableView reloadData];
    
    //scroll to the last row
    int lastRowNumber = [_chatTableView numberOfRowsInSection:0] - 1;
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
    [_chatTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];

    
}


//- (void) getMessages
//{
//    // Get the messages back from the server
//}

//-(void) newMessage
//{
//    // Append new message
//    // Reload the scroll view
//}

//- (void) setMessagesInScrollView
//{
//    
//}


// Pushes the view up when the keyboard appears and brings it back to original position after

- (void)keyboardWillShow:(NSNotification *)n
    {
        
    MWLogDebug(@"Chat - ChatViewController - keyboardWillShow - showing keyboard and sliding up screen view");

        
        //get the screen size and store it in floats
        float SW;
        float SH;
        SW = [[UIScreen mainScreen] bounds].size.width;
        SH = [[UIScreen mainScreen] bounds].size.height;
        
        // get the size of the keyboard
        NSDictionary* userInfo = [n userInfo];
        CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        //reposition the view
        [_chatView setFrame:CGRectMake(0,-keyboardSize.height,SW,SH)];
        
    }

- (void)keyboardWillHide:(NSNotification *)n
    {
        
        MWLogDebug(@"Chat - ChatViewController - keyboardWillHide - hiding keyboard and sliding down screen view");

        //get the screen size and store it in floats
        float SW;
        float SH;
        SW = [[UIScreen mainScreen] bounds].size.width;
        SH = [[UIScreen mainScreen] bounds].size.height;
        
        //reset the view to it's original position and size
        [_chatView setFrame:CGRectMake(0,0,SW,SH)];
        
    }


    -(void)dismissKeyboard {
        [_chatTextField resignFirstResponder];
    }


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    MWLogDebug(@"Chat - ChatViewController - textView:shouldChangeTextInRange:replacementText - textView had send button pressed. Sending chat and resigning the keyboard and reinitializing the text input field.");

    
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
            [textView resignFirstResponder];
            [self sendChat:self];
        //empty the text field
            _chatTextField.text = @"";
        //close the keyboard
            [self.view endEditing:YES];
        // Return FALSE so that the final '\n' character doesn't get added
            return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

-(IBAction)swipeToPlayer:(id)sender
{
    [(PlayerPageViewController*)self.parentViewController swipeToPlayerViewControllerReverse];
}

-(IBAction)swipeToSettings:(id)sender
{
    [(PlayerPageViewController*)self.parentViewController swipeToSettingsViewControllerForward];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//


@end

