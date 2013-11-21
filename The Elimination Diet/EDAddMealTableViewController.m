//
//  EDAddMealTableViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/9/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDAddMealTableViewController.h"

#import "EDEatMealViewController.h"

#import "EDFood+Methods.h"
#import "EDEatenMeal+Methods.h"
#import "EDMeal+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDTag+Methods.h"
#import "EDType+Methods.h"

#import "EDMedication+Methods.h"
#import "EDTakenMedication+Methods.h"

#define MEAL_TABLECELL @"EDMeal Table Cell"

@interface EDAddMealTableViewController ()

@property (nonatomic, strong) id selectedFood;
@end

@implementation EDAddMealTableViewController

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
}

- (void) viewWillAppear:(BOOL)animated
{
    if (self.sortBy == ByFavoriteAndTags) {
        self.populatedTableUsingFRC = NO;
        self.customSectionOrdering = YES;
    }
    
    if (self.sortBy == ByTypes) {
        self.populatedTableUsingFRC = NO;
    }
    
    if (self.delegate) {
        
        self.restaurant = [self.delegate restaurant];
        self.ingredientsList = [self.delegate ingredientsList];
        
        if (!self.medicationFind) {
            self.mealsList = [self.delegate mealsList];
        }
        else {
            self.medicationList = [self.delegate parentMedicationsList];
        }
        
        NSLog(@"delegate was set --------------------------------------------------------------------");
    }
    
    [super viewWillAppear:animated];
    
    [self setSuspendAutomaticTrackingOfChangesInManagedObjectContext:NO];

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
    
    switch (self.sortBy) {
        case ByRestaurant:
            sortByMethod = @"name";
            break;
            
        case ByName:
            sortByMethod = @"nameFirstLetter";
            break;
            
        case ByIngredients:
            sortByMethod = @"nameFirstLetter";
            break;
            
        case ByFavoriteAndTags:
            sortByMethod = @"name";
            break;
            
        case ByTypes:
            sortByMethod = @"name";
            break;
        
        case ByRecent:
            sortByMethod = @"eventDayString";
            break;
            
        default:
            sortByMethod = nil;
            break;
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
            return [EDMeal fetchAllMeals];
        }
        
        else if (self.sortBy == ByName) {
            return [EDMeal fetchAllMeals];
        }
        
        else if (self.sortBy == ByTypes) {
            return  [EDType fetchAllTypes];
        }
        
        else if (self.sortBy == ByFavoriteAndTags) {
            return  [EDTag fetchAllTags];
        }
        
        else if (self.sortBy == ByRecent) {
            return [EDEatenMeal fetchEatenMealsForLastWeek];
        }
        
        else {
            return [EDMeal fetchAllMeals];
        }
    }
    
    else if (self.tableFoodType == IngredientFoodType) {
        
         if (self.sortBy == ByName) {
            return [EDIngredient fetchAllIngredients];
        }
        
        else if (self.sortBy == ByTypes) {
            return  [EDType fetchAllTypes];
        }
        
        else if (self.sortBy == ByFavoriteAndTags) {
            return  [EDTag fetchAllTags];
        }
    
        else {
            return [EDIngredient fetchAllIngredients];
        }
    }
    
    else if (self.tableFoodType == MedicationFoodType) {
        
        if (self.sortBy == ByRecent) {
            return [EDTakenMedication fetchAllTakenMedication];
        }
        
        else if (self.sortBy == ByFavoriteAndTags) {
            return  [EDTag fetchAllTags];
        }
        
        return [EDMedication fetchAllMedication];
    }
    
    else {
        return [EDMeal fetchAllMeals];
    }
}


#pragma mark - Table View Controller Delegate and Data Source -

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [super numberOfSectionsInTableView:tableView];

}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [super tableView:tableView titleForHeaderInSection:section];

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
    
    if (self.sortBy == ByFavoriteAndTags) {
        NSInteger originalSection = [[self edSections][section] integerValue];
        EDTag *tagForSection = self.fetchedResultsController.fetchedObjects[originalSection];
        
        NSFetchRequest *fetchFoodForTags = nil;
        
        if (self.tableFoodType == MealFoodType) {
            fetchFoodForTags = [EDFood fetchObjectsForEntityName:MEAL_ENTITY_NAME Tags:[NSSet setWithObject:tagForSection]];
        }
        
        else if (self.tableFoodType == IngredientFoodType) {
            fetchFoodForTags = [EDFood fetchObjectsForEntityName:INGREDIENT_ENTITY_NAME Tags:[NSSet setWithObject:tagForSection]];
        }
        else if (self.tableFoodType == MedicationFoodType) {
#warning put shit here
        }
        
        // fetchMealsForTags.fetchOffset = indexPath.row; // we don't want the first indexPath.row meals
        // fetchMealsForTags.fetchLimit = 1; // we only want 1 object
        
        NSUInteger numberOfFoodForTags = [self.managedObjectContext countForFetchRequest:fetchFoodForTags error:nil];
        return (NSInteger)numberOfFoodForTags;
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
    
    EDMeal *mealForIndexPath = [self edObjectAtIndexPath:indexPath];
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Detail Meal"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Detail Meal"];
    }
    cell.textLabel.text = mealForIndexPath.name;
    
    NSString *tagsDescription = @"";
    for (EDTag *tag in mealForIndexPath.tags) {
        tagsDescription = [tagsDescription stringByAppendingString:@", "];
        tagsDescription = [tagsDescription stringByAppendingString:tag.name];
    }
    cell.detailTextLabel.text = tagsDescription;
    
    return cell;
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedFood = [self edObjectAtIndexPath:indexPath];

    if (self.delegate) {
        
        if (self.tableFoodType == MealFoodType) {
            [self.delegate addToMealsList:@[self.selectedFood]];
        }
        else if (self.tableFoodType == IngredientFoodType) {
            [self.delegate addToIngredientsList:@[self.selectedFood]];
        }
        
        
        // we pop back to delegate
        CGRect addMealFrame = self.view.frame;
        addMealFrame.origin.x = -addMealFrame.size.width;
        
        CGRect eatMealFrame = self.view.frame;
        
        /*
        [UIView animateWithDuration:0.75
                         animations:^{
                             
                             [UIView setAnimationDuration:0.5];
                             [UIView setAnimationDelay:0.0];
                             [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                             
                             self.navigationController.view.frame = addMealFrame;
                             [self.navigationController popToViewController:(UIViewController *)self.delegate animated:NO];
                             
                            // [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
                         }];
        
         */
        [UIView animateWithDuration:.5
                         animations:^{
                             [UIView setAnimationDuration:0.5];
                             [UIView setAnimationDelay:0.0];
                             [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
                             self.navigationController.view.frame = addMealFrame;
                             //[self.navigationController popToViewController:(UIViewController *)self.delegate animated:NO];
                             // [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
                             
                         } completion:^(BOOL finished) {
                             self.navigationController.view.frame = eatMealFrame;
                             [self.navigationController popToViewController:(UIViewController *)self.delegate animated:NO];

                         }];
        
    }
    
    else { // there is no delegate so we just segue
        [self performSegueWithIdentifier:@"EatMealSegue" sender:self];
    }
    
}

#pragma mark - Storyboard Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"EatMealSegue"]) {
        EDEatMealViewController *destinationVC = segue.destinationViewController;
        
        if (self.selectedFood) {
            
            if (self.tableFoodType == MealFoodType) {
                destinationVC.mealsList = @[self.selectedFood];
                destinationVC.ingredientsList = @[];
            }
            else if (self.tableFoodType == IngredientFoodType) {
                destinationVC.ingredientsList = @[self.selectedFood];
                destinationVC.mealsList = @[];
            }
            
        }
        destinationVC.restaurant = nil;
        
        [self setSuspendAutomaticTrackingOfChangesInManagedObjectContext:YES];
    }
    
    
    else if ([segue.identifier isEqualToString:nil]) {
        
    }
}


#pragma mark - Core Data Reordered Sections-

// reorder based on the sort we choose
    // Must return an array of distinct NSNumber ints in [0, 1, ..., # of sections - 1]
- (NSArray *) edSections
{
    if (self.reorderedSections) {
        return self.reorderedSections;
    }
    NSArray *reorder = [[NSArray alloc] init];
    
    if (self.sortBy == ByFavoriteAndTags) {
        // we want Favorite at the top, so we must first find where that is
        NSInteger favoriteIndex = 0;
        for (int i = 0; i < [[self.fetchedResultsController sections] count]; i++) {
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][i];
            if ([[sectionInfo name] isEqualToString:FAVORITE_TAG_NAME]) {
                favoriteIndex = i;
            }
        }
        
        // for moving section j to location k (j > k), with k going to k+1, etc, use this
        //      - if j < k then there is ambiguity in how things are adjusted
        int j = favoriteIndex;
        int k = 0;
        int min = MIN(j, k);
        int max = MAX(j, k);
        
        for (int i=0; i < [[self.fetchedResultsController sections] count]; i++) {
            if (min == i) {
                reorder = [reorder arrayByAddingObject:@(max)];
            }
            else if (min < i <= max) {
                reorder = [reorder arrayByAddingObject:@(i - 1)];
            }
            else {
                reorder = [reorder arrayByAddingObject:@(i)];
            }
            
        }
        if ([reorder count]) {
            self.reorderedSections = reorder;
        }
    }
    
    return reorder;
}

- (NSArray *)edSectionIndexTitles
{
    NSMutableArray *indexTitles = [[self edSections] mutableCopy];
    
    for (int i =0; i < [[self edSections] count];  i++) {
        NSInteger originalSection = [(NSNumber *)[self edSections][i] integerValue];
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][originalSection];

        NSString *sectionName = [sectionInfo name];
        if ([sectionName length] > 5) {
            sectionName = [sectionName substringToIndex:5];
        }
        [indexTitles replaceObjectAtIndex:i withObject:sectionName];
    }
    
    return [indexTitles copy];
}

- (id) edObjectAtIndexPath: (NSIndexPath *) indexPath
{
    if (self.tableFoodType == MealFoodType) {
        if (self.sortBy == ByRecent) {
            EDEatenMeal *eatenMealForIndexPath = [super edObjectAtIndexPath:indexPath];
            return eatenMealForIndexPath.meal;
        }
    }
    
    else if (self.tableFoodType == IngredientFoodType) {
        
    }
    
    
    return [super edObjectAtIndexPath:indexPath];
}

- (id) edObjectWithoutFRCFromIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.tableFoodType == MealFoodType) {
        if (self.sortBy == ByFavoriteAndTags) {
            EDTag *tagForSection = self.fetchedResultsController.fetchedObjects[indexPath.section];
            
            NSFetchRequest *fetchMealsForTags = [EDFood fetchObjectsForEntityName:MEAL_ENTITY_NAME Tags:[NSSet setWithObject:tagForSection]];
            
            
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
        if (self.sortBy == ByFavoriteAndTags) {
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
    
    return nil;
}
@end
