//
//  EDTakeNewMedicationViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/29/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDTakeNewMedicationViewController.h"

#import "EDSearchToEatViewController.h"

#import "EDMeal+Methods.h"
#import "EDIngredient+Methods.h"

#import "EDTableComponents.h"

@interface EDTakeNewMedicationViewController ()

@end

@implementation EDTakeNewMedicationViewController

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
    
    self.title = @"Take Medication";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Table view data source and Delegate

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
    if (cell.reuseIdentifier == mhedDateCellID)
    {
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
        
    }
    else
    {
        NSDictionary *itemData = self.dataArray[indexPath.section];
        NSString *cellID = itemData[mhedCellIDKey];
        
        if ([cellID isEqualToString:mhedRestaurantCellID]) {
            UITableViewCell *cellAtIndexPath = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            cellAtIndexPath.highlighted = YES;
            // perform segue to restaurant vc and pass on the restaurant, mealsList, ingredientsList, and whether this is medication or meal
        }
        
        else if ([cellID isEqualToString:mhedAddMedsAndIngredientsCellID]) {
            if (indexPath.row == 0) { // then we use the add meals cell
                [self performSegueWithIdentifier:@"AddMoreMedicationSegue" sender:self];
            }
            
            
            /* For use with removal later
             
             else if (indexPath.row >=1) { // then we use the detail meals cell
             cell = [tableView dequeueReusableCellWithIdentifier:mhedDetailMealsAndIngredientsCellID];
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

#pragma mark - Storyboard Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"AddMoreMedicationSegue"]) {
        EDSearchToEatViewController *destinationVC = segue.destinationViewController;
        destinationVC.delegate = self.delegate;
        destinationVC.medicationFind = YES;
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
    return [super textViewShouldBeginEditing];
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
    return [self medNameAsDefault];
}

- (NSString *) objectNameForDisplay
{
    return [self medNameForDisplay];
}




#pragma mark - EDCreateNewMealDelegate methods

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


- (NSArray *) tagsList
{
    return [super tagsList];
}

- (void) addToTagsList:(NSArray *)tags
{
    [super addToTagsList:tags];
}

- (void) setNewTagsList:(NSArray *)newTagsList
{
    [super setNewTagsList:newTagsList];
}


- (NSArray *) parentMedicationsList
{
    if (!_parentMedicationsList) {
        _parentMedicationsList = [[NSArray alloc] init];
    }
    return _parentMedicationsList;
}

- (void) setNewMedicationsList:(NSArray *)newMedicationsList
{
    if (newMedicationsList) {
        self.parentMedicationsList = newMedicationsList;
    }
}

- (void) addToMedicationsList:(NSArray *)medications
{
    if (medications) {
        self.parentMedicationsList = [self.parentMedicationsList arrayByAddingObjectsFromArray:medications];
    }
}

- (UIImage *) objectImage {
    return [super objectImage];
}

- (void) setNewObjectImage:(UIImage *)newObjectImage
{
    [super setNewObjectImage:newObjectImage];
}



#pragma mark - Setup Methods to call in subclass (optional override)

- (void) setupDateAndDatePickerCell
{
    [super setupDateAndDatePickerCell];
}

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
    
    NSMutableDictionary *medsAndIngredientsDict = [super medAndIngredientCellDictionary];
    
    NSMutableDictionary *restaurantDict = [super restaurantCellDictionary];
    
    NSMutableDictionary *tagsDict = [super tagCellDictionary];
    
    
    
    return @[dateDict, medsAndIngredientsDict, nameDict, restaurantDict, tagsDict];
}

- (void) handleDoneButton
{
    [super handleMedDoneButton];
}

- (void) nameTextViewEditable: (UITextView *) textView
{
    [super medNameTextViewEditable:textView];
}

@end
