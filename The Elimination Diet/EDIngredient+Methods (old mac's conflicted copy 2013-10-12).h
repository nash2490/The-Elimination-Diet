//
//  EDIngredient+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//
/*
 - A EDIngredient is a food product that is either
    - (a) a direct instance of a type
    - (b) composed of other ingredients
     
    -- Exception
        - ingredients with unknown components, such as Modified Food Starch, have different types, but no real intermediate ingredients
 
 - ingredientChildren -- the ingredients that contain this ingredient (think parents exist before children)
 
 - ingredientParents -- the ingredients that this ingredient contains
 
 - mealsPrimary -- meals that directly contain this ingredient
 
 - mealsSecondary -- meals that contain the a meal from mealsPrimary and/or contain an ingredient from ingredientChildren
 
 - typesPrimary -- Types that this ingredient directly is - really this is only one type since the ingredient (if having a primary type) is an instance of that type, and since types have no intersection then they cannot have 2 distinct primary types
        ------ However, we will not always have a clear idea of what an ingredient is made of and it is better to have multiple primary types (or have associations to other ingredients) than to have no types chosen
 
 - typesSecondary -- types inherited from other ingredients (i.e. the types either primary or secondary from ingredientParents)
 
 - ifEliminated -- a pointer to an instance of EDEliminatedIngredient or nil if this ingredient is not, or has never been, eliminated
 
 - tags -- set of tags for this ingredient
 
 - context -- the context through which we add the EDType to the database
 */

#import "EDIngredient.h"

#define INGREDIENT_ENTITY_NAME @"EDIngredient"

@interface EDIngredient (Methods)

// use when ingredient is an instance of a type (or specific type unknown so we specify multiple)
+ (EDIngredient *) createIngredientWithName:(NSString *) name
                               primaryTypes:(NSSet *) typesPrimary
                                       tags:(NSSet *) tags
                                withContext:(NSManagedObjectContext *) context;

// use when ingredient is from other ingredients
+ (EDIngredient *) createIngredientWithName:(NSString *)name
                          ingredientParents:(NSSet *)ingredParents
                                       tags:(NSSet *) tags
                                withContext:(NSManagedObjectContext *)context;



// Ingredients ////////////////////////////////////////////////
/*
 
 

- (EDIngredient *) ingredientForName: (NSString *) ingredientName;
- (NSSet *) ingredientsForNames: (NSSet *) ingredientNames;
//- (NSSet *) typesForIngredient: (EDIngredient *) aIngredient;
- (NSSet *) typesForIngredients: (NSSet *) ingredientNames; // sums the properties of the ingredients with the listed names

- (NSSet *) secondaryIngredientsOfIngredients: (NSSet *) ingredientNames;
- (NSSet *) secondaryTypesOfIngredient: (EDIngredient *) aIngredient;

// sorting
- (NSArray *) sortAllIngredientsByName;  //output is NSArray of NSString sorted from A - Z
- (NSDictionary *) sortAllIngredientsByType;

- (NSArray *) sortIngredientsByName: (NSSet *) ingredientNames;
- (NSDictionary *) sortIngredientsByType: (NSSet *) ingredientNames;
*/

@end
