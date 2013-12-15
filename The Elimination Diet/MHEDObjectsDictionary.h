//
//  MHEDObjectsDictionary.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/14/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EDRestaurant;


extern NSString *const mhedFoodDataUpdateNotification;


@interface MHEDObjectsDictionary : NSObject




@property (nonatomic, strong) NSDictionary *objectsDictionary;


- (instancetype) initWithDefaults;




- (EDRestaurant *) restaurant;

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

- (NSArray *) imagesArray;
- (void) addToImagesArray: (NSArray *) images;
- (void) removeImagesFromImagesArray: (NSArray *) images;

// symptoms???



@end
