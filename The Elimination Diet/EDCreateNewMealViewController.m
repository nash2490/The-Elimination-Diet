//
//  EDCreateNewMealViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/8/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDCreateNewMealViewController.h"
#import "EDAddFoodForNewMealViewController.h"
#import "EDSearchToEatViewController.h"

#import "EDTagCell.h"


#import "EDTag+Methods.h"
#import "EDRestaurant+Methods.h"
#import "EDMeal+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDEatenMeal+Methods.h"

#import "EDDocumentHandler.h"

#import "NSString+MHED_EatDate.h"

#import "EDTableComponents.h"

@interface EDCreateNewMealViewController ()

@end

@implementation EDCreateNewMealViewController

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
    
	// Do any additional setup after loading the view.
    
    // Date Setup
    // --------------------------------------
    [self setupDateAndDatePickerCell];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section];

}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    return 20;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [super tableView:tableView titleForHeaderInSection:section];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == edDateCellID)
    {
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
        
    }
    else
    {
        NSDictionary *itemData = self.dataArray[indexPath.section];
        NSString *cellID = itemData[edCellIDKey];
        
        if ([cellID isEqualToString:edRestaurantCellID]) {
            UITableViewCell *cellAtIndexPath = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            cellAtIndexPath.highlighted = YES;
            // perform segue to restaurant vc and pass on the restaurant, mealsList, ingredientsList, and whether this is medication or meal
        }
        
        else if ([cellID isEqualToString:edAddMealsAndIngredientsCellID]) {
            if (indexPath.row == 0) { // then we use the add meals cell
                [self performSegueWithIdentifier:@"AddMoreFoodSegue" sender:self];
            }
            
            
            /* For use with removal later
             
             else if (indexPath.row >=1) { // then we use the detail meals cell
             cell = [tableView dequeueReusableCellWithIdentifier:edDetailMealsAndIngredientsCellID];
             NSInteger foodIndex = indexPath.row - 1;
             
             
             
             if (foodIndex < [self.mealsList count]) {
             EDMeal *mealForIndex = self.mealsList[foodIndex];
             cell.textLabel.text = mealForIndex.name;
             }
             
             else {
             foodIndex -= [self.mealsList count];
             EDIngredient *ingredientForIndex = self.ingredientsList[foodIndex];
             cell.textLabel.text = ingredientForIndex.name;
             }
             
             
             }
             */
            
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    
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


#pragma mark - Storyboard Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"AddMoreFoodSegue"]) {
        EDSearchToEatViewController *destinationVC = segue.destinationViewController;
        destinationVC.delegate = self.delegate;
    }
}











#pragma mark - EDImageAndNameDelegate and Name Helpers-

- (NSString *) defaultTextForNameTextView
{
    self.objectName = [self objectNameAsDefault];
    self.defaultName = YES;
    return [self objectNameForDisplay];
}

- (BOOL) textViewShouldClear
{
    if (self.defaultName) {
        return YES;
    }
    return NO;
}


- (void) setNameAs: (NSString *) newName
{
    if (newName) {
        self.objectName = newName;
        self.defaultName = NO;
    }
}


- (BOOL) textViewShouldBeginEditing
{
    // if the date picker is visible we need to dismiss
    [super displayInlineDatePickerForRowAtIndexPath:[NSIndexPath indexPathForRow:self.datePickerIndexPath.row -1 inSection:0]];
    
    return YES;
}

- (void) textEnter:(UITextView *)textView
{
    [super textEnter:textView];
    
    
}

- (NSString *) eatDateAsString:(NSDate *) date
{
    return [super eatDateAsString:date];
}

- (NSString *) objectNameAsDefault
{
    return [self mealNameAsDefault];
}

- (NSString *) objectNameForDisplay
{
    return [self mealNameForDisplay];
}


#pragma mark - EDCreateNewMealDelegate methods

- (NSArray *) mealsList
{
    if (!_mealsList) {
        _mealsList = [[NSArray alloc] init];
    }
    return _mealsList;
}

- (void) setNewMealsList: (NSArray *) newMealsList
{
    if (newMealsList) {
        self.mealsList = newMealsList;
    }
}

- (void) addToMealsList: (NSArray *) meals
{
    if (meals) {
        self.mealsList = [self.mealsList arrayByAddingObjectsFromArray:meals];
        for (EDTag *tag in [meals[0] tags]) {
            NSLog(@"tag name = %@", tag.name);
        }
    }
}


- (NSArray *) ingredientsList
{
    if (!_ingredientsList) {
        _ingredientsList = [[NSArray alloc] init];
    }
    return _ingredientsList;
}




- (void) setNewIngredientsList: (NSArray *) newIngredientsList
{
    if (newIngredientsList) {
        self.ingredientsList = newIngredientsList;
    }
}




- (void) addToIngredientsList: (NSArray *) ingredients
{
    if (ingredients) {
        self.ingredientsList = [self.ingredientsList arrayByAddingObjectsFromArray:ingredients];
    }
}

- (EDRestaurant *) restaurant
{
    return [super restaurant];
}

- (void) setNewRestaurant: (EDRestaurant *) restaurant
{
    [super setNewRestaurant:restaurant];
}


- (void) addToTagsList:(NSArray *)tags
{
    [super addToTagsList:tags];
}

- (void) setNewTagsList:(NSArray *)newTagsList
{
    [super setNewTagsList:newTagsList];
}

- (UIImage *) objectImage {
    return [super objectImage];
}

- (void) setNewObjectImage:(UIImage *)newObjectImage
{
    [super setNewObjectImage:newObjectImage];
}



#pragma mark - Setup Methods to call in subclass (optional override)

- (void) setupObjectName
{
    [super setupObjectName];
}


#pragma mark - Subclass methods to Override

// override numberOfRows, and most other table delegate and data source methods

- (NSArray *) defaultDataArray
{
    self.date1 = [NSDate date];
    
    NSMutableDictionary *dateDict = [super dateCellDictionary:self.date1];
    
    NSMutableDictionary *nameDict = [super imageAndNameCellDictionary];
    
    NSMutableDictionary *mealAndIngredientsDict = [super mealAndIngredientCellDictionary];
    
    NSMutableDictionary *restaurantDict = [super restaurantCellDictionary];
    
    NSMutableDictionary *tagsDict = [super tagCellDictionary];
    
    return @[dateDict, mealAndIngredientsDict, nameDict, restaurantDict, tagsDict];
}

- (void) handleDoneButton
{
    [super handleMealDoneButton];
}


@end
