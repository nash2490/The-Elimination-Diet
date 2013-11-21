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

@interface EDMeal (Methods)

// Meals ////////////////////////////////////////////////
/*
- (EDMeal *) newMeal: (EDMeal *) aMeal; // checks for uniqueness based on name - returns the meal if the meal was added to EDData

- (void) removeMeal: (NSString *) mealName;
- (EDMeal *) replaceMealWithMeal: (EDMeal *) aMeal;

- (EDMeal *) mealForName: (NSString *) aName;
- (NSSet *) mealsForNames: (NSSet *) mealNames; // returns set of EDMeal

- (NSSet *) mealsForMeal: (NSString *) mealName; // just returns the property meal.meals (strings)
- (NSSet *) ingredientsForMeal: (NSString *) mealName; // just returns the property meal.ingredients (strings)
- (NSSet *) ingredientsForMeals:(NSSet *) mealNames;  // sums the ingredients properties for the meals in the set

- (NSSet *) allIngredientsForMeal: (EDMeal *) aMeal;
- (BOOL) doesMeal: (NSString *) mealName containIngredient: (NSString *) ingredientName;

- (NSSet *) ingredientsNotInMeal: (EDMeal *) aMeal; // returns names of ingredients
- (NSSet *) mealsNotInMeal: (EDMeal *) aMeal; // returns names of meals

- (NSSet *) typesForMeal: (EDMeal *) aMeal;

- (NSString *) restaurantForMealName: (NSString *) mealName;

- (NSSet *) secondaryMealsOfMeal: (EDMeal *) aMeal; // returns names of meals
- (NSSet *) secondaryIngredientsOfMeal:(EDMeal *)aMeal; // returns names of ingredients

// search for the meals that contain the given ingredient, which includes secondary ingredients
- (NSSet *) mealsWithIngredient: (NSString *) ingredientName; //// NOT CREATED YET

// sorted arrays are NSArrays of NSStrings which reference the object, sorted from A to Z
- (NSArray *) sortAllMealsByName;
- (NSArray *) sortMealsByName: (NSSet *) mealNames;

- (NSDictionary *) sortAllMealsByIngredient;
- (NSDictionary *) sortMealsByIngredient: (NSSet *) mealNames;

- (NSArray *) sortAllMealsByPlace;
- (NSArray *) sortMealsByPlace: (NSSet *) mealNames;

*/
@end
