//
//  EDAddFoodForNewMealViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/9/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDAddFoodForNewMealViewController.h"

#import "EDAddMealTableViewController.h"

#import "EDRestaurant+Methods.h"

@interface EDAddFoodForNewMealViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation EDAddFoodForNewMealViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    
    if (self.restaurant) {
        
    }
    
    self.searchBar.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.mealsList = [self.delegate mealsList];
    self.restaurant = [self.delegate restaurant];
    self.ingredientsList = [self.delegate ingredientsList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    
   
    
    NSString *restaurantName = self.restaurant.name ? [NSString stringWithFormat:@"Meals For %@", self.restaurant.name] : @"Meals";
    
    switch (section) {
        case 0:
            header = restaurantName;
            break;
            
        case 1:
            header = @"Ingredients";
            break;
        case 2:
            header = @"Medication";
            break;
        default:
            
            break;
    }
    
    return header;
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - Table View Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cellAtIndexPath = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) { // then meals section
        [self performSegueWithIdentifier:@"MealSegue" sender:indexPath];
    }
    else if (indexPath.section == 1) { // then ingredients section
        [self performSegueWithIdentifier:@"IngredientsSegue" sender:indexPath];
    }
    else if (indexPath.section == 2) { // then medication section
        [self performSegueWithIdentifier:nil sender:indexPath];
    }
    
}

#pragma mark - Storyboard Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"MealSegue"]) {
        EDAddMealTableViewController *destinationVC = segue.destinationViewController;
        NSIndexPath *index = (NSIndexPath *)sender;
        
        NSLog(@"index is %ld, %ld",  (long)index.section, (long)index.row);
        
        destinationVC.delegate = self.delegate;
        
        if (index.row == 0) { // by name
            destinationVC.sortBy = ByName;
        }
        else if (index.row == 1) { // by ingredient
            destinationVC.sortBy = ByIngredients;

        }
        else if (index.row == 2) { // by types
            destinationVC.sortBy = ByTypes;

        }
        else if (index.row == 3) { // by favorite and tags
           // destinationVC.sortBy = ByFavoriteAndTags;

        }
        else if (index.row == 4) { // by tags only
            //destinationVC.sortBy = ByTags;
        }
    }
    
    else if ([segue.identifier isEqualToString:@"IngredientsSegue"]){
        
    }
    
    else if ([segue.identifier isEqualToString:nil]) {
        
    }
}


#pragma mark - Search Bar Delegate -

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

@end
