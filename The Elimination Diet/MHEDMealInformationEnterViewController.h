//
//  MHEDMealInformationEnterViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/7/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDTableViewController.h"

@protocol MHEDMealInformationEnterDelegate <NSObject>

@optional

- (EDRestaurant *) restaurant; // for meal/medication/restaurant creation
- (void) setNewRestaurant: (EDRestaurant *) restaurant;

- (NSArray *) tagsList; // for anything with tags
- (void) addToTagsList: (NSArray *) tags;
- (void) setNewTagsList: (NSArray *) newTagsList;

- (NSArray *) mealsList; // for meal creation
- (void) setNewMealsList: (NSArray *) newMealsList;
- (void) addToMealsList: (NSArray *) meals;

- (NSArray *) ingredientsList; // for meal/medicaiton creation
- (void) setNewIngredientsList: (NSArray *) newIngredientsList;
- (void) addToIngredientsList: (NSArray *) ingredients;

- (NSArray *) parentMedicationsList; // for medication creation
- (void) setNewMedicationsList: (NSArray *) newMedicationsList;
- (void) addToMedicationsList: (NSArray *) medications;

@end


@interface MHEDMealInformationEnterViewController : MHEDTableViewController



@end
