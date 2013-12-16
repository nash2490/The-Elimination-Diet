//
//  MHEDSelectionViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/11/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDCoreDataTableViewController.h"

#import "EDFood+Methods.h"

#import "MHEDObjectsDictionary.h"

@class EDMeal, EDIngredient, EDMedication, MHEDObjectsDictionary;

//@protocol MHEDFoodSelectionViewControllerDataSource <NSObject>
//
//@optional
//
//- (MHEDObjectsDictionary *) objectsDictionary;
//
//- (void) restaurant;
//
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
//- (NSArray *) imagesArray;
//- (void) addToImagesArray: (NSArray *) images;
//- (void) removeImagesFromImagesArray: (NSArray *) images;
//
//// symptoms???
//
//@end

//@protocol MHEDFoodSelectionViewControllerDelegate <NSObject>
//
//@optional
//
//- (void) updateTableView
//
//@end





@interface MHEDFoodSelectionViewController : EDCoreDataTableViewController


@property (nonatomic, weak) id <MHEDObjectsDictionaryProtocol> delegate;

@property (nonatomic, strong) NSString *previousBrowseControllerTitle;


//@property (nonatomic) BOOL medicationFind;
//
//@property (nonatomic, strong) EDRestaurant *restaurant;
//@property (nonatomic, strong) NSArray *medicationList;
//@property (nonatomic, strong) NSArray *mealsList;
//@property (nonatomic, strong) NSArray *ingredientsList;
@property (nonatomic) FoodSortType sortBy;
@property (nonatomic) FoodTypeForTable tableFoodType;

// Must return an array of distinct NSNumber ints in [0, 1, ..., # of sections - 1]
- (NSArray *) mhedSections;
- (NSArray *)mhedSectionIndexTitles;
- (id) mhedObjectAtIndexPath: (NSIndexPath *) indexPath;

@end
