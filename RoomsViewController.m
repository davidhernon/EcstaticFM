//
//  RoomsViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-06.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "RoomsViewController.h"

@interface RoomsViewController ()

@end

@implementation RoomsViewController

static NSString* popular_event_cell = @"popular_event_cell";
static NSString* around_me_event_cell = @"around_me_cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _popular = [NSArray arrayWithObjects:@"a", @"b", nil];
    _around_me = [NSArray arrayWithObjects:@"around", @"me", nil];
    [_roomTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return _popular.count;
    if (section == 1)
        return _around_me.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (indexPath.section == 0){
        cell = [self.roomTableView dequeueReusableCellWithIdentifier:@"popular_event_cell"];
        //cell.textLabel.text = [_popular objectAtIndex:indexPath.row];
        if(cell==nil){
                // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PopularTableCellView" owner:self options:nil];
                // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            
        }
    }
    
    if (indexPath.section == 1){
        cell = [self.roomTableView dequeueReusableCellWithIdentifier:@"around_me_cell"];
        //cell.textLabel.text = [_around_me objectAtIndex:indexPath.row];
        if(cell==nil){
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AroundMeTableCellView" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Popular";
    if (section == 1)
        return @"Around Me";
    return @"undefined";
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
