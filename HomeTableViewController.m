//
//  HomeTableViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-18.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "HomeTableViewController.h"

@interface HomeTableViewController ()

@end
@implementation HomeTableViewController
@synthesize eventDict;
NSArray *keys;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.eventDict = appDelegate.eventD;  //..to read
    
    for(NSDictionary *item in self.eventDict) {
        NSLog (@"nsdic = %@", item);
    }
    
    [self intializeGraphics];
    [self.tableView reloadData];
}

- (void) intializeGraphics{
    [self.navigationController setNavigationBarHidden:YES];   //it hides
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(320, 75, 320, 75)];
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(320, 75, 320, 75)];
    labelView.text = @"SDS Upcoming Events";
    labelView.textAlignment = NSTextAlignmentCenter;
    labelView.font = [UIFont fontWithName:@"Dosis-ExtraBold" size:27];
    [headerView addSubview:labelView];
    [labelView setCenter:CGPointMake(headerView.frame.size.width / 2, headerView.frame.size.height / 2)];
    self.tableView.tableHeaderView = headerView;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"number of Events = %lu", (unsigned long)[eventDict count]);
    return [eventDict count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Initialize Cell
    static NSString *tableID = @"eventCell";
    EventCellView *cell = [self.tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil) {
        cell = [[EventCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableID];
    }
    
    NSDictionary *jsonDict = [eventDict objectAtIndex:indexPath.row];
    
    //set cell title
    NSString *title = [jsonDict objectForKey:@"title"];
    NSString *location = [jsonDict objectForKey:@"location"];
    NSString *d = [jsonDict objectForKey:@"start"];
    
    //Date Formatting
    double date = d.doubleValue +(4*3600);
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *myDateString = [dateFormatter stringFromDate:messageDate];
    
    //Set the Cell's labels
    cell.dateLabel.text = myDateString;
    cell.titleLabel.text = title;
    cell.locationLabel.text = location;
    
    
    //cell formatting
    cell.backgroundColor = [Utils colorWithHexString:@"0e1633"];
    cell.dateLabel.font = [UIFont fontWithName:@"Dosis-Bold" size:20];
    cell.locationLabel.font = [UIFont fontWithName:@"Dosis-Bold" size:20];
    cell.titleLabel.font = [UIFont fontWithName:@"Dosis-Bold" size:20];
    cell.dateLabel.textColor = [Utils colorWithHexString: @"#D8D6D3"];
    cell.titleLabel.textColor = [Utils colorWithHexString: @"#697880"];
    cell.locationLabel.textColor = [Utils colorWithHexString: @"#697880"];
    NSLog (@"hiii");
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self->dest = [segue destinationViewController];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Grab everything out of the json
    NSDictionary *jsonDict = [eventDict objectAtIndex:indexPath.row];
    NSString *latdat = [jsonDict objectForKey:@"latitude"];
    NSString *longdat = [jsonDict objectForKey:@"longitude"];
    NSString *title = [jsonDict objectForKey:@"title"];
    NSString *location = [jsonDict objectForKey:@"location"];
    NSString *start = [jsonDict objectForKey:@"start"];
    
    double date = start.doubleValue +(4*3600);
    
    //Process songTitle
    NSString *urlSongTitle = [jsonDict objectForKey:@"songTitle"];
    
    NSArray *songTitleSplit = [urlSongTitle componentsSeparatedByString:@"/"];
    NSString *songTitleProcessing = [songTitleSplit lastObject];
    NSArray *songTitleSplit2 = [songTitleProcessing componentsSeparatedByString:@"."];
    NSString *songTitle = songTitleSplit2[0];
    NSLog (@"songTitle = %@", songTitle);
    
    dest->songTitle = songTitle;
    dest->eventTitle = title;
    dest->location = location;
    dest->latitude = [latdat floatValue];
    dest->longitude = [longdat floatValue];
    dest->streamURL = urlSongTitle;
    dest.startprop = date;
}

@end
