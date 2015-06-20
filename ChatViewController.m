#import <QuartzCore/QuartzCore.h>
#import "ChatViewController.h"

#define kTabBarHeight 0.0


@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    //    CGSize scrollContentSize = CGSizeMake(320, 640);
    //    _chatScrollView.contentSize = scrollContentSize;
    
    //Register tap gesture for dimissing the keyboard
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    _messages = [[NSMutableArray alloc] init];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    int people = [[Room currentRoom] getNumberOfListenersInRoom];
    if(people == 1)
    {
        _people_with_you.text = [NSString stringWithFormat:@"1 person with you"];
    }else{
        _people_with_you.text = [NSString stringWithFormat:@"%d people with you",people];
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	
	// Get Messages and Display them
	[SDSAPI getChatBacklog]; 
	
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    [SDSAPI sendText:self.chatTextField.text];
}

-(void) addChatLog:(NSString *)user content:(NSArray *)chatLog{
	[_messages removeAllObjects];
	for(NSString* chat in chatLog){
		NSData *objectData = [chat dataUsingEncoding:NSUTF8StringEncoding];
		NSDictionary *chatDict = [NSJSONSerialization JSONObjectWithData:objectData
																	 options:NSJSONReadingMutableContainers
																	   error:nil];
        //Faking timestamp on the app side
        Message* m = [[Message alloc]initWithUser:[chatDict objectForKey:@"username"] withContent:[chatDict objectForKey:@"textMessage"] withTime:[chatDict objectForKey:@"timestamp"]];
		NSLog(@"%@", [chatDict objectForKey:@"textMessage"]);
		[_messages addObject:m];
	}
}

- (void) addChatText:(NSString *)user content:(NSString *)content
{
    NSNumber *time_now = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    _message = [[Message alloc] initWithUser:user withContent:content withTime:[NSString stringWithFormat:@"%@",time_now ]];
    [_messages addObject:_message];
    [_chatTableView reloadData];
}

- (void) getMessages
{
    // Get the messages back from the server
}

-(void) newMessage
{
    // Append new message
    // Reload the scroll view
}

- (void) setMessagesInScrollView
{
    
}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // resize the scrollview
    CGRect viewFrame = _chatTableView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [_chatTableView setFrame:viewFrame];
    [UIView commitAnimations];
    
    _keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (_keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = _chatTableView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [_chatTableView setFrame:viewFrame];
    [UIView commitAnimations];
    _keyboardIsShown = YES;
}

-(void)dismissKeyboard {
    [_chatTextField resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        [self sendChat:self];
        _chatTextField = @"";
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
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

