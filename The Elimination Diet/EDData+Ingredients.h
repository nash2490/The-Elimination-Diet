//
//  EDData+Ingredients.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/10/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDData.h"

@interface EDData (Ingredients)

// Ingredients ////////////////////////////////////////////////
- (EDIngredient *) newIngredient: (EDIngredient *) aIngredient;
- (void) removeIngredient: (NSString *) ingredientName;
- (EDIngredient *) replaceIngredient: (EDIngredient *) aIngredient;

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


// ingredient types ////////////////////////////////////////////////

- (void) newIngredientType: (NSString *) aType;
- (void) removeIngredientType: (NSString *) aType;


@end
