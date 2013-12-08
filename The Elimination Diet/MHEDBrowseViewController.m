//
//  MHEDBrowseFoodViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/5/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDBrowseViewController.h"

#import "EDTableComponents.h"

#import "EDAddTableViewController.h"

#import "EDEliminatedAPI.h"
#import "EDEliminatedAPI+Searching.h"

#import "EDMeal+Methods.h"
#import "EDRestaurant+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDType+Methods.h"
#import "EDTag+Methods.h"
#import "EDMedication+Methods.h"
#import "EDSymptom+Methods.h"


@interface MHEDBrowseViewController ()
@end



@implementation MHEDBrowseViewController


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
    
    self.searchBar.delegate = self;
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
        return [self.browseOptions count];
    }
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    
    else {
        return nil;
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
        else if ([self.searchResults[indexPath.row] isKindOfClass:[EDSymptom class]]) {
            foodClass = @"(symptom) ";
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

//- (void) popToDelegate
//{
//    CGRect addMealFrame = self.view.frame;
//    addMealFrame.origin.x = -addMealFrame.size.width;
//    
//    CGRect eatMealFrame = self.view.frame;
//    
//    /*
//     [UIView animateWithDuration:0.75
//     animations:^{
//     
//     [UIView setAnimationDuration:0.5];
//     [UIView setAnimationDelay:0.0];
//     [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//     
//     self.navigationController.view.frame = addMealFrame;
//     [self.navigationController popToViewController:(UIViewController *)self.delegate animated:NO];
//     
//     // [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
//     }];
//     
//     */
//    [UIView animateWithDuration:.5
//                     animations:^{
//                         [UIView setAnimationDuration:0.5];
//                         [UIView setAnimationDelay:0.0];
//                         [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//                         
//                         self.navigationController.view.frame = addMealFrame;
//                         //[self.navigationController popToViewController:(UIViewController *)self.delegate animated:NO];
//                         // [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
//                         
//                     } completion:^(BOOL finished) {
//                         self.navigationController.view.frame = eatMealFrame;
//                         [self.navigationController popToViewController:(UIViewController *)self.delegate animated:NO];
//                         
//                     }];
//}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        // we want to segue based on the item selected
        // Type = display of food with this type (meals and ingredients)
        // (meal, ingr, medication) = add to meal we want to eat
        // restaurant = meals at restaurant
        
       
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


//#pragma mark - Storyboard Segues
//- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//
//    if ([segue.identifier isEqualToString:@"AddFoodFromSearchSegue"]) {
//        
//        if (!self.medicationFind) {
//            EDEatMealViewController *destinationVC = segue.destinationViewController;
//            NSIndexPath *index = (NSIndexPath *)sender;
//            
//            
//            if ([self.searchResults[index.row] isKindOfClass:[EDMeal class]]) {
//                destinationVC.mealsList = @[self.searchResults[index.row]];
//                destinationVC.ingredientsList = @[];
//            }
//            else if ([self.searchResults[index.row] isKindOfClass:[EDIngredient class]]) {
//                destinationVC.ingredientsList = @[self.searchResults[index.row]];
//                destinationVC.mealsList = @[];
//            }
//        }
//        
//        else {
//            
//            EDTakeNewMedicationViewController *destinationVC = segue.destinationViewController;
//            NSIndexPath *index = (NSIndexPath *)sender;
//            
//            if ([self.searchResults[index.row] isKindOfClass:[EDMedication class]]) {
//                destinationVC.parentMedicationsList = @[self.searchResults[index.row]];
//                destinationVC.ingredientsList = @[];
//            }
//            else if ([self.searchResults[index.row] isKindOfClass:[EDIngredient class]]) {
//                destinationVC.ingredientsList = @[self.searchResults[index.row]];
//                destinationVC.parentMedicationsList = @[];
//            }
//            
//            destinationVC.restaurant = self.restaurant;
//        }
//        
//    }
//    
//    
//    if ([segue.identifier isEqualToString:@"MealSegue"]) {
//        EDAddTableViewController *destinationVC = segue.destinationViewController;
//        NSIndexPath *index = (NSIndexPath *)sender;
//        
//        NSLog(@"index is %ld, %ld",  (long)index.section, (long)index.row);
//        
//        if (self.delegate) {
//            destinationVC.delegate = self.delegate;
//        }
//        
//        if (self.medicationFind) {
//            destinationVC.medicationFind = YES;
//            NSString *destinationTitle = @"Medication";
//            
//            if (index.section == 0) { // medication
//                
//                destinationVC.tableFoodType = MedicationFoodType;
//                
//                if (index.row == 0) { // recent meals
//                    destinationVC.sortBy = ByRecent;
//                    destinationTitle = [destinationTitle stringByAppendingString:@" - Recent"];
//                }
//                
//                else if (index.row == 1) { // by favs
//                    destinationVC.sortBy = ByFavorite;
//                    destinationTitle = [destinationTitle stringByAppendingString:@" - Favorite"];
//                    
//                }
//                
//                else if (index.row == 2) { // by Tags
//                    destinationVC.sortBy = ByTags;
//                    destinationTitle = [destinationTitle stringByAppendingString:@" - Tags"];
//                    
//                }
//                
//                else if (index.row == 3) { // by name
//                    destinationVC.sortBy = ByName;
//                    destinationTitle = [destinationTitle stringByAppendingString:@" - All"];
//                    
//                }
//                
//                destinationVC.title = destinationTitle;
//                
//            }
//        }
//        
//        else {
//            destinationVC.medicationFind = NO;
//            NSString *destinationTitle = @"Meals";
//            
//            if (index.section == 0) { // meals
//                
//                destinationVC.tableFoodType = MealFoodType;
//                
//                if (index.row == 0) { // recent meals
//                    destinationVC.sortBy = ByRecent;
//                    destinationTitle = [destinationTitle stringByAppendingString:@" - Recent"];
//                    
//                }
//                
//                else if (index.row == 1) { // by Restaurant
//                    destinationVC.sortBy = ByRestaurant;
//                    destinationTitle = [destinationTitle stringByAppendingString:@" - Restaurant"];
//                    
//                }
//                else if (index.row == 2) { // by fav
//                    destinationVC.sortBy = ByFavorite;
//                    destinationTitle = [destinationTitle stringByAppendingString:@" - Favorite"];
//                    
//                }
//                
//                else if (index.row == 3) { // by tags
//                    destinationVC.sortBy = ByTags;
//                    destinationTitle = [destinationTitle stringByAppendingString:@" - Tags"];
//                    
//                }
//                else if (index.row == 4) { // by Types
//                    destinationVC.sortBy = ByTypes;
//                    destinationTitle = [destinationTitle stringByAppendingString:@" - Ingredient Types"];
//                }
//                else if (index.row == 5) { // by name
//                    destinationVC.sortBy = ByName;
//                    destinationTitle = [destinationTitle stringByAppendingString:@" - All"];
//                    
//                }
//                
//            }
//            
//            else if (index.section == 1) { // ingredients
//                
//                destinationVC.tableFoodType = IngredientFoodType;
//                destinationTitle = @"Ingredients";
//                if (index.row == 0) { // types
//                    destinationVC.sortBy = ByTypes;
//                    destinationTitle = [destinationTitle stringByAppendingString:@" - Type"];
//                    
//                }
//                else if (index.row == 1) { // by favs
//                    destinationVC.sortBy = ByFavorite;
//                    destinationTitle = [destinationTitle stringByAppendingString:@" - Favorite"];
//                    
//                }
//                
//                else if (index.row == 2) { // by tags
//                    destinationVC.sortBy = ByTags;
//                    destinationTitle = [destinationTitle stringByAppendingString:@" - Tags"];
//                    
//                }
//                
//                else if (index.row == 3) { // by name
//                    destinationVC.sortBy = ByName;
//                    destinationTitle = [destinationTitle stringByAppendingString:@" - All"];
//                    
//                }
//            }
//            
//            destinationVC.title = destinationTitle;
//        }
//    }
//    
//    
//    
//    else if ([segue.identifier isEqualToString:nil]) {
//        
//    }
//}


#pragma mark - UISearchBarDelegate and Helper methods -

// helper method
- (void) performSearchForText: (NSString *) text
{
    self.searchResults = [EDEliminatedAPI searchResultsForString:text inScope:self.searchScope];
}


- (void) updateSearchResults
{
    [self performSearchForText:self.searchBar.text];
}


// Editing Text
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // -search as the user types and shows a list
    
    // searches through tags, food names (meals, ingredients, types, restaurants),
    
    [self performSearchForText:searchText];
    
}

- (BOOL) searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // Just returns yes for now
    return YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // show scope bar
    self.searchBar.showsScopeBar = YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
}

// Clicking Buttons
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchResults = @[];
    self.searchBar.showsScopeBar = FALSE;
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // perform the search and display the results
}


// Scope Button
- (void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    // changes the objects fetched by the search of the selected scope
    
    switch (selectedScope) {
        case 0: // all
            self.searchScope = MHEDSearchBarScopeFoodAll;
            break;
            
        case 1: // meals
            self.searchScope = MHEDSearchBarScopeFoodMeals;
            break;
            
        case 2: // ingredients
            self.searchScope = MHEDSearchBarScopeFoodIngredients;
            break;
            
        case 3: // medication
            self.searchScope = MHEDSearchBarScopeFoodMedication;
            break;
            
        default:
            self.searchScope = MHEDSearchBarScopeFoodAll;
            break;
    }
    
    [self updateSearchResults];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    return YES;
}

@end
