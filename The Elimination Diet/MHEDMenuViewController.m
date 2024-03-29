//
//  EDMenuViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/17/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDMenuViewController.h"

@interface MHEDMenuViewController ()

@end

@implementation MHEDMenuViewController

- (NSArray *) options{
    if (!_options) {
        _options = [[NSArray alloc] init];
    }
    return _options;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithOptions:(NSArray *) options
{
    self = [self initWithNibName:Nil bundle:Nil];
    if (self) {
        
        self.options = options;
        
        NSArray *tableOptions = [[NSArray alloc] init];
        
        for (int i = 0; i < [self.options count]; i++) {
            tableOptions = [tableOptions arrayByAddingObject:@[self.options[i]]];
        }
        
        NSDictionary *tableDictionaryOptions = [EDTableViewController indexedDictionaryForTableObjectsUsingObjects:tableOptions];
        
        [self updateTableObjectsAndSectionHeaders:tableDictionaryOptions];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableView *) setUpTableView:(CGRect)frame
{
    UITableView *tempTableView = [super setUpTableView:frame];
    
    tempTableView.showsVerticalScrollIndicator = NO;
    tempTableView.showsHorizontalScrollIndicator = NO;
    tempTableView.scrollEnabled = NO;
    
    return tempTableView;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
