//
//  MediaPickerTableViewController.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-25.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "MediaPickerTableViewController.h"
#import "MediaItemViewCell.h"
#import "Utils.h"
#import "SCUI.h"

@interface MediaPickerTableViewController ()

@end

@implementation MediaPickerTableViewController
@synthesize tracks;

- (void)viewDidLoad {
    //[self getTracks:self];
    [super viewDidLoad];
    [self.tableView reloadData];
    
    //self.favorites = [Utils soundCloudRequest:self];
// TODO there might need to be a [self reloadData] call here
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.tracks count];
}

//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MediaItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MediaPickerTableViewController" forIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[MediaItemViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MediaPickerTableViewController"];
//    }
//    
//    NSArray* response = (NSArray*)_favorites;
//    
//    for(NSDictionary *item in response) {
//        NSLog(@"Item: %@", item);
//    }
//    
//    // Configure the cell...
//    
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MediaPickerCellView";
    MediaItemViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    cell.trackTitle.text = [track objectForKey:@"title"];
    
    return cell;
}

//- (IBAction) getTracks:(id) sender
//{
//    SCAccount *account = [SCSoundCloud account];
//    if (account == nil) {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Not Logged In"
//                              message:@"You must login first"
//                              delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    
//    SCRequestResponseHandler handler;
//    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
//        NSError *jsonError = nil;
//        NSJSONSerialization *jsonResponse = [NSJSONSerialization
//                                             JSONObjectWithData:data
//                                             options:0
//                                             error:&jsonError];
//        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
//            tracks = (NSArray *)jsonResponse;
//            for(NSDictionary *item in (NSDictionary*)jsonResponse)
//            {
//                NSLog(@"item: %@", item);
//            }
//        }
//    };
//    
//    NSString *resourceURL = @"https://api.soundcloud.com/me/favorites.json";
//    [SCRequest performMethod:SCRequestMethodGET
//                  onResource:[NSURL URLWithString:resourceURL]
//             usingParameters:nil
//                 withAccount:account
//      sendingProgressHandler:nil
//             responseHandler:handler];
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
