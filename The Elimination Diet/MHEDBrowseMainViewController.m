//
//  MHEDBrowseOptionsViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/6/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDBrowseMainViewController.h"

#import "EDTableComponents.h"

#import "EDAddMealTableViewController.h"
#import "EDEatMealViewController.h"
#import "EDTakeNewMedicationViewController.h"
#import "EDAddTableViewController.h"

#import "EDEliminatedAPI.h"

#import "EDMeal+Methods.h"
#import "EDRestaurant+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDType+Methods.h"
#import "EDTag+Methods.h"

#import "EDMedication+Methods.h"

@interface MHEDBrowseMainViewController ()

@end

@implementation MHEDBrowseMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    // self.navigationItem.rightBarButtonItem = self.mheditButtonItem;
    
    NSArray *foodSection = @[@"Meals", @"Ingredients", @"Ingredient Types", @"Restaurants"];
    
    NSArray *symptomsSection = @[@"Symptoms", @"Symptom Type", @"Body Part"];
    
    self.browseOptions = @[foodSection, symptomsSection];
    self.title = @"Browse";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    
    else {
        return 2;
    }
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    
    else if (section == 0) {
        header = @"Food";
    }
    
    else if (section == 1) {
        header = @"Symptoms";
    }
    
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 44;
        
    }
    else {
        return self.tableView.rowHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
        
    }
    else {
        return [self.browseOptions[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    UIFont *titleLabelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    UIFont *subtitleLabelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:searchResultCellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:searchResultCellIdentifier];
        }
        
        //        NSLog(@"section %d, row %d", indexPath.section, indexPath.row);
        //        NSLog(@"%d", [self.searchResults count]);
        //        NSLog(@"%@", [self.searchResults[indexPath.row] name]);
        
        EDFood *foodForIndexPath = self.searchResults[indexPath.row];
        
        NSString *name = foodForIndexPath.name;
        
        // Create a prefix for the label's title to indicate what type of food it is
        NSString *foodClass = @"";
        
        if ([self.searchResults[indexPath.row] isKindOfClass:[EDMeal class]]) {
            foodClass = @"(meal) ";
        }
        else if ([self.searchResults[indexPath.row] isKindOfClass:[EDIngredient class]]) {
            foodClass = @"(ingredient) ";
        }
        else if ([self.searchResults[indexPath.row] isKindOfClass:[EDType class]]) {
            foodClass = @"(type) ";
        }
        else if ([self.searchResults[indexPath.row] isKindOfClass:[EDRestaurant class]]) {
            foodClass = @"(restaurant) ";
        }
        else if ([self.searchResults[indexPath.row] isKindOfClass:[EDMedication class]]) {
            foodClass = @"(medication) ";
        }
        
        
        // creates foodClass text label with grey color
        NSAttributedString *foodClassAttributed = [[NSAttributedString alloc] initWithString:foodClass
                                                                                  attributes:@{ NSFontAttributeName : titleLabelFont, NSForegroundColorAttributeName : [UIColor grayColor]}];
        
        NSRange searchTextRange = [name rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
        
        NSMutableAttributedString *mutNameAttributed = [[NSMutableAttributedString alloc] initWithString:name
                                                                                              attributes:@{ NSFontAttributeName : titleLabelFont}];
        
        [mutNameAttributed setAttributes:@{ NSFontAttributeName : titleLabelFont, NSBackgroundColorAttributeName : [UIColor yellowColor]} range:searchTextRange];
        
        [mutNameAttributed insertAttributedString:foodClassAttributed atIndex:0];
        cell.textLabel.attributedText = [mutNameAttributed copy];
        
        
        // Now we seach through the food's tags and show those that fit
        //      -
        
        // determine which tags fit the search and create the attributed text for those that do
        NSMutableSet *searchTags = [NSMutableSet set];
        for (EDTag *tag in foodForIndexPath.tags) {
            NSRange tagRange = [tag.name rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            if (tagRange.length) {
                
                NSMutableAttributedString *mutTagNameAttributed = [[NSMutableAttributedString alloc] initWithString:tag.name
                                                                                                         attributes:@{ NSFontAttributeName : subtitleLabelFont}];
                //
                [mutTagNameAttributed setAttributes:@{ NSFontAttributeName : subtitleLabelFont, NSBackgroundColorAttributeName : [UIColor yellowColor]} range:tagRange];
                
                [searchTags addObject:[mutTagNameAttributed copy]];
                
                
            }
        }
        
        // now sort the tag names (attributed)
        
        NSArray *sortedTags = [[searchTags allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"string" ascending:YES]]];
        
        NSMutableAttributedString *mutTagTitle = [[NSMutableAttributedString alloc] init];
        NSAttributedString *commaSeperatorAttributed = [[NSAttributedString alloc] initWithString:@", "
                                                                                       attributes:@{ NSFontAttributeName : titleLabelFont}];
        
        for (int i = 0; i < [sortedTags count]; i++) {
            if (i) {
                [mutTagTitle appendAttributedString:commaSeperatorAttributed];
            }
            [mutTagTitle appendAttributedString:sortedTags[i]];
        }
        
        
        
        cell.detailTextLabel.attributedText = [mutTagTitle copy];
    }
    
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableCellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableCellIdentifier];
        }
        
        NSArray *sectionArray = self.browseOptions[indexPath.section];
        cell.textLabel.text = sectionArray[indexPath.row];
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    
    return cell;
}


/*
 // Override to support conditional mhediting of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be mheditable.
 return YES;
 }
 */

/*
 // Override to support mhediting the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)mheditingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (mheditingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (mheditingStyle == UITableViewCellEditingStyleInsert) {
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

// required this because of issues with the index path for searchDisplayController
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    }
    else {
        return 2;
    }
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // There are 2 parameters we need to worry about - self.delegate and self.searchDisplayController
    //      --
    
    if (self.delegate) {
        // if the delegate is set then we either
        // (a) add the meal/ingredient and pop back to the delegate VC
        // (b) pass the delegate to the next VC
        
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            // we want to segue based on the item selected
            // Type = display of food with this type (meals and ingredients)
            // (meal, ingr, medication) = add to meal we want to eat
            // restaurant = meals at restaurant
            
            if (!self.medicationFind) {
                
                if ([self.searchResults[indexPath.row] isKindOfClass:[EDMeal class]]) {
                    [self.delegate addToMealsList:@[self.searchResults[indexPath.row]]];
                    [self popToDelegate];
                }
                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDIngredient class]]) {
                    [self.delegate addToIngredientsList:@[self.searchResults[indexPath.row]]];
                    [self popToDelegate];
                }
                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDType class]]) {
                    // tell next vc to display list of food for the type
                }
                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDRestaurant class]]) {
                    // tell the next vc to display the meals for the restaurant
                }
            }
            
            else if (self.medicationFind) {
                if ([self.searchResults[indexPath.row] isKindOfClass:[EDMedication class]]) {
                    [self.delegate addToMedicationsList:@[self.searchResults[indexPath.row]]];
                    [self popToDelegate];
                }
                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDIngredient class]]) {
                    [self.delegate addToIngredientsList:@[self.searchResults[indexPath.row]]];
                    [self popToDelegate];
                }
                
            }
            
        }
        
        
        else { // if this wasn't a search selection then we display what we selected
            
            [self performSegueWithIdentifier:@"MealSegue" sender:indexPath];
            
        }
    }
    
    
    
    else {
        // if there is no delegate then we either
        // (a) segue to the eatMealVC, passing along the meal/ingredient
        // (b) segue to the next VC, passing the search parameters along
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            // we want to segue based on the item selected
            // Type = display of food with this type (meals and ingredients)
            // (meal, ingr, medication) = add to meal we want to eat
            // restaurant = meals at restaurant
            
            
            if (!self.medicationFind)
            {
                if ([self.searchResults[indexPath.row] isKindOfClass:[EDMeal class]]) {
                    [self performSegueWithIdentifier:@"AddFoodFromSearchSegue" sender:indexPath];
                }
                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDIngredient class]]) {
                    [self performSegueWithIdentifier:@"AddFoodFromSearchSegue" sender:indexPath];
                }
                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDType class]]) {
                }
                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDRestaurant class]]) {
                }
            }
            
            else {
                if ([self.searchResults[indexPath.row] isKindOfClass:[EDMeal class]]) {
                    [self performSegueWithIdentifier:@"AddFoodFromSearchSegue" sender:indexPath];
                }
                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDIngredient class]]) {
                    [self performSegueWithIdentifier:@"AddFoodFromSearchSegue" sender:indexPath];
                }
                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDType class]]) {
                }
                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDRestaurant class]]) {
                }
            }
            
            
        }
        
        else if (indexPath.section == 0) { // then meals section
            [self performSegueWithIdentifier:@"MealSegue" sender:indexPath];
        }
        else if (indexPath.section == 1) { // then ingredients section
            [self performSegueWithIdentifier:@"MealSegue" sender:indexPath];
        }
        else if (indexPath.section == 2) { // then medication section
            [self performSegueWithIdentifier:nil sender:indexPath];
        }
    }
    
    
}



#pragma mark - Storyboard Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"AddFoodFromSearchSegue"]) {
        
        if (!self.medicationFind) {
            EDEatMealViewController *destinationVC = segue.destinationViewController;
            NSIndexPath *index = (NSIndexPath *)sender;
            
            
            if ([self.searchResults[index.row] isKindOfClass:[EDMeal class]]) {
                destinationVC.mealsList = @[self.searchResults[index.row]];
                destinationVC.ingredientsList = @[];
            }
            else if ([self.searchResults[index.row] isKindOfClass:[EDIngredient class]]) {
                destinationVC.ingredientsList = @[self.searchResults[index.row]];
                destinationVC.mealsList = @[];
            }
        }
        
        else {
            
            EDTakeNewMedicationViewController *destinationVC = segue.destinationViewController;
            NSIndexPath *index = (NSIndexPath *)sender;
            
            if ([self.searchResults[index.row] isKindOfClass:[EDMedication class]]) {
                destinationVC.parentMedicationsList = @[self.searchResults[index.row]];
                destinationVC.ingredientsList = @[];
            }
            else if ([self.searchResults[index.row] isKindOfClass:[EDIngredient class]]) {
                destinationVC.ingredientsList = @[self.searchResults[index.row]];
                destinationVC.parentMedicationsList = @[];
            }
            
            destinationVC.restaurant = self.restaurant;
        }
        
    }
    
    
    if ([segue.identifier isEqualToString:@"MealSegue"]) {
        EDAddTableViewController *destinationVC = segue.destinationViewController;
        NSIndexPath *index = (NSIndexPath *)sender;
        
        NSLog(@"index is %ld, %ld",  (long)index.section, (long)index.row);
        
        if (self.delegate) {
            destinationVC.delegate = self.delegate;
        }
        
        if (self.medicationFind) {
            destinationVC.medicationFind = YES;
            NSString *destinationTitle = @"Medication";
            
            if (index.section == 0) { // medication
                
                destinationVC.tableFoodType = MedicationFoodType;
                
                if (index.row == 0) { // recent meals
                    destinationVC.sortBy = ByRecent;
                    destinationTitle = [destinationTitle stringByAppendingString:@" - Recent"];
                }
                
                else if (index.row == 1) { // by favs
                    destinationVC.sortBy = ByFavorite;
                    destinationTitle = [destinationTitle stringByAppendingString:@" - Favorite"];
                    
                }
                
                else if (index.row == 2) { // by Tags
                    destinationVC.sortBy = ByTags;
                    destinationTitle = [destinationTitle stringByAppendingString:@" - Tags"];
                    
                }
                
                else if (index.row == 3) { // by name
                    destinationVC.sortBy = ByName;
                    destinationTitle = [destinationTitle stringByAppendingString:@" - All"];
                    
                }
                
                destinationVC.title = destinationTitle;
                
            }
        }
        
        else {
            destinationVC.medicationFind = NO;
            NSString *destinationTitle = @"Meals";
            
            if (index.section == 0) { // meals
                
                destinationVC.tableFoodType = MealFoodType;
                
                if (index.row == 0) { // recent meals
                    destinationVC.sortBy = ByRecent;
                    destinationTitle = [destinationTitle stringByAppendingString:@" - Recent"];
                    
                }
                
                else if (index.row == 1) { // by Restaurant
                    destinationVC.sortBy = ByRestaurant;
                    destinationTitle = [destinationTitle stringByAppendingString:@" - Restaurant"];
                    
                }
                else if (index.row == 2) { // by fav
                    destinationVC.sortBy = ByFavorite;
                    destinationTitle = [destinationTitle stringByAppendingString:@" - Favorite"];
                    
                }
                
                else if (index.row == 3) { // by tags
                    destinationVC.sortBy = ByTags;
                    destinationTitle = [destinationTitle stringByAppendingString:@" - Tags"];
                    
                }
                else if (index.row == 4) { // by Types
                    destinationVC.sortBy = ByTypes;
                    destinationTitle = [destinationTitle stringByAppendingString:@" - Ingredient Types"];
                }
                else if (index.row == 5) { // by name
                    destinationVC.sortBy = ByName;
                    destinationTitle = [destinationTitle stringByAppendingString:@" - All"];
                    
                }
                
            }
            
            else if (index.section == 1) { // ingredients
                
                destinationVC.tableFoodType = IngredientFoodType;
                destinationTitle = @"Ingredients";
                if (index.row == 0) { // types
                    destinationVC.sortBy = ByTypes;
                    destinationTitle = [destinationTitle stringByAppendingString:@" - Type"];
                    
                }
                else if (index.row == 1) { // by favs
                    destinationVC.sortBy = ByFavorite;
                    destinationTitle = [destinationTitle stringByAppendingString:@" - Favorite"];
                    
                }
                
                else if (index.row == 2) { // by tags
                    destinationVC.sortBy = ByTags;
                    destinationTitle = [destinationTitle stringByAppendingString:@" - Tags"];
                    
                }
                
                else if (index.row == 3) { // by name
                    destinationVC.sortBy = ByName;
                    destinationTitle = [destinationTitle stringByAppendingString:@" - All"];
                    
                }
            }
            
            destinationVC.title = destinationTitle;
        }
    }
    
    
    
    else if ([segue.identifier isEqualToString:nil]) {
        
    }
}

@end
