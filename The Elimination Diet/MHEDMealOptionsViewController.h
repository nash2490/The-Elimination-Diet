//
//  MHEDMealOptionsViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MHEDTableViewController.h"


@class EDRestaurant;




@interface MHEDMealOptionsViewController : MHEDTableViewController


//#pragma mark - Default Medication Methods
//// ---------------------------------------
//- (void) handleMedDoneButton;
//- (NSString *) medNameAsDefault;
//- (NSString *) medNameForDisplay;
//
//- (void) medNameTextViewEditable: (UITextView *) textView;
//
//
//- (NSMutableDictionary *) medAndIngredientCellDictionary;


#pragma mark - Subclass methods to Override

// override numberOfRows, and most other table delegate and data source methods

- (NSArray *) defaultDataArray;
- (void) nameTextViewEditable: (UITextView *) textView;

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


/// called before table is reloaded in VWA,
- (void) setUpBeforeTableLoad;
//




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
//


#pragma mark - Create Meal Methods

- (void) handleDoneButton: (id) sender;

//- (void) createMeal;



@end
