//
//  EDData+Meal.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/10/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDData.h"

@interface EDData (Meal)

// Meals ////////////////////////////////////////////////

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



// Eaten Meals ////////////////////////////////////////////////
- (void) eatMeal: (EDMeal *) aMeal atTime: (NSString *) time;
- (void) eatMealNow: (EDMeal *) aMeal;
- (void) removeEatenMeal: (EDMeal *) aMeal atTime: (NSString *) time;

// sorting
- (NSArray *) sortEatenMealsByTime: (NSDictionary *) eatenMeals;
- (NSArray *) sortAllEatenMealsByTime;

@end
