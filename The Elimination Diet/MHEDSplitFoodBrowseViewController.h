//
//  MHEDSplitFoodBrowseViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDSplitViewController.h"

#import "MHEDFoodSelectionViewController.h"

extern NSString *const mhedFoodDataUpdateNotification;




@class EDRestaurant;

@interface MHEDSplitFoodBrowseViewController : MHEDSplitViewController <MHEDFoodSelectionViewControllerDataSource>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) BOOL keyboardVisible;


// Name
@property (nonatomic, strong) NSString *objectName;
@property (nonatomic) BOOL defaultName;

// Tags
@property (nonatomic, strong) NSArray *tagsList;
@property (nonatomic) BOOL favorite;

// Meal Medication Segmented Control
@property (nonatomic) BOOL medication;

// Restaurant
@property (nonatomic, strong) EDRestaurant *restaurant;

// Objects - Food, medication, symptoms, etc.
@property (nonatomic, strong) NSDictionary *objectsDictionary;

// Date
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *date1;

// keep track which indexPath points to the cell with UIDatePicker, if nil then it is NOT visible,
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (nonatomic) NSInteger pickerCellRowHeight;


#pragma mark - MHEDFoodSelectionViewControllerDataSource methods

- (NSArray *) mealsList;
- (void) setNewMealsList: (NSArray *) newMealsList;
- (void) addToMealsList: (NSArray *) meals;
- (void) removeMealsFromMealsList: (NSArray *) meals;
- (BOOL) doesMealsListContainMeals:(NSArray *) meals;

- (NSArray *) ingredientsList;
- (void) setNewIngredientsList: (NSArray *) newIngredientsList;
- (void) addToIngredientsList: (NSArray *) ingredients;
- (void) removeIngredientsFromIngredientsList: (NSArray *) ingredients;
- (BOOL) doesIngredientsListContainIngredients:(NSArray *) ingredients;

- (NSArray *) medicationsList;
- (void) setNewMedicationsList: (NSArray *) newMedicationsList;
- (void) addToMedicationsList: (NSArray *) medications;
- (void) removeMedicationsFromMedicationsList: (NSArray *) medications;
- (BOOL) doesMedicationsListContainMedications:(NSArray *) medications;


@end
