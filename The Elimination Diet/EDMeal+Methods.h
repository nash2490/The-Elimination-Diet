//
//  EDMeal+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//
/*
 - A EDMeal is composed of ingredients and other meals 
 -- it is a group of food items that is either
        - (a) a food recipe that is meant to be eaten without having to add something
                - Ice cream sundae
                - cheese burger w/ lettuce, pickle and ketchup
        - (b) event where you ate food items
                - steak, mashed potatoes, steak sauce, cherry soda
                - cheese burger, french fries, lemonade
 
 -- if you don't know whether something should be an ingredient or a meal, choose ingredient
        - you can always add an ingredient to a meal, but you can't add a meal to an ingredient
 
 - ingredientsAdded -- ingredients not inherited by the parent meals it contains
 
 - ingredientsSecondary -- ingredients that are contained in ingredientsAdded or those in meals from ParentMeals
 
 - mealParents -- meals contained in this meal
 
 - mealChildren -- meals that contain this one
 
 - types -- the types that are from ingredientsAdded, ingredientsSecondary
 
 - ifEliminated -- a pointer to an instance of EDEliminatedIngredient or nil if this ingredient is not, or has never been, eliminated
 
 - tags -- set of tags for this ingredient
 
 - context -- the context through which we add the EDType to the database
 */

#import "EDMeal.h"

#define MEAL_ENTITY_NAME @"EDMeal"

@class EDRestaurant;

@interface EDMeal (Methods)


#pragma mark - Creation Methods
// to create in app, have the user supply the info fit for a creation method
// and then just ask if the user wants to give more info
//          - children

// universal method -
//      - mealParents and ingredientsAdded
//      - sets mealChildren to empty
//      - generates ingrSec and types
//      - asks for tags or sets to empty set
+ (EDMeal *) createMealWithName:(NSString *)name
               ingredientsAdded:(NSSet *)added
                    mealParents:(NSSet *)meals
                     restaurant:(EDRestaurant *)restaurant
                           tags:(NSSet *)tags
                     forContext:(NSManagedObjectContext *)context;

+ (void) setUpDefaultMealsInContext:(NSManagedObjectContext *) context;


#pragma mark - property helper methods

- (NSSet *) descendants;
- (NSSet *) ancestors;

- (NSSet *) addedIngredientAncestors;

#pragma mark - Getting transient properties

- (NSSet *) determineTypes;
- (NSSet *) determineIngredientsSecondary;
- (NSSet *) determineAllTransientProperties;


#pragma mark - Elimination Methods

// determines if the meal contains something that is eliminated
//      - an added ingredient
//      - a parent meal
- (BOOL) isCurrentlyEliminated;


#pragma mark - Fetching

/// fetch meals and medication
+ (NSFetchRequest *) fetchAllMeals;

/// fetch only meals - not medication
+ (NSFetchRequest *) fetchOnlyMeals;

/// gets meals that have the favorite tag
+ (NSFetchRequest *) fetchFavoriteMeals;

/// gets favorite meals - excludes medication
+ (NSFetchRequest *) fetchFavoriteMealsNonMedication;


@end
