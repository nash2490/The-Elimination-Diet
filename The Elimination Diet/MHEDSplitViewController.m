//
//  MHEDSplitViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDSplitViewController.h"

#import "MHEDMealSummaryViewController.h"

#import "EDMeal+Methods.h"
#import "EDEatenMeal+Methods.h"

#import "EDMedication+Methods.h"
#import "EDTakenMedication+Methods.h"

#import "EDIngredient+Methods.h"

#import "UIImage+MHED_fixOrientation.h"

#import "UIView+MHED_AdjustView.h"

#import "EDEliminatedAPI.h"

@import MobileCoreServices;

static double mhedSplitViewDefaultHeightForTopView = 282.0;

// Objects Dictionary keys - use to retrieve arrays from objectsDictionary
static NSString *mhedObjectsDictionaryMealsKey = @"Meals List Key";
static NSString *mhedObjectsDictionaryIngredientsKey = @"Ingredients List Key";
static NSString *mhedObjectsDictionaryMedicationKey = @"Medication List Key";
static NSString *mhedObjectsDictionarySymptomsKey = @"Symptom List Key";
static NSString *mhedObjectsDictionaryImagesKey = @"Images List Key";


NSString *const mhedStoryBoardViewControllerIDMealFillinSequence = @"Meal Fill-in Sequence";
NSString *const mhedStoryBoardViewControllerIDQuickCaptureSequence = @"Quick Capture Sequence";

NSString *const mhedStoryBoardViewControllerIDBottomBrowseSequence = @"MHEDBottomBrowse";
NSString *const mhedStoryBoardViewControllerIDMealSummary = @"MHEDMealSummary";



@interface MHEDSplitViewController ()

@property (nonatomic, weak) MHEDMealSummaryViewController *mhedMealSummaryVC;

@property (nonatomic) CGFloat mhedTopViewHeight;

@end


@implementation MHEDSplitViewController


- (MHEDObjectsDictionary *) objectsDictionary
{
    if (!_objectsDictionary) {
        _objectsDictionary = [[MHEDObjectsDictionary alloc] initWithDefaults];
    }
    return _objectsDictionary;
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
	// Do any additional setup after loading the view.
    
    [self updateContainerViewWithMealOptionsViewController];
    
    if (self.navigationController) {
        
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDoneButton:)]];
    }
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = YES;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Layout and Adjusting

- (IBAction)mhedShowHideButtonPress:(id)sender {
    if (self.isTopViewHidden) {
        self.isTopViewHidden = NO;
        
        // animate Open
        
        
        
        [UIView animateWithDuration:0.3
                              delay: 0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             [self.mhedTopView mhedSetFrameHeight: self.mhedTopViewHeight];
                             [self.mhedShowHideView mhedSetOriginY: CGRectGetMaxY(self.mhedTopView.frame)];
                             [self.mhedBottomView mhedSetOriginY: CGRectGetMaxY(self.mhedShowHideView.frame)];
                             //[self.mhedBottomView mhedSetFrameHeight:CGRectGetHeight(self.mhedBottomView.frame) + mhedSplitViewDefaultHeightForTopView];
                         }
                         completion:^(BOOL finished){
                             
                             [UIView animateWithDuration:0.0
                                                   delay: 0.0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  
                                                  [self.mhedBottomView mhedSetFrameHeight:CGRectGetHeight(self.mhedBottomView.frame) - self.mhedTopViewHeight];
                                              }
                                              completion: ^(BOOL finished){
                                                  
                                                  
                                              }];
                         }];
        
    }
    
    else {
        self.isTopViewHidden = YES;
        
        // animate close;
        // ---------
        // self.mhedTopView.frame.height = 0.0
        // self.mhedShowHideView.frame.y = 0.0
        // self.mhedBottomView.frame.y = self.mhedShowHideView.frame.height
        // self.mhedBottomView.frame.height = self.mhedBottomView.frame.height + mhedSplitViewDefaultHeightForTopView
        
        // Do I also need to change the autolayout things?
        //      - think i would only need to do that if viewWillLayoutSubviews gets called again, does it ?
        
        
//        [UIView animateWithDuration:0.5
//                              delay: 0.0
//                            options: UIViewAnimationOptionCurveEaseIn
//                         animations:^{
//                             
//                             self.mhedTopView.alpha = 0.0;
//                             
//                         }
//                         completion:^(BOOL finished){
//                             // Wait one second and then fade in the view
//                             
//                         }];
        
//        [UIView animateWithDuration:5.0
//                              delay: 0.5
//                            options:UIViewAnimationOptionCurveEaseOut
//                         animations:^{
//                             
//                             [self.mhedTopView mhedSetFrameHeight: 0.0];
//                             [self.mhedShowHideView mhedSetOriginY: CGRectGetMaxY(self.mhedTopView.frame)];
//                             [self.mhedBottomView mhedSetOriginY: CGRectGetMaxY(self.mhedShowHideView.frame)];
//                             //[self.mhedBottomView mhedSetFrameHeight:CGRectGetHeight(self.mhedBottomView.frame) + mhedSplitViewDefaultHeightForTopView];
//                         }
//                         completion:nil];
        
        self.mhedTopViewHeight = self.mhedTopView.frame.size.height;
        
        [UIView animateWithDuration:0.0
                              delay: 0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                        
                             [self.mhedBottomView mhedSetFrameHeight:CGRectGetHeight(self.mhedBottomView.frame) + self.mhedTopViewHeight];
                         }
                         completion: ^(BOOL finished){
                             
                             [UIView animateWithDuration:0.3
                                                   delay: 0.1
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  
                                                  [self.mhedTopView mhedSetFrameHeight: 0.0];
                                                  [self.mhedShowHideView mhedSetOriginY: CGRectGetMaxY(self.mhedTopView.frame)];
                                                  [self.mhedBottomView mhedSetOriginY: CGRectGetMaxY(self.mhedShowHideView.frame)];
                                                  //[self.mhedBottomView mhedSetFrameHeight:CGRectGetHeight(self.mhedBottomView.frame) + mhedSplitViewDefaultHeightForTopView];
                                              }
                                              completion:nil];
                         }];
        
    }
}


//- (void) handleShowHideButtonPress:(id)sender
//{
//    if (self.isTopViewHidden) {
//        self.isTopViewHidden = NO;
//        
//        // animate Open
//    }
//    
//    else {
//        self.isTopViewHidden = YES;
//        
//        // animate close;
//        // ---------
//                // self.mhedTopView.frame.height = 0.0
//                // self.mhedShowHideView.frame.y = 0.0
//                // self.mhedBottomView.frame.y = self.mhedShowHideView.frame.height
//                // self.mhedBottomView.frame.height = self.mhedBottomView.frame.height + mhedSplitViewDefaultHeightForTopView
//        
//        // Do I also need to change the autolayout things?
//        //      - think i would only need to do that if viewWillLayoutSubviews gets called again, does it ?
//        
//        
//        [UIView animateWithDuration:1.0
//                              delay: 0.0
//                            options: UIViewAnimationOptionCurveEaseIn
//                         animations:^{
//                             
//                             self.mhedTopView.alpha = 0.0;
//                             
//                         }
//                         completion:^(BOOL finished){
//                             // Wait one second and then fade in the view
//                             [UIView animateWithDuration:1.0
//                                                   delay: 1.0
//                                                 options:UIViewAnimationOptionCurveEaseOut
//                                              animations:^{
//                                                  
//                                                  [self.mhedTopView mhedSetFrameHeight: 0.0];
//                                                  [self.mhedShowHideView mhedSetOriginY: 0.0];
//                                                  [self.mhedBottomView mhedSetOriginY: CGRectGetHeight(self.mhedShowHideView.frame)];
//                                                  [self.mhedBottomView mhedSetFrameHeight:CGRectGetHeight(self.mhedBottomView.frame) + mhedSplitViewDefaultHeightForTopView];
//                                              }
//                                              completion:nil];
//                         }];
//        
//        
//    }
//    
//}



#pragma mark - Container View Controller

- (void) updateContainerViewWithMealOptionsViewController
{
    // get view controller
    UIViewController *bottomViewController = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDBottomBrowseSequence];
    
    MHEDMealSummaryViewController *topViewController = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDMealSummary];
    
    
    
    // display in container view
    [self view:self.mhedBottomView displayContentController:bottomViewController];
    [self view:self.mhedTopView displayContentController:topViewController];
    
    self.mhedMealSummaryVC = topViewController;
    
}



- (void) view:(UIView *)view displayContentController:(UIViewController *)content
{
    [content willMoveToParentViewController:self];
    
    [self addChildViewController:content];
    
    content.view.frame = [view bounds];
    
    [view addSubview:content.view];
    
    [content didMoveToParentViewController:self];
}


- (void) displayContentController:(UIViewController *)content inContainerLocation:(MHEDSplitViewContainerViewLocation)location
{
    if (MHEDSplitViewContainerViewLocationTop == location) {
        [self view:self.mhedTopView displayContentController:content];
    }
    
    else if (MHEDSplitViewContainerViewLocationBottom == location) {
        [self view:self.mhedBottomView displayContentController:content];
    }
}


- (void) displayMealFillinViewControllerInContainerLocation: (MHEDSplitViewContainerViewLocation) location
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDMealFillinSequence];
    
    [self displayContentController:vc inContainerLocation: location];
    
}

- (void) displayMealSummaryViewControllerInContainerLocation:(MHEDSplitViewContainerViewLocation) location
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDMealSummary];
    
    [self displayContentController:vc inContainerLocation: location];
}

- (void) displayBottomBrowseViewControllerInContainerLocation:(MHEDSplitViewContainerViewLocation) location
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDBottomBrowseSequence];
    
    [self displayContentController:vc inContainerLocation: location];
}

- (void) displayQuickCaptureSequenceInContainerLocation:(MHEDSplitViewContainerViewLocation) location
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDQuickCaptureSequence];
    
    [self displayContentController:vc inContainerLocation: location];
}

#pragma mark - Create Meal methods

- (void) handleDoneButton: (id) sender
{
    [self createMeal];
}


- (void) createMeal
{
    [self.objectsDictionary createMealInContext:self.managedObjectContext];
}



#pragma mark - MHEDFoodSelectionViewControllerDataSource methods -
// default method options


//- (void) setNewRestaurant:(EDRestaurant *)restaurant
//{
//    if (restaurant) {
//        self.restaurant = restaurant;
//    }
//}
//
//- (NSArray *) tagsList
//{
//    if (!_tagsList) {
//        _tagsList = [[NSArray alloc] init];
//    }
//    return _tagsList;
//}
//
//- (void) addToTagsList: (NSArray *) tags
//{
//    if (tags) {
//        self.tagsList = [self.tagsList arrayByAddingObjectsFromArray:tags];
//    }
//}
//
//- (void) setNewTagsList: (NSArray *) newTagsList
//{
//    if (newTagsList) {
//        self.tagsList = newTagsList;
//    }
//}
//
//
//- (NSArray *) mealsList
//{
//    //    if (!_mealsList) {
//    //        _mealsList = [[NSArray alloc] init];
//    //    }
//    //    return _mealsList;
//    
//    return self.objectsDictionary[mhedObjectsDictionaryMealsKey];
//    
//}
//
//- (void) setNewMealsList: (NSArray *) newMealsList
//{
//    //    if (newMealsList) {
//    //        self.mealsList = newMealsList;
//    //    }
//    
//    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
//    [mutObjectsDictionary setObject:[newMealsList copy] forKey:mhedObjectsDictionaryMealsKey];
//    
//    self.objectsDictionary = [mutObjectsDictionary copy];
//    [self updateMealSummaryTable];
//}
//
//- (void) addToMealsList: (NSArray *) meals
//{
//    //    if (meals) {
//    //        self.mealsList = [self.mealsList arrayByAddingObjectsFromArray:meals];
//    //        for (EDTag *tag in [meals[0] tags]) {
//    //            NSLog(@"tag name = %@", tag.name);
//    //        }
//    //    }
//    
//    
//    NSArray *oldList = self.objectsDictionary[mhedObjectsDictionaryMealsKey];
//    NSArray *newList = [oldList arrayByAddingObjectsFromArray:meals];
//    
//    [self setNewMealsList:newList];
//}
//
//- (void) removeMealsFromMealsList: (NSArray *) meals
//{
//    NSArray *oldList = self.objectsDictionary[mhedObjectsDictionaryMealsKey];
//    NSMutableArray *mutOldList = [oldList mutableCopy];
//    [mutOldList removeObjectsInArray:meals];
//    
//    [self setNewMealsList:mutOldList];
//}
//
//
//- (BOOL) doesMealsListContainMeals:(NSArray *) meals
//{
//    BOOL contains = YES;
//    for (EDMeal *meal in meals) {
//        if ([meal isKindOfClass:[EDMeal class]]) {
//            contains = (contains && [[self mealsList] containsObject:meal]);
//        }
//        else {
//            contains = NO;
//        }
//    }
//    return contains;
//}
//
//
//
//- (NSArray *) ingredientsList
//{
//    //    if (!_ingredientsList) {
//    //        _ingredientsList = [[NSArray alloc] init];
//    //    }
//    //    return _ingredientsList;
//    
//    return self.objectsDictionary[mhedObjectsDictionaryIngredientsKey];
//}
//
//
//
//
//- (void) setNewIngredientsList: (NSArray *) newIngredientsList
//{
//    //    if (newIngredientsList) {
//    //        self.ingredientsList = newIngredientsList;
//    //    }
//    
//    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
//    [mutObjectsDictionary setObject:[newIngredientsList copy] forKey:mhedObjectsDictionaryIngredientsKey];
//    
//    self.objectsDictionary = [mutObjectsDictionary copy];
//    [self updateMealSummaryTable];
//}
//
//
//
//
//- (void) addToIngredientsList: (NSArray *) ingredients
//{
//    //    if (ingredients) {
//    //        self.ingredientsList = [self.ingredientsList arrayByAddingObjectsFromArray:ingredients];
//    //    }
//    
//    NSArray *oldList = [self ingredientsList];
//    NSArray *newList = [oldList arrayByAddingObjectsFromArray:ingredients];
//    
//    [self setNewIngredientsList:newList];
//}
//
//
//- (void) removeIngredientsFromIngredientsList:(NSArray *)ingredients
//{
//    NSArray *oldList = [self ingredientsList];
//    NSMutableArray *mutOldList = [oldList mutableCopy];
//    [mutOldList removeObjectsInArray:ingredients];
//    
//    [self setNewIngredientsList:mutOldList];
//}
//
//
//- (BOOL) doesIngredientsListContainIngredients:(NSArray *)ingredients
//{
//    BOOL contains = YES;
//    for (EDIngredient *ingr in ingredients) {
//        if ([ingr isKindOfClass:[EDIngredient class]]) {
//            contains = (contains && [[self ingredientsList] containsObject:ingr]);
//        }
//        else {
//            contains = NO;
//        }
//    }
//    return contains;
//}
//
//
//
//- (NSArray *) medicationsList
//{
//    return self.objectsDictionary[mhedObjectsDictionaryMedicationKey];
//}
//
//- (void) setNewMedicationsList: (NSArray *) newMedicationsList
//{
//    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
//    [mutObjectsDictionary setObject:[newMedicationsList copy] forKey:mhedObjectsDictionaryMedicationKey];
//    
//    self.objectsDictionary = [mutObjectsDictionary copy];
//    [self updateMealSummaryTable];
//    
//}
//
//- (void) addToMedicationsList: (NSArray *) medications
//{
//    NSArray *oldList = [self medicationsList];
//    NSArray *newList = [oldList arrayByAddingObjectsFromArray:medications];
//    
//    [self setNewMedicationsList:newList];
//}
//
//- (void) removeMedicationsFromMedicationsList:(NSArray *)medications
//{
//    NSArray *oldList = [self medicationsList];
//    NSMutableArray *mutOldList = [oldList mutableCopy];
//    [mutOldList removeObjectsInArray:medications];
//    
//    [self setNewMedicationsList:mutOldList];
//}
//
//- (BOOL) doesMedicationsListContainMedications:(NSArray *)medications
//{
//    BOOL contains = YES;
//    for (EDMedication *medication in medications) {
//        if ([medication isKindOfClass:[EDMedication class]]) {
//            contains = (contains && [[self medicationsList] containsObject:medication]);
//        }
//        else {
//            contains = NO;
//        }
//    }
//    return contains;
//}



#pragma mark - MHEDObjectsDictionaryProtocol and helper methods
// default method options

- (NSArray *) mealsList
{
    return [self.objectsDictionary mealsList];
}

- (NSArray *) ingredientsList
{
    return [self.objectsDictionary ingredientsList];
}

- (NSArray *) medicationsList {
    return [self.objectsDictionary medicationsList];
}

- (NSArray *) tagsList
{
    return [self.objectsDictionary tagsList];
}

- (EDRestaurant *) restaurant
{
    return [self.objectsDictionary restaurant];
}

- (NSArray *) imagesList
{
    return [self.objectsDictionary imagesArray];
}

- (NSDate *) date
{
    return [self.objectsDictionary date];
}

- (NSString *) objectName
{
    return [self.objectsDictionary objectName];
}








#pragma mark - Segue methods

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@""]) {
        
    }
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
