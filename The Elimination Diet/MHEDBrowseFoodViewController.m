//
//  MHEDBrowseFoodViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/6/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDBrowseFoodViewController.h"

#import "MHEDFoodSelectionViewController.h"

#import "MHEDMealSummaryViewController.h"

#import "EDRestaurant+Methods.h"
#import "EDFood+Methods.h"
#import "EDTag+Methods.h"
#import "EDType+Methods.h"
#import "EDMeal+Methods.h"
#import "EDEatenMeal+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDMedication+Methods.h"
#import "EDTakenMedication+Methods.h"


static NSString *mhedBackCellIdentifier = @"Back Cell Identifier";
static NSString *mhedTableCellOptionsCell = @"Basic Options Cell";

static NSString *mhedSegueIDFoodSelectionSegue = @"FoodSelectionSegue";
static NSString *mhedSegueIDBrowseFoodSegue = @"Browse Food Segue ID";

static NSString *mhedStoryBoardViewControllerIDBrowseFood = @"Browse Food View Controller";

@interface MHEDBrowseFoodViewController ()

@end

@implementation MHEDBrowseFoodViewController

- (NSArray *) foodOptions
{
    if (!_foodOptions) {
        _foodOptions = @[@"Meals", @"Ingredients", @"Ingredient Types", @"Restaurants"];
    }
    return _foodOptions;
}

- (NSArray *) mealOptions
{
    if (!_mealOptions) {
        _mealOptions = @[@"Recent", @"Restaurants", @"Favorites", @"Tags", @"By Ingredient Types", @"By Name"];
    }
    return _mealOptions;
}

- (NSArray *) ingredientOptions
{
    if (!_ingredientOptions) {
        _ingredientOptions = @[@"By Types", @"Favorites", @"Tags", @"By Name"];
    }
    return _ingredientOptions;
}

- (NSArray *) ingredientTypeOptions
{
    if (!_ingredientTypeOptions) {
        _ingredientTypeOptions = @[];
    }
    return _ingredientTypeOptions;
}

- (NSArray *) restaurantOptions
{
    if (!_restaurantOptions) {
        _restaurantOptions = @[@"Distance", @"Name"];
    }
    return _restaurantOptions;
}


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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:mhedTableCellOptionsCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:mhedBackCellIdentifier];
    
    if (!self.browseOptions) {
        self.browseOptions = self.foodOptions;
    }
    
    if ([self.browseOptions isEqualToArray:self.foodOptions]) {
        self.title = @"Food";
    }
    
    
    
    if (self.navigationController) {
        if ([[self.navigationController viewControllers] count] == 1) { // then this is the only view controller in the stack
            // don't have any bar button items
        }
        else { // there is another vc on the stack before. It is either "Summary" or another browse
            
            NSString *rootVCTitle = [[self.navigationController viewControllers][0] title];
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:rootVCTitle style:UIBarButtonItemStylePlain target:self action:@selector(popToMealSummary:)]];
        }
        
    }
    
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


#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    
    else {
        return 1;
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    
    else if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return tableView.sectionHeaderHeight;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    
    else if (section == 0) {
        header = @"";
    }
    
    else if (section == 1) {
        switch (self.displaySection) {
            case MHEDBrowseFoodSectionsIngredients:
                return @"Ingredients";
                break;
                
            case MHEDBrowseFoodSectionsIngredientTypes:
                return @"Ingredient Types";
                break;
                
            case MHEDBrowseFoodSectionsMeals:
                return @"Meals";
                break;
                
            case MHEDBrowseFoodSectionsRestaurants:
                return @"Restaurant";
                break;
        }
    }
    
//    else {
//        NSString *restaurantName = self.restaurant.name ? [NSString stringWithFormat:@"Meals For %@", self.restaurant.name] : @"Meals";
//        
//        switch (section) {
//            case 0:
//                header = restaurantName;
//                break;
//                
//            case 1:
//                header = @"Ingredients";
//                break;
//                //            case 2:
//                //                header = @"Medication";
//                //                break;
//            default:
//                
//                break;
//        }
//    }
    
    
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
    else if (section == 0) {
        return [self.browseOptions count];
    }
    return 0;
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
    
    
    
//    else if (indexPath.section == 0) {
//        cell = [tableView dequeueReusableCellWithIdentifier:mhedBackCellIdentifier forIndexPath:indexPath];
//        cell.textLabel.text = @" <- Back ";
//    }
    
    else if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellOptionsCell forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mhedTableCellOptionsCell];
        }
        
        cell.textLabel.text = self.browseOptions[indexPath.row];
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    
    return cell;
}



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
            
            
            if ([self.searchResults[indexPath.row] isKindOfClass:[EDMeal class]]) {
                [self.delegate addToMealsList:@[self.searchResults[indexPath.row]]];
                //[self popToDelegate];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else if ([self.searchResults[indexPath.row] isKindOfClass:[EDIngredient class]]) {
                [self.delegate addToIngredientsList:@[self.searchResults[indexPath.row]]];
                //[self popToDelegate];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else if ([self.searchResults[indexPath.row] isKindOfClass:[EDType class]]) {
                // tell next vc to display list of food for the type
            }
            else if ([self.searchResults[indexPath.row] isKindOfClass:[EDRestaurant class]]) {
                // tell the next vc to display the meals for the restaurant
            }
            
            
            
            
//            if (!self.medicationFind) {
//                
//                if ([self.searchResults[indexPath.row] isKindOfClass:[EDMeal class]]) {
//                    [self.delegate addToMealsList:@[self.searchResults[indexPath.row]]];
//                    //[self popToDelegate];
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                }
//                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDIngredient class]]) {
//                    [self.delegate addToIngredientsList:@[self.searchResults[indexPath.row]]];
//                    //[self popToDelegate];
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                }
//                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDType class]]) {
//                    // tell next vc to display list of food for the type
//                }
//                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDRestaurant class]]) {
//                    // tell the next vc to display the meals for the restaurant
//                }
//            }
//            
//            else if (self.medicationFind) {
//                if ([self.searchResults[indexPath.row] isKindOfClass:[EDMedication class]]) {
//                    [self.delegate addToMedicationsList:@[self.searchResults[indexPath.row]]];
//                    [self popToDelegate];
//                }
//                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDIngredient class]]) {
//                    [self.delegate addToIngredientsList:@[self.searchResults[indexPath.row]]];
//                    [self popToDelegate];
//                }
//                
//            }
            
        }
        
        
        else { // if this wasn't a search selection then we display what we selected
            
            if ([self.browseOptions isEqual:self.foodOptions]) {
                //[self performSegueWithIdentifier:mhedSegueIDBrowseFoodSegue sender:indexPath];
                [self pushToAnotherBrowseViewController:indexPath];
            }
            
            else {
                [self performSegueWithIdentifier:mhedSegueIDFoodSelectionSegue sender:indexPath];
            }
        }
    }
    
    
//    
//    else {
//        // if there is no delegate then we either
//        // (a) segue to the eatMealVC, passing along the meal/ingredient
//        // (b) segue to the next VC, passing the search parameters along
//        
//        if (tableView == self.searchDisplayController.searchResultsTableView) {
//            // we want to segue based on the item selected
//            // Type = display of food with this type (meals and ingredients)
//            // (meal, ingr, medication) = add to meal we want to eat
//            // restaurant = meals at restaurant
//            
//            
//            if (!self.medicationFind)
//            {
//                if ([self.searchResults[indexPath.row] isKindOfClass:[EDMeal class]]) {
//                    [self performSegueWithIdentifier:@"AddFoodFromSearchSegue" sender:indexPath];
//                }
//                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDIngredient class]]) {
//                    [self performSegueWithIdentifier:@"AddFoodFromSearchSegue" sender:indexPath];
//                }
//                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDType class]]) {
//                }
//                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDRestaurant class]]) {
//                }
//            }
//            
//            else {
//                if ([self.searchResults[indexPath.row] isKindOfClass:[EDMeal class]]) {
//                    [self performSegueWithIdentifier:@"AddFoodFromSearchSegue" sender:indexPath];
//                }
//                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDIngredient class]]) {
//                    [self performSegueWithIdentifier:@"AddFoodFromSearchSegue" sender:indexPath];
//                }
//                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDType class]]) {
//                }
//                else if ([self.searchResults[indexPath.row] isKindOfClass:[EDRestaurant class]]) {
//                }
//            }
//            
//            
//        }
//        
//        else if (indexPath.section == 0) { // then meals section
//            [self performSegueWithIdentifier:@"MealSegue" sender:indexPath];
//        }
//        else if (indexPath.section == 1) { // then ingredients section
//            [self performSegueWithIdentifier:@"MealSegue" sender:indexPath];
//        }
//        else if (indexPath.section == 2) { // then medication section
//            [self performSegueWithIdentifier:nil sender:indexPath];
//        }
//    }
//    
    
}



#pragma mark - Storyboard Segues and VC transitions
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    

    
    if ([segue.identifier isEqualToString:mhedSegueIDBrowseFoodSegue]) {
        
        MHEDBrowseFoodViewController *destinationVC = segue.destinationViewController;
        NSIndexPath *index = (NSIndexPath *)sender;
        
        NSLog(@"index is %ld, %ld",  (long)index.section, (long)index.row);
        
        if (self.delegate) {
            destinationVC.delegate = self.delegate;
        }
        
        destinationVC.previousBrowseControllerTitle = self.title;
        
        //NSString *destinationTitle = @"Meals";
        
        if (index.row == 0) {
            destinationVC.browseOptions = self.mealOptions;
        }
        else if (index.row == 1) {
            destinationVC.browseOptions = self.ingredientOptions;
        }
        else if (index.row == 2) {
            destinationVC.browseOptions = self.ingredientTypeOptions;
        }
        else if (index.row == 3) {
            destinationVC.browseOptions = self.restaurantOptions;
        }
        
    }
    
    
    else if ([segue.identifier isEqualToString:mhedSegueIDFoodSelectionSegue]) {
        
        NSIndexPath *index = (NSIndexPath *)sender;
        NSLog(@"index is %ld, %ld",  (long)index.section, (long)index.row);
        MHEDFoodSelectionViewController *destinationVC = segue.destinationViewController;
        
        NSString *destinationTitle;
        
        if (self.delegate) {
                destinationVC.delegate = self.delegate;
        }
        
        destinationVC.previousBrowseControllerTitle = self.title;
        
        if ([self.browseOptions isEqual:self.mealOptions]) {
            
            destinationTitle = @"Meals";
            
            destinationVC.tableFoodType = MealFoodType;
            
            if (index.row == 0) { // recent meals
                destinationVC.sortBy = ByRecent;
                //destinationTitle = [destinationTitle stringByAppendingString:@" - Recent"];
                destinationTitle = @"Recent";
            }
            else if (index.row == 1) { // by Restaurant
                destinationVC.sortBy = ByRestaurant;
                //destinationTitle = [destinationTitle stringByAppendingString:@" - Restaurant"];
                destinationTitle = @"Restaurant";
            }
            else if (index.row == 2) { // by fav
                destinationVC.sortBy = ByFavorite;
                //destinationTitle = [destinationTitle stringByAppendingString:@" - Favorite"];
                destinationTitle = @"Favorite";
            }
            
            else if (index.row == 3) { // by tags
                destinationVC.sortBy = ByTags;
                //destinationTitle = [destinationTitle stringByAppendingString:@" - Tags"];
                destinationTitle = @"Tags";
            }
            else if (index.row == 4) { // by Types
                destinationVC.sortBy = ByTypes;
                //destinationTitle = [destinationTitle stringByAppendingString:@" - Ingredient Types"];
                destinationTitle = @"Types";
            }
            else if (index.row == 5) { // by name
                destinationVC.sortBy = ByName;
                //destinationTitle = [destinationTitle stringByAppendingString:@" - All"];
                destinationTitle = @"Name";
            }
            
            
        }
        
        else if ([self.browseOptions isEqual:self.ingredientOptions]) {
         
            destinationTitle = @"Ingredients";
            
            destinationVC.tableFoodType = IngredientFoodType;
            
            if (index.row == 0) { // types
                destinationVC.sortBy = ByTypes;
                //destinationTitle = [destinationTitle stringByAppendingString:@" - Type"];
                destinationTitle = @"Type";
            }
            else if (index.row == 1) { // by favs
                destinationVC.sortBy = ByFavorite;
                //destinationTitle = [destinationTitle stringByAppendingString:@" - Favorite"];
                destinationTitle = @"Favorites";
            }
            
            else if (index.row == 2) { // by tags
                destinationVC.sortBy = ByTags;
                //destinationTitle = [destinationTitle stringByAppendingString:@" - Tags"];
                destinationTitle = @"Tags";
            }
            
            else if (index.row == 3) { // by name
                destinationVC.sortBy = ByName;
                //destinationTitle = [destinationTitle stringByAppendingString:@" - All"];
                destinationTitle = @"Name";
            }
        }
        
        else if ([self.browseOptions isEqual:self.ingredientTypeOptions]) {
            
        }
        
        else if ([self.browseOptions isEqual:self.restaurantOptions]) {
            
        }
        
        
        destinationVC.title = destinationTitle;

    }
    
    
    
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
    
    
//    if ([segue.identifier isEqualToString:@"MealSegue"]) {
//        MHEDFoodSelectionViewController *destinationVC = segue.destinationViewController;
//        NSIndexPath *index = (NSIndexPath *)sender;
//        
//        NSLog(@"index is %ld, %ld",  (long)index.section, (long)index.row);
//        
//        if (self.delegate) {
//            destinationVC.delegate = self.delegate;
//        }
//        
//
//        
//        NSString *destinationTitle = @"Meals";
//        
//        destinationVC.tableFoodType = MealFoodType;
//        
//        if (index.row == 0) { // recent meals
//            destinationVC.sortBy = ByRecent;
//            destinationTitle = [destinationTitle stringByAppendingString:@" - Recent"];
//            
//        }
//        else if (index.row == 1) { // by Restaurant
//            destinationVC.sortBy = ByRestaurant;
//            destinationTitle = [destinationTitle stringByAppendingString:@" - Restaurant"];
//            
//        }
//        else if (index.row == 2) { // by fav
//            destinationVC.sortBy = ByFavorite;
//            destinationTitle = [destinationTitle stringByAppendingString:@" - Favorite"];
//            
//        }
//        
//        else if (index.row == 3) { // by tags
//            destinationVC.sortBy = ByTags;
//            destinationTitle = [destinationTitle stringByAppendingString:@" - Tags"];
//            
//        }
//        else if (index.row == 4) { // by Types
//            destinationVC.sortBy = ByTypes;
//            destinationTitle = [destinationTitle stringByAppendingString:@" - Ingredient Types"];
//        }
//        else if (index.row == 5) { // by name
//            destinationVC.sortBy = ByName;
//            destinationTitle = [destinationTitle stringByAppendingString:@" - All"];
//            
//        }
//        
//            
//            destinationVC.title = destinationTitle;
//        
//    }
//    
//    else if ([segue.identifier isEqualToString:@"Ingredient Segue"]) {
//        
//        MHEDFoodSelectionViewController *destinationVC = segue.destinationViewController;
//        NSIndexPath *index = (NSIndexPath *)sender;
//        
//        NSLog(@"index is %ld, %ld",  (long)index.section, (long)index.row);
//        
//        if (self.delegate) {
//            destinationVC.delegate = self.delegate;
//        }
//        
//        
//        NSString *destinationTitle = @"Ingredients";
//            
//        destinationVC.tableFoodType = IngredientFoodType;
//
//        if (index.row == 0) { // types
//            destinationVC.sortBy = ByTypes;
//            destinationTitle = [destinationTitle stringByAppendingString:@" - Type"];
//            
//        }
//        else if (index.row == 1) { // by favs
//            destinationVC.sortBy = ByFavorite;
//            destinationTitle = [destinationTitle stringByAppendingString:@" - Favorite"];
//            
//        }
//        
//        else if (index.row == 2) { // by tags
//            destinationVC.sortBy = ByTags;
//            destinationTitle = [destinationTitle stringByAppendingString:@" - Tags"];
//            
//        }
//        
//        else if (index.row == 3) { // by name
//            destinationVC.sortBy = ByName;
//            destinationTitle = [destinationTitle stringByAppendingString:@" - All"];
//            
//        }
//    }
//    
    
    
    
    
//    
//    else if ([segue.identifier isEqualToString:nil]) {
//        
//    }
    
    
}


- (void) pushToAnotherBrowseViewController:(NSIndexPath *) indexPath
{
    MHEDBrowseFoodViewController *destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDBrowseFood];
    
    NSLog(@"index is %ld, %ld",  (long)indexPath.section, (long)indexPath.row);
    
    if (self.delegate) {
        destinationVC.delegate = self.delegate;
    }
    
    destinationVC.previousBrowseControllerTitle = self.title;
    
    NSString *destinationTitle = @"";
    
    if (indexPath.row == 0) {
        destinationVC.browseOptions = self.mealOptions;
        destinationTitle = @"Meals";
    }
    else if (indexPath.row == 1) {
        destinationVC.browseOptions = self.ingredientOptions;
        destinationTitle = @"Ingredients";
    }
    else if (indexPath.row == 2) {
        destinationVC.browseOptions = self.ingredientTypeOptions;
        destinationTitle = @"Types";
    }
    else if (indexPath.row == 3) {
        destinationVC.browseOptions = self.restaurantOptions;
        destinationTitle = @"Restaurant";
    }
    
    destinationVC.title = destinationTitle;
    
    [self.navigationController pushViewController:destinationVC animated:YES];
}


- (void) popToMealSummary: (id) sender
{
    
    // if the root vc is summary view then pop to it
    if ([[self.navigationController viewControllers][0] isKindOfClass:[MHEDMealSummaryViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    // otherwise the summary view is the second
    else {
        [self.navigationController popToViewController:[self.navigationController viewControllers][1] animated:YES];
    }
}


@end
