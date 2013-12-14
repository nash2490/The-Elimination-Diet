//
//  MHEDSplitFoodBrowseViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDSplitFoodBrowseViewController.h"

#import "MHEDMealSummaryViewController.h"
#import "MHEDBrowseFoodViewController.h"


//#import "mhed"

#import "EDMeal+Methods.h"
#import "EDEatenMeal+Methods.h"

#import "EDMedication+Methods.h"
#import "EDTakenMedication+Methods.h"

#import "EDIngredient+Methods.h"

#import "UIImage+MHED_fixOrientation.h"

@import MobileCoreServices;


// Objects Dictionary keys - use to retrieve arrays from objectsDictionary
NSString *const mhedObjectsDictionaryMealsKey = @"Meals List Key";
NSString *const mhedObjectsDictionaryIngredientsKey = @"Ingredients List Key";
NSString *const mhedObjectsDictionaryMedicationKey = @"Medication List Key";
NSString *const mhedObjectsDictionarySymptomsKey = @"Symptom List Key";


//NSString *const mhedStoryBoardViewControllerIDMealFillinSequence = @"Meal Fill-in Sequence";
//NSString *const mhedStoryBoardViewControllerIDQuickCaptureSequence = @"Quick Capture Sequence";
//
//NSString *const mhedStoryBoardViewControllerIDBottomBrowse = @"MHEDBottomBrowse";
//NSString *const mhedStoryBoardViewControllerIDMealSummary = @"MHEDMealSummary";
//
//NSString *const mhedFoodDataUpdateNotification = @"mhedFoodDataUpdateNotification";


@interface MHEDSplitFoodBrowseViewController ()

@property (nonatomic, weak) MHEDMealSummaryViewController *mhedMealSummaryVC;


@end

@implementation MHEDSplitFoodBrowseViewController


//- (NSDictionary *) objectsDictionary
//{
//    if (!_objectsDictionary) {
//        _objectsDictionary = @{mhedObjectsDictionaryMealsKey : @[],
//                               mhedObjectsDictionaryIngredientsKey : @[],
//                               mhedObjectsDictionaryMedicationKey : @[]};
//    }
//    return _objectsDictionary;
//}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self updateContainerViewWithMealOptionsViewController];
    
    if (self.navigationController) {
        
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(addMealDetails:)]];
        
       // [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDoneButton:)]];
    }
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // the first time we add an image we
    //    if (!self.tableLoaded && !self.imagePickerController) {
    //        self.tableLoaded = YES;
    //        [self.tableView reloadData];
    //    }
    
    //self.imagePickerController.tabBarController.tabBar.hidden = YES;

    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
}

//- (BOOL)prefersStatusBarHidden
//{
//    if (self.imagePickerController) {
//        return YES;
//    }
//    
//    return NO;
//}


#pragma mark - Create Meal methods

- (void) handleDoneButton: (id) sender
{
    [self createMeal];
}


- (void) createMeal
{
    if ([self.mealsList count] == 1 && [self.ingredientsList count] == 0)
    {
        // also should check the restaurant
        // but anyways, this means we don't need to create a new meal
        
        
        [self.managedObjectContext performBlockAndWait:^{
            [EDEatenMeal createEatenMealWithMeal:self.mealsList[0] atTime:self.date1 forContext:self.managedObjectContext];
            
        }];
        
    }
    
    else
    { // we need to create a new new meal first
        [self.managedObjectContext performBlockAndWait:^{
            EDMeal *newMeal = [EDMeal createMealWithName:self.objectName
                                        ingredientsAdded:[NSSet setWithArray:self.ingredientsList]
                                             mealParents:[NSSet setWithArray:self.mealsList]
                                              restaurant:self.restaurant tags:nil
                                              forContext:self.managedObjectContext];
            
//            if ([self.images count]) {
//                [newMeal addUIImagesToFood:[NSSet setWithArray:self.images] error:nil];
//            }
            
            
            [EDEatenMeal createEatenMealWithMeal:newMeal atTime:self.date1 forContext:self.managedObjectContext];
        }];
    }
}




#pragma mark - MHEDFoodSelectionViewControllerDataSource methods -
// default method options


- (void) setNewRestaurant:(EDRestaurant *)restaurant
{
    if (restaurant) {
        self.restaurant = restaurant;
    }
}

//- (NSArray *) tagsList
//{
//    if (!_tagsList) {
//        _tagsList = [[NSArray alloc] init];
//    }
//    return _tagsList;
//}

- (void) addToTagsList: (NSArray *) tags
{
    if (tags) {
        self.tagsList = [self.tagsList arrayByAddingObjectsFromArray:tags];
    }
}

- (void) setNewTagsList: (NSArray *) newTagsList
{
    if (newTagsList) {
        self.tagsList = newTagsList;
    }
}


- (NSArray *) mealsList
{
    //    if (!_mealsList) {
    //        _mealsList = [[NSArray alloc] init];
    //    }
    //    return _mealsList;
    
    return self.objectsDictionary[mhedObjectsDictionaryMealsKey];
    
}

- (void) setNewMealsList: (NSArray *) newMealsList
{
    //    if (newMealsList) {
    //        self.mealsList = newMealsList;
    //    }
    
    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
    [mutObjectsDictionary setObject:[newMealsList copy] forKey:mhedObjectsDictionaryMealsKey];
    
    self.objectsDictionary = [mutObjectsDictionary copy];
    [self updateMealSummaryTable];
}

- (void) addToMealsList: (NSArray *) meals
{
    //    if (meals) {
    //        self.mealsList = [self.mealsList arrayByAddingObjectsFromArray:meals];
    //        for (EDTag *tag in [meals[0] tags]) {
    //            NSLog(@"tag name = %@", tag.name);
    //        }
    //    }
    
    
    NSArray *oldList = self.objectsDictionary[mhedObjectsDictionaryMealsKey];
    NSArray *newList = [oldList arrayByAddingObjectsFromArray:meals];
    
    [self setNewMealsList:newList];
}

- (void) removeMealsFromMealsList: (NSArray *) meals
{
    NSArray *oldList = self.objectsDictionary[mhedObjectsDictionaryMealsKey];
    NSMutableArray *mutOldList = [oldList mutableCopy];
    [mutOldList removeObjectsInArray:meals];
    
    [self setNewMealsList:mutOldList];
}


- (BOOL) doesMealsListContainMeals:(NSArray *) meals
{
    BOOL contains = YES;
    for (EDMeal *meal in meals) {
        if ([meal isKindOfClass:[EDMeal class]]) {
            contains = (contains && [[self mealsList] containsObject:meal]);
        }
        else {
            contains = NO;
        }
    }
    return contains;
}



- (NSArray *) ingredientsList
{
    //    if (!_ingredientsList) {
    //        _ingredientsList = [[NSArray alloc] init];
    //    }
    //    return _ingredientsList;
    
    return self.objectsDictionary[mhedObjectsDictionaryIngredientsKey];
}




- (void) setNewIngredientsList: (NSArray *) newIngredientsList
{
    //    if (newIngredientsList) {
    //        self.ingredientsList = newIngredientsList;
    //    }
    
    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
    [mutObjectsDictionary setObject:[newIngredientsList copy] forKey:mhedObjectsDictionaryIngredientsKey];
    
    self.objectsDictionary = [mutObjectsDictionary copy];
    [self updateMealSummaryTable];
}




- (void) addToIngredientsList: (NSArray *) ingredients
{
    //    if (ingredients) {
    //        self.ingredientsList = [self.ingredientsList arrayByAddingObjectsFromArray:ingredients];
    //    }
    
    NSArray *oldList = [self ingredientsList];
    NSArray *newList = [oldList arrayByAddingObjectsFromArray:ingredients];
    
    [self setNewIngredientsList:newList];
}


- (void) removeIngredientsFromIngredientsList:(NSArray *)ingredients
{
    NSArray *oldList = [self ingredientsList];
    NSMutableArray *mutOldList = [oldList mutableCopy];
    [mutOldList removeObjectsInArray:ingredients];
    
    [self setNewIngredientsList:mutOldList];
}


- (BOOL) doesIngredientsListContainIngredients:(NSArray *)ingredients
{
    BOOL contains = YES;
    for (EDIngredient *ingr in ingredients) {
        if ([ingr isKindOfClass:[EDIngredient class]]) {
            contains = (contains && [[self ingredientsList] containsObject:ingr]);
        }
        else {
            contains = NO;
        }
    }
    return contains;
}



- (NSArray *) medicationsList
{
    return self.objectsDictionary[mhedObjectsDictionaryMedicationKey];
}

- (void) setNewMedicationsList: (NSArray *) newMedicationsList
{
    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
    [mutObjectsDictionary setObject:[newMedicationsList copy] forKey:mhedObjectsDictionaryMedicationKey];
    
    self.objectsDictionary = [mutObjectsDictionary copy];
    [self updateMealSummaryTable];

}

- (void) addToMedicationsList: (NSArray *) medications
{
    NSArray *oldList = [self medicationsList];
    NSArray *newList = [oldList arrayByAddingObjectsFromArray:medications];
    
    [self setNewMedicationsList:newList];
}

- (void) removeMedicationsFromMedicationsList:(NSArray *)medications
{
    NSArray *oldList = [self medicationsList];
    NSMutableArray *mutOldList = [oldList mutableCopy];
    [mutOldList removeObjectsInArray:medications];
    
    [self setNewMedicationsList:mutOldList];
}

- (BOOL) doesMedicationsListContainMedications:(NSArray *)medications
{
    BOOL contains = YES;
    for (EDMedication *medication in medications) {
        if ([medication isKindOfClass:[EDMedication class]]) {
            contains = (contains && [[self medicationsList] containsObject:medication]);
        }
        else {
            contains = NO;
        }
    }
    return contains;
}





#pragma mark - Segue methods

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@""]) {
        
    }
}

- (void) addMealDetails:(id) sender
{
    // segue to meal options etc.
}


#pragma mark - Container View Controller

- (void) updateContainerViewWithMealOptionsViewController
{
    // get view controllers
    MHEDMealSummaryViewController *topViewController = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDMealSummary];
    
    UINavigationController *bottomViewController = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDBottomBrowseSequence];
    
    MHEDBrowseFoodViewController *browseViewController = [bottomViewController viewControllers][0];
    browseViewController.delegate = self;
    topViewController.delegate = self;
    
    // display in container view
    [self view:self.mhedBottomView displayContentController:bottomViewController];
    [self view:self.mhedTopView displayContentController:topViewController];
    
    self.mhedMealSummaryVC = topViewController;
    
}

#pragma mark - 

- (void) updateMealSummaryTable
{
    if (self.mhedMealSummaryVC) {
        [[NSNotificationCenter defaultCenter] postNotificationName:mhedFoodDataUpdateNotification
                                                            object:nil];
    }
}

@end
