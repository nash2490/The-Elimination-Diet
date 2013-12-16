//
//  MHEDSelectionViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/11/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDFoodSelectionViewController.h"

//#import "EDEatNewMealViewController.h"
//#import "EDTakeNewMedicationViewController.h"

#import "MHEDMealSummaryViewController.h"

#import "EDEliminatedAPI+Fetching.h"
#import "EDEliminatedAPI+Helpers.h"
#import "EDEliminatedAPI+Sorting.h"

#import "EDMeal+Methods.h"
#import "EDEatenMeal+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDType+Methods.h"
#import "EDTag+Methods.h"
#import "EDEliminatedFood+Meals.h"

#import "EDMedication+Methods.h"
#import "EDTakenMedication+Methods.h"

//#define MEAL_TABLECELL @"EDMeal Table Cell"
//#define MEDICATION_DOSAGE_TABLECELL @"EDMedicationDosage Table Cell"
//#define MEDICATION__TABLECELL @"EDMedication Table Cell"
//#define INGREDIENT_TABLECELL @"EDIngredient Table Cell"


static NSString *mhedBackCellIdentifier = @"Back Cell Identifier";

static NSString *mhedTableCellOptionsCell = @"Basic Options Cell";
static NSString *mhedTableCellMealCell = @"Meal Table Cell";
static NSString *mhedTableCellMedicationCell = @"Medication Table Cell";
static NSString *mhedTableCellIngredientCell = @"Ingredient Table Cell";


@interface MHEDFoodSelectionViewController ()
@property (nonatomic, strong) id selectedObject;

@end

@implementation MHEDFoodSelectionViewController






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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:mhedBackCellIdentifier];
    
    
    if (self.navigationController) {
        
        if ([[self.navigationController viewControllers] count] > 1) {
            
            if ([[self.navigationController viewControllers][1] isKindOfClass:[MHEDMealSummaryViewController class]])
            {
                [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Summary" style:UIBarButtonItemStylePlain target:self action:@selector(popToMealSummary:)]];
                
            }
            
            else {// It is either "Summary" or another browse
                
                NSString *rootVCTitle = [[self.navigationController viewControllers][0] title];
                [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:rootVCTitle style:UIBarButtonItemStylePlain target:self action:@selector(popToMealSummary:)]];
            
            }
        }
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) popToMealSummary: (id) sender
{
    if ([[self.navigationController viewControllers] count] > 1) {
        // if the 2nd vc is the summary then we want to go there
        if ([[self.navigationController viewControllers][1] isKindOfClass:[MHEDMealSummaryViewController class]]) {
            [self.navigationController popToViewController:[self.navigationController viewControllers][1] animated:YES];
            
        }
        
        // otherwise we want the first
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }
    
    // otherwise this is the only vc on the stack, so we don't want to do anything
    
}




- (void) viewWillAppear:(BOOL)animated
{
    if (self.sortBy == ByTags) {
        self.populatedTableUsingFRC = NO;
        self.customSectionOrdering = NO;
    }
    
    else if (self.sortBy == ByTypes) {
        self.populatedTableUsingFRC = NO;
    }
    
    else if (self.sortBy == ByParentFood) {
        self.populatedTableUsingFRC = NO;
        
    }
    
    if (self.delegate) {
        
//        self.restaurant = [self.delegate restaurant];
//        self.ingredientsList = [self.delegate ingredientsList];
//        
//        if (!self.medicationFind) {
//            self.mealsList = [self.delegate mealsList];
//        }
//        else {
//            self.medicationList = [self.delegate parentMedicationsList];
//        }
        
        NSLog(@"delegate was set --------------------------------------------------------------------");
    }
    
    [super viewWillAppear:animated];
    
    [self setSuspendAutomaticTrackingOfChangesInManagedObjectContext:NO];
    
    
    //    if (self.tableFoodType == IngredientFoodType) {
    //        self.title = @"Ingredients";
    //    }
    //    else if (self.tableFoodType == MealFoodType) {
    //        self.title = @"Meals";
    //    }
    //
    //    else if (self.tableFoodType == MedicationFoodType) {
    //        self.title = @"Medication";
    //    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setSuspendAutomaticTrackingOfChangesInManagedObjectContext:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Default Fetch Request and FetchedResultsController


- (NSFetchedResultsController *) defaultFetchedRequestController:(NSManagedObjectContext *)managedObjectContext
{
    if (!self.fetchRequest) {
        self.fetchRequest = [self defaultFetchRequest];
    }
    
    NSString *sortByMethod;
    
    
    if (self.tableFoodType == MealFoodType) {
        if (self.sortBy == ByRestaurant) {
            sortByMethod = @"name";
        }
        
        else if (self.sortBy == ByName) {
            sortByMethod = @"nameFirstLetter";
        }
        
        else if (self.sortBy == ByTypes) {
            sortByMethod = @"name";
        }
        
        else if (self.sortBy == ByTags) {
            sortByMethod = @"name";
        }
        
        else if (self.sortBy == ByFavorite) {
            sortByMethod = @"nameFirstLetter";
        }
        
        else if (self.sortBy == ByRecent) {
            sortByMethod = @"eventDayString";
        }
        
        else {
            sortByMethod = @"nameFirstLetter";
        }
    }
    
    else if (self.tableFoodType == IngredientFoodType) {
        
        if (self.sortBy == ByName) {
            sortByMethod = @"nameFirstLetter";
        }
        
        else if (self.sortBy == ByTypes) {
            sortByMethod = @"name";
        }
        
        else if (self.sortBy == ByTags) {
            sortByMethod = @"name";
        }
        
        else if (self.sortBy == ByFavorite) {
            sortByMethod = @"nameFirstLetter";
        }
        
        
        else {
            sortByMethod = @"nameFirstLetter";
        }
    }
    
    else if (self.tableFoodType == MedicationFoodType) {
        
        if (self.sortBy == ByRecent) {
            sortByMethod = @"eventDayString";
        }
        else if (self.sortBy == ByTags) {
            sortByMethod = @"name";
        }
        
        else if (self.sortBy == ByFavorite) {
            sortByMethod = @"nameFirstLetter";
        }
        
        
        else {
            sortByMethod = @"nameFirstLetter";
        }
    }
    
    else {
        sortByMethod = @"nameFirstLetter";
    }
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                               managedObjectContext:managedObjectContext
                                                 sectionNameKeyPath:sortByMethod
                                                          cacheName:nil];
}

- (NSFetchRequest *)defaultFetchRequest
{
    
    if (self.tableFoodType == MealFoodType) {
        if (self.sortBy == ByRestaurant) {
            // this is an instance of the restaurant list/search
            
            // for now just return meals
            return [EDMeal fetchOnlyMeals];
        }
        
        else if (self.sortBy == ByName) {
            return [EDMeal fetchOnlyMeals];
        }
        
        else if (self.sortBy == ByTypes) {
            return  [EDType fetchAllTypes];
        }
        
        else if (self.sortBy == ByFavorite) {
            return  [EDMeal fetchFavoriteMealsNonMedication];
        }
        
        else if (self.sortBy == ByTags) {
            return [EDTag fetchAllTags];
        }
        
        else if (self.sortBy == ByRecent) {
            return [EDEatenMeal fetchEatenMealsForLastWeekWithMedication:NO];
        }
        
        else {
            return [EDMeal fetchOnlyMeals];
        }
    }
    
    else if (self.tableFoodType == IngredientFoodType) {
        
        if (self.sortBy == ByName) {
            return [EDIngredient fetchAllIngredients];
        }
        
        else if (self.sortBy == ByTypes) {
            return  [EDType fetchAllTypes];
        }
        
        else if (self.sortBy == ByFavorite) {
            return  [EDFood fetchFavoriteObjectsForEntityName:INGREDIENT_ENTITY_NAME];
        }
        
        else if (self.sortBy == ByTags) {
            return  [EDTag fetchAllTags];
        }
        
        else {
            return [EDIngredient fetchAllIngredients];
        }
    }
    
    else if (self.tableFoodType == MedicationFoodType) {
        
        if (self.sortBy == ByRecent) {
            return [EDTakenMedication fetchAllTakenMedication]; // goes to med doses
        }
        
        else if (self.sortBy == ByFavorite) {
            return  [EDMedication fetchFavoriteMedication];
        }
        
        else if (self.sortBy == ByTags) {
            return  [EDTag fetchAllTags]; // to display meds and med doses
        }
        
        return [EDMedication fetchAllMedication]; // by name is medication
    }
    
    else {
        return [EDMeal fetchOnlyMeals];
    }
}


#pragma mark - Table View Controller Delegate and Data Source -

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    // add extra section for navigation
    return [super numberOfSectionsInTableView:tableView];
    
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    return [super tableView:tableView titleForHeaderInSection:section];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return [super tableView:tableView heightForHeaderInSection:section];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if (self.sortBy == ByFavoriteAndTags) {
    //        EDTag *tag = [self.fetchedResultsController.fetchedObjects objectAtIndex:section];
    //        NSSet *foodWithTag = tag.foodWithTag;
    //        NSInteger numberOfMealsWithTag = 0;
    //        for (EDMeal *meal in foodWithTag) {
    //            numberOfMealsWithTag++;
    //        }
    //        return numberOfMealsWithTag;
    //    }
    
    
//    if (section == 0) {
//        return 1;
//    }
//    
//    else { // need to adjust the section to account for nav section
//        adjustedSection--;
//    }
    
    if (self.sortBy == ByTags) {
        NSInteger originalSection = section;
        if (self.customSectionOrdering) {
            originalSection = [[self mhedSections][section] integerValue];
        }
        EDTag *tagForSection = self.fetchedResultsController.fetchedObjects[originalSection];
        
        NSFetchRequest *fetchObjectsForTag = nil;
        
        if (self.tableFoodType == MealFoodType) {
            fetchObjectsForTag = [EDFood fetchObjectsForEntityName:MEAL_ENTITY_NAME Tags:[NSSet setWithObject:tagForSection]];
            fetchObjectsForTag.includesSubentities = NO;
        }
        
        else if (self.tableFoodType == IngredientFoodType) {
            fetchObjectsForTag = [EDFood fetchObjectsForEntityName:INGREDIENT_ENTITY_NAME Tags:[NSSet setWithObject:tagForSection]];
        }
        else if (self.tableFoodType == MedicationFoodType) {
            
            fetchObjectsForTag = [EDFood fetchObjectsForEntityName:MEDICATION_ENTITY_NAME Tags:[NSSet setWithObject:tagForSection]];
            
            
        }
        
        //        else if (self.tableFoodType == MedicationDoseFoodType) {
        //            fetchObjectsForTag = [EDFood fetchObjectsForEntityName:MEDICATION_DOSE_ENTITY_NAME Tags:[NSSet setWithObject:tagForSection]];
        //        }
        
        // fetchMealsForTags.fetchOffset = indexPath.row; // we don't want the first indexPath.row meals
        // fetchMealsForTags.fetchLimit = 1; // we only want 1 object
        
        // the number of tags
        NSUInteger numberOfObjectsForTags = [self.managedObjectContext countForFetchRequest:fetchObjectsForTag error:nil];
        
        return (NSInteger)numberOfObjectsForTags;
    }
    
    else if (self.sortBy == ByTypes) {
        EDType *typeForSection = self.fetchedResultsController.fetchedObjects[section];
        
        if (self.tableFoodType == MealFoodType) {
            NSSet *mealsForTypes = [typeForSection determineMeals];
            
            return [mealsForTypes count];
        }
        
        else if (self.tableFoodType == IngredientFoodType) {
            NSMutableSet *ingrForTypes = [typeForSection.ingredientsPrimary mutableCopy];
            NSSet *secondary = [typeForSection determineIngredientsSecondary];
            [ingrForTypes unionSet:secondary];
            return [ingrForTypes count];
        }
        
        else {
            return 0;
        }
    }
    
    else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"";
    NSString *cellTitle = @"";
    NSString *detailText = @"";
    
    UITableViewCell *cell = nil;
    
//    if (indexPath.section == 0) {
//        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mhedBackCellIdentifier forIndexPath:indexPath];
//        cell.textLabel.text = @" <- Back ";
//    }
//    
//    else {
//        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section -1];
//    }
//    
    if (self.tableFoodType == MealFoodType) {
        
        EDMeal *mealForIndexPath = [self mhedObjectAtIndexPath:indexPath];

        cellIdentifier = mhedTableCellMealCell;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cellTitle = mealForIndexPath.name;
        
        NSString *tagsDescription = @"";
        for (EDTag *tag in mealForIndexPath.tags) {
            tagsDescription = [tagsDescription stringByAppendingString:@", "];
            tagsDescription = [tagsDescription stringByAppendingString:tag.name];
        }
        
        detailText = tagsDescription;
        
        if ([[self.delegate objectsDictionary] doesMealsListContainMeals:@[mealForIndexPath]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        //cell.accessoryType = [self.delegate doesMealsListContainMeals:@[mealForIndexPath]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    }
    else if (self.tableFoodType == IngredientFoodType) {
        
        EDIngredient *ingredientForIndexPath = [self mhedObjectAtIndexPath:indexPath];
        
        cellIdentifier = mhedTableCellIngredientCell;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cellTitle = ingredientForIndexPath.name;
        
        NSString *tagsDescription = @"";
        for (EDTag *tag in ingredientForIndexPath.tags) {
            tagsDescription = [tagsDescription stringByAppendingString:@", "];
            tagsDescription = [tagsDescription stringByAppendingString:tag.name];
        }
        detailText = tagsDescription;
        
        
        
        cell.accessoryType = [[self.delegate objectsDictionary] doesIngredientsListContainIngredients:@[ingredientForIndexPath]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    }
    
    else if (self.tableFoodType == MedicationFoodType) {
        EDMedication *medForIndexPath = [self mhedObjectAtIndexPath:indexPath];

        cellIdentifier = mhedTableCellMedicationCell;

        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        
        
        cellTitle = medForIndexPath.name;
        
        NSString *tagsDescription = @"";
        for (EDTag *tag in medForIndexPath.tags) {
            tagsDescription = [tagsDescription stringByAppendingString:@", "];
            tagsDescription = [tagsDescription stringByAppendingString:tag.name];
        }
        detailText = tagsDescription;
        
        
        cell.accessoryType = [[self.delegate objectsDictionary] doesMedicationsListContainMedications:@[medForIndexPath]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
    }
    
    
    
    cell.textLabel.text = cellTitle;
    cell.detailTextLabel.text = detailText;
    
    return cell;
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.selectedObject = [self mhedObjectAtIndexPath:indexPath];
    
    if (self.delegate) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (self.tableFoodType == MealFoodType) {
            
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [[self.delegate objectsDictionary] removeMealsFromMealsList:@[self.selectedObject]];
            }
            
            else {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [[self.delegate objectsDictionary] addToMealsList:@[self.selectedObject]];
            }
            
            //                if ([self.delegate doesMealsListContainMeals:@[self.selectedObject]]) {
            //                    [self.delegate addToMealsList:@[self.selectedObject]];
            //                }
            
        }
        
        else if (self.tableFoodType == IngredientFoodType) {
            
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [[self.delegate objectsDictionary]  removeIngredientsFromIngredientsList:@[self.selectedObject]];
            }
            
            else {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [[self.delegate objectsDictionary]  addToIngredientsList:@[self.selectedObject]];
            }
            
            
        }
        
        else if (self.tableFoodType == MedicationFoodType) {
            
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [[self.delegate objectsDictionary] removeMedicationsFromMedicationsList:@[self.selectedObject]];
            }
            
            else {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [[self.delegate objectsDictionary] addToMedicationsList:@[self.selectedObject]];
            }
        }
    }
    
    
    
    
        
        
//        NSIndexPath *adjustedIndexPath = indexPath;
    
//    if (adjustedIndexPath.section == 0) {
//        if (adjustedIndexPath.row == 0) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
    
   // else {
        // adjust section to take into account the nav section
        //adjustedIndexPath = [NSIndexPath indexPathForRow:adjustedIndexPath.row inSection:adjustedIndexPath.section -1];
        

            
            
            
            
            
            // Pop back to the delegate
            
//            CGRect addMealFrame = self.view.frame;
//            addMealFrame.origin.x = -addMealFrame.size.width;
//            
//            CGRect eatMealFrame = self.view.frame;
//            
//            /*
//             [UIView animateWithDuration:0.75
//             animations:^{
//             
//             [UIView setAnimationDuration:0.5];
//             [UIView setAnimationDelay:0.0];
//             [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//             
//             self.navigationController.view.frame = addMealFrame;
//             [self.navigationController popToViewController:(UIViewController *)self.delegate animated:NO];
//             
//             // [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
//             }];
//             
//             */
//            [UIView animateWithDuration:.5
//                             animations:^{
//                                 [UIView setAnimationDuration:0.5];
//                                 [UIView setAnimationDelay:0.0];
//                                 [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//                                 
//                                 self.navigationController.view.frame = addMealFrame;
//                                 //[self.navigationController popToViewController:(UIViewController *)self.delegate animated:NO];
//                                 // [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
//                                 
//                             } completion:^(BOOL finished) {
//                                 self.navigationController.view.frame = eatMealFrame;
//                                 [self.navigationController popToViewController:(UIViewController *)self.delegate animated:NO];
//                                 
//                             }];
//        }
        
        
//        else { // there is no delegate so we just segue or push
//            
//            if (!self.medicationFind) {
//                [self performSegueWithIdentifier:@"EatMealSegue" sender:self];
//            }
//            
//            
//            else {
//                
//                [self performSegueWithIdentifier:@"TakeMedicationSegue" sender:self];
//                
//            }
//            
//        }
//    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Storyboard Segues and View Controller Pushes/Pops
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
//    
//    
//    
//    if ([segue.identifier isEqualToString:@"EatMealSegue"])
//    {
//        EDEatNewMealViewController *destinationVC = segue.destinationViewController;
//        
//        if (self.selectedObject) {
//            
//            if (self.tableFoodType == MealFoodType) {
//                destinationVC.mealsList = [destinationVC.mealsList arrayByAddingObject:self.selectedObject];
//                destinationVC.ingredientsList = self.ingredientsList;
//            }
//            else if (self.tableFoodType == IngredientFoodType) {
//                destinationVC.ingredientsList = [destinationVC.ingredientsList arrayByAddingObject:self.selectedObject];
//                destinationVC.mealsList = self.mealsList;
//            }
//            
//        }
//        destinationVC.restaurant = nil;
//        
//        [self setSuspendAutomaticTrackingOfChangesInManagedObjectContext:YES];
//    }
//    
//    
//    else if ([segue.identifier isEqualToString:@"TakeMedicationSegue"])
//    {
//        EDTakeNewMedicationViewController *destinationVC = segue.destinationViewController;
//        
//        if (self.selectedObject) {
//            
//            if (self.tableFoodType == MedicationFoodType) {
//                destinationVC.parentMedicationsList = [destinationVC.parentMedicationsList arrayByAddingObject:self.selectedObject];
//                destinationVC.ingredientsList = @[];
//            }
//            else if (self.tableFoodType == IngredientFoodType) {
//                destinationVC.ingredientsList = [destinationVC.ingredientsList arrayByAddingObject:self.selectedObject];
//                destinationVC.parentMedicationsList = @[];
//            }
//            
//        }
//        destinationVC.restaurant = self.restaurant;
//        
//        [self setSuspendAutomaticTrackingOfChangesInManagedObjectContext:YES];
//    }
}

- (void) pushToAnotherAddTableViewController {
//    EDAddTableViewController *addTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTableVC"];
//    
//    addTableVC.medicationFind = self.medicationFind;
//    addTableVC.delegate = self.delegate;
//    
//    addTableVC.restaurant = self.restaurant;
//    addTableVC.ingredientsList = self.ingredientsList;
//    
//    
//    if (self.medicationFind) {
//        addTableVC.medicationList = self.medicationList;
//        addTableVC.sortBy = ByParentFood;
//        addTableVC.tableFoodType = MedicationFoodType;
//    }
//    else { // What is this for?
//        addTableVC.mealsList = self.mealsList;
//        addTableVC.sortBy = ByName;
//        addTableVC.tableFoodType = MealFoodType;
//    }
//    
//    
//    addTableVC.selectedObject = self.selectedObject;
//    
//    [self setSuspendAutomaticTrackingOfChangesInManagedObjectContext:YES];
//    
//    [self.navigationController pushViewController:addTableVC animated:YES];
}


#pragma mark - Core Data Reordered Sections-

// reorder based on the sort we choose
// Must return an array of distinct NSNumber ints in [0, 1, ..., # of sections - 1]
- (NSArray *) mhedSections
{
    if (self.reorderedSections) {
        return self.reorderedSections;
    }
    NSArray *reorder = [[NSArray alloc] init];
    
    if (self.sortBy == ByTags) {
        
        // we have favorites at the top
        
        
        //        // we want Favorite at the top, so we must first find where that is
        //        NSInteger favoriteIndex = 0;
        //        for (int i = 0; i < [[self.fetchedResultsController sections] count]; i++) {
        //            id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][i];
        //            if ([[sectionInfo name] isEqualToString:FAVORITE_TAG_NAME]) {
        //                favoriteIndex = i;
        //            }
        //        }
        //
        //        // for moving section j to location k (j > k), with k going to k+1, etc, use this
        //        //      - if j < k then there is ambiguity in how things are adjusted
        //        int j = favoriteIndex;
        //        int k = 0;
        //        int min = MIN(j, k);
        //        int max = MAX(j, k);
        //
        //        for (int i=0; i < [[self.fetchedResultsController sections] count]; i++) {
        //            if (min == i) {
        //                reorder = [reorder arrayByAddingObject:@(max)];
        //            }
        //            else if (min < i && i <= max) {
        //                reorder = [reorder arrayByAddingObject:@(i - 1)];
        //            }
        //            else {
        //                reorder = [reorder arrayByAddingObject:@(i)];
        //            }
        //
        //        }
        //        if ([reorder count]) {
        //            self.reorderedSections = reorder;
        //        }
    }
    
    return reorder;
}

- (NSArray *)mhedSectionIndexTitles
{
    
    NSMutableArray *indexTitles = [[self mhedSections] mutableCopy];
    
    for (int i =0; i < [[self mhedSections] count];  i++) {
        NSInteger originalSection = [(NSNumber *)[self mhedSections][i] integerValue];
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][originalSection];
        
        NSString *sectionName = [sectionInfo name];
        if ([sectionName length] > 5) {
            sectionName = [sectionName substringToIndex:5];
        }
        [indexTitles replaceObjectAtIndex:i withObject:sectionName];
    }
    
    return [indexTitles copy];
}

- (id) mhedObjectAtIndexPath: (NSIndexPath *) indexPath
{
    if (self.tableFoodType == MealFoodType) {
        if (self.sortBy == ByRecent) {
            EDEatenMeal *eatenMealForIndexPath = [super mhedObjectAtIndexPath:indexPath];
            return eatenMealForIndexPath.meal;
        }
    }
    
    else if (self.tableFoodType == IngredientFoodType) {
        
    }
    
    else if (self.tableFoodType == MedicationFoodType)
    {
        if (self.sortBy == ByRecent) {
            EDTakenMedication *takenMedForIndexPath = [super mhedObjectAtIndexPath:indexPath];
            return takenMedForIndexPath.medication;
        }
    }
    
    return [super mhedObjectAtIndexPath:indexPath];
}

- (id) mhedObjectWithoutFRCFromIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.tableFoodType == MealFoodType) {
        if (self.sortBy == ByTags) {
            
            EDTag *tagForSection = self.fetchedResultsController.fetchedObjects[indexPath.section];
            
            NSFetchRequest *fetchMealsForTags = [EDFood fetchObjectsForEntityName:MEAL_ENTITY_NAME Tags:[NSSet setWithObject:tagForSection]];
            fetchMealsForTags.includesSubentities = NO;
            
            // fetchMealsForTags.fetchOffset = indexPath.row; // we don't want the first indexPath.row meals
            // fetchMealsForTags.fetchLimit = 1; // we only want 1 object
            
            NSArray *mealsForTags = [self.managedObjectContext executeFetchRequest:fetchMealsForTags error:nil];
            
            return mealsForTags[indexPath.row];
            
        }
        
        if (self.sortBy == ByTypes) {
            EDType *typeForSection = self.fetchedResultsController.fetchedObjects[indexPath.section];
            
            NSArray *mealsForTypes = [[typeForSection determineMeals] allObjects];
            NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            
            NSArray *sortedMeals = [mealsForTypes sortedArrayUsingDescriptors:@[nameSort]];
            
            return sortedMeals[indexPath.row];
        }
    }
    
    else if (self.tableFoodType == IngredientFoodType) {
        if (self.sortBy == ByTags) {
            EDTag *tagForSection = self.fetchedResultsController.fetchedObjects[indexPath.section];
            
            NSFetchRequest *fetchIngredientssForTags = [EDFood fetchObjectsForEntityName:INGREDIENT_ENTITY_NAME Tags:[NSSet setWithObject:tagForSection]];
            
            
            // fetchMealsForTags.fetchOffset = indexPath.row; // we don't want the first indexPath.row meals
            // fetchMealsForTags.fetchLimit = 1; // we only want 1 object
            
            NSArray *ingredientsForTags = [self.managedObjectContext executeFetchRequest:fetchIngredientssForTags error:nil];
            
            return ingredientsForTags[indexPath.row];
            
        }
        
        if (self.sortBy == ByTypes) {
            EDType *typeForSection = self.fetchedResultsController.fetchedObjects[indexPath.section];
            
            NSMutableArray *mutIngredientsForType = [[typeForSection.ingredientsPrimary allObjects] mutableCopy];
            [mutIngredientsForType addObjectsFromArray:[[typeForSection determineIngredientsSecondary] allObjects]];
            NSArray *ingredientsForType = [mutIngredientsForType copy];
            
            NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            
            NSArray *sortedIngredients = [ingredientsForType sortedArrayUsingDescriptors:@[nameSort]];
            
            return sortedIngredients[indexPath.row];
        }
    }
    
    else if (self.tableFoodType == MedicationFoodType) {
        
        if (self.sortBy == ByTags) {
            
            EDTag *tagForSection = self.fetchedResultsController.fetchedObjects[indexPath.section];
            
            NSFetchRequest *fetchMedsForTag = [EDFood fetchObjectsForEntityName:MEDICATION_ENTITY_NAME Tags:[NSSet setWithObject:tagForSection]];
            
            
            // fetchMealsForTags.fetchOffset = indexPath.row; // we don't want the first indexPath.row meals
            // fetchMealsForTags.fetchLimit = 1; // we only want 1 object
            
            NSArray *medsForTags = [self.managedObjectContext executeFetchRequest:fetchMedsForTag error:nil];
            
            return medsForTags[indexPath.row];
            
        }
        
    }
    
    return nil;
}

@end
