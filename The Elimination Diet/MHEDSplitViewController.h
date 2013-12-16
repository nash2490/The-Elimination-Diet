//
//  MHEDSplitViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MHEDFoodSelectionViewController.h"

#import "MHEDObjectsDictionary.h"


extern NSString *const mhedStoryBoardViewControllerIDBottomBrowseSequence;
extern NSString *const mhedStoryBoardViewControllerIDMealSummary;

extern NSString *const mhedStoryBoardViewControllerIDMealFillinSequence;
extern NSString *const mhedStoryBoardViewControllerIDQuickCaptureSequence;

typedef NS_ENUM(NSInteger, MHEDSplitViewContainerViewLocation) {
    MHEDSplitViewContainerViewLocationTop = 1,
    MHEDSplitViewContainerViewLocationBottom,
};


@class EDRestaurant;


@interface MHEDSplitViewController : UIViewController <MHEDObjectsDictionaryProtocol>



@property (nonatomic, strong) MHEDObjectsDictionary *objectsDictionary;



@property (nonatomic) BOOL isTopViewHidden;

@property (weak, nonatomic) IBOutlet UIView *mhedTopView;
@property (weak, nonatomic) IBOutlet UIView *mhedBottomView;
@property (weak, nonatomic) IBOutlet UIView *mhedShowHideView;


@property (weak, nonatomic) IBOutlet UIButton *mhedShowHideButton;
- (IBAction)mhedShowHideButtonPress:(id)sender;


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) BOOL keyboardVisible;


// Name
//@property (nonatomic, strong) NSString *objectName;
@property (nonatomic) BOOL defaultName;

// Tags
//@property (nonatomic, strong) NSArray *tagsList;
@property (nonatomic) BOOL favorite;

// Meal Medication Segmented Control
@property (nonatomic) BOOL medication;

// Restaurant
//@property (nonatomic, strong) EDRestaurant *restaurant;

// Objects - Food, medication, symptoms, etc.
//@property (nonatomic, strong) NSDictionary *objectsDictionary;

// Date
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
//@property (nonatomic, strong) NSDate *date1;

//// keep track which indexPath points to the cell with UIDatePicker, if nil then it is NOT visible,
//@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
//@property (nonatomic) NSInteger pickerCellRowHeight;








#pragma mark - Container View Controller Methods


//- (void) handleShowHideButtonPress:(id)sender;

//- (void) displayContentController: (UIViewController*) content;

- (void) view:(UIView *) view displayContentController:(UIViewController *)content;

- (void) displayContentController:(UIViewController *) content inContainerLocation: (MHEDSplitViewContainerViewLocation) location;

- (void) displayMealFillinViewControllerInContainerLocation: (MHEDSplitViewContainerViewLocation) location;

- (void) displayMealSummaryViewControllerInContainerLocation:(MHEDSplitViewContainerViewLocation) location;

- (void) displayBottomBrowseViewControllerInContainerLocation:(MHEDSplitViewContainerViewLocation) location;

- (void) displayQuickCaptureSequenceInContainerLocation:(MHEDSplitViewContainerViewLocation) location;


#pragma mark - MHEDFoodSelectionViewControllerDataSource methods

//- (NSArray *) mealsList;
//- (void) setNewMealsList: (NSArray *) newMealsList;
//- (void) addToMealsList: (NSArray *) meals;
//- (void) removeMealsFromMealsList: (NSArray *) meals;
//- (BOOL) doesMealsListContainMeals:(NSArray *) meals;
//
//- (NSArray *) ingredientsList;
//- (void) setNewIngredientsList: (NSArray *) newIngredientsList;
//- (void) addToIngredientsList: (NSArray *) ingredients;
//- (void) removeIngredientsFromIngredientsList: (NSArray *) ingredients;
//- (BOOL) doesIngredientsListContainIngredients:(NSArray *) ingredients;
//
//- (NSArray *) medicationsList;
//- (void) setNewMedicationsList: (NSArray *) newMedicationsList;
//- (void) addToMedicationsList: (NSArray *) medications;
//- (void) removeMedicationsFromMedicationsList: (NSArray *) medications;
//- (BOOL) doesMedicationsListContainMedications:(NSArray *) medications;


#pragma mark - MHEDObjectsDictionaryProtocol and helper methods

- (MHEDObjectsDictionary *) objectsDictionary;

- (NSArray *) mealsList;
- (NSArray *) ingredientsList;
- (NSArray *) medicationsList;
- (NSArray *) tagsList;
- (EDRestaurant *) restaurant;
- (NSArray *) imagesList;
- (NSDate *) date;
- (NSString *) objectName;



#pragma mark - Create Meal Methods

- (void) handleDoneButton: (id) sender;

- (void) createMeal;



@end
