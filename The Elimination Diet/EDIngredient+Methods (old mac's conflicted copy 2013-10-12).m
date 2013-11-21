//
//  EDIngredient+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDIngredient+Methods.h"

@implementation EDIngredient (Methods)

// nothing really special to do here
//      - this ingredient has no ingredients or meals
//      - has no secondary types
+ (EDIngredient *) createIngredientWithName:(NSString *)name
                               primaryTypes:(NSSet *)typesPrimary
                                       tags:(NSSet *)tags
                                withContext:(NSManagedObjectContext *)context
{
    EDIngredient *newIngredient = [NSEntityDescription insertNewObjectForEntityForName:INGREDIENT_ENTITY_NAME
                                                                inManagedObjectContext:context];
    
    newIngredient.name = name;
    newIngredient.uniqueID = [[NSDate date] description];
    newIngredient.ifEliminated = nil;
    
    if (typesPrimary) {
        newIngredient.typesPrimary = typesPrimary;
    }
    
    newIngredient.typesSecondary = [[NSSet alloc] init];
    
    newIngredient.ingredientParents = [[NSSet alloc] init];
    newIngredient.ingredientChildren = [[NSSet alloc] init];
    
    
    
    newIngredient.mealsPrimary = [[NSSet alloc] init];
    newIngredient.mealsSecondary = [[NSSet alloc] init];
    
    if (tags) {
        newIngredient.tags = tags;
    }
    
    return newIngredient;
}

// sets ingredientParents,
//      - sets typesSecondary to the types of ingredientParents
//      - sets all other properties to nil or empty set
+ (EDIngredient *) createIngredientWithName:(NSString *)name
                          ingredientParents:(NSSet *)ingredParents
                                       tags:(NSSet *)tags
                                withContext:(NSManagedObjectContext *)context
{
    EDIngredient *newIngredient = [NSEntityDescription insertNewObjectForEntityForName:INGREDIENT_ENTITY_NAME
                                                                inManagedObjectContext:context];
    
    newIngredient.name = name;
    newIngredient.uniqueID = [[NSDate date] description];
    newIngredient.ifEliminated = nil;
    
    if (tags) {
        newIngredient.tags = tags;
    }
    
    if (ingredParents) {
        newIngredient.ingredientParents = ingredParents;
        newIngredient.ingredientChildren = [[NSSet alloc] init];
        
        // get the types (primary and secondary) from parent ingredients
        NSMutableSet *mutIngred = [[NSMutableSet alloc] init];
        for (EDIngredient *ingred in ingredParents) {
            [mutIngred unionSet:ingred.typesPrimary];
            [mutIngred unionSet:ingred.typesSecondary];
        }
        
        newIngredient.typesSecondary = [mutIngred copy];
        newIngredient.typesPrimary = [[NSSet alloc] init];
        
        newIngredient.mealsPrimary = [[NSSet alloc] init];
        newIngredient.mealsSecondary = [[NSSet alloc] init];
        
    }

    return newIngredient;
}


// Validation Helper Methods
// ------------------------------------------------------


// Given a set of primary ingredients, this returns the secondary ingredients by unionning the ingredientParents from the ingredients
///     - notice that we do not need to specify the type here
// returns empty set if input is nil or empty
+ (NSSet *) secondaryIngredientsForPrimaryIngredients: (NSSet *) primary;
{
    NSMutableSet *mutSecondaryIngredients = [[NSMutableSet alloc] init];
    if (primary) {
        for (EDIngredient *ingredient in primary) {
            [mutSecondaryIngredients unionSet: ingredient.ingredientParents];
        }
    }
    
    return [mutSecondaryIngredients copy];
}



// Given the primary and secondary ingredients, this returns the meals that contains them
// returns empty set if input is nil or empty
+ (NSSet *) mealsForIngredientsPrimary: (NSSet *) primary
                          andSecondary: (NSSet *) secondary
{
    // get the primary and secondary meals for each of the sets of ingredients
    NSMutableSet *mealsFromPrimary = [[NSMutableSet alloc] init];
    if (primary) {
        for (EDIngredient *ingredient in primary) {
            [mealsFromPrimary unionSet:ingredient.mealsPrimary];
            [mealsFromPrimary unionSet:ingredient.mealsSecondary];
        }
    }
    
    NSMutableSet *mealsFromSecondary = [[NSMutableSet alloc] init];
    if (secondary) {
        for (EDIngredient *ingredient in secondary) {
            [mealsFromSecondary unionSet:ingredient.mealsPrimary];
            [mealsFromSecondary unionSet:ingredient.mealsSecondary];
        }
    }
    
    [mealsFromPrimary unionSet:mealsFromSecondary];
    return [mealsFromSecondary copy];
}



// ingredients
////////////////////////////////////////////////
/*




- (EDIngredient *) ingredientForName: (NSString *) ingredientName {
    return [self.ingredients objectForKey:ingredientName];
}

- (NSSet *) ingredientsForNames: (NSSet *) ingredientNames {
    
    NSMutableSet *mutIngredients = [[NSMutableSet alloc] initWithCapacity:[ingredientNames count]];
    
    for (NSString *ingrName in ingredientNames) {
        [mutIngredients addObject:[self ingredientForName:ingrName]];
    }
    return [mutIngredients copy];
}

- (NSSet *) typesForIngredient: (EDIngredient *) aIngredient
{
    if (aIngredient) {
        return aIngredient.types;
    }
    else {
        return nil;
    }
}

- (NSSet *) typesForIngredients:(NSSet *)ingredientNames
{
    NSMutableSet *mutTypes = [[NSMutableSet alloc] init];
    for (NSString *ingrName in ingredientNames) {
        EDIngredient *ingr = [self ingredientForName:ingrName];
        if (ingr) {
            [mutTypes unionSet:ingr.types];
        }
    }
    return [mutTypes copy];
}

- (NSSet *) mealsWithIngredient: (NSString *) ingredientName
{
    EDIngredient *ingr = [self ingredientForName:ingredientName];
    NSMutableSet *meals = [[NSMutableSet alloc] init];
    
    if (ingr) {
        NSArray *allMeals = [self.meals allKeys];
        for (NSString *mealName in allMeals) {
            if ([self doesMeal:mealName containIngredient:ingredientName]) {
                [meals addObject:mealName];
            }
        }
    }
    
    
    return meals;
}


- (NSSet *) secondaryIngredientsOfIngredients: (NSSet *) ingredientNames
{
    NSMutableSet *secondaryIngredients = [[NSMutableSet alloc] init];
    
    for (NSString *ingrName in ingredientNames) {
        EDIngredient *ingr = [self ingredientForName:ingrName];
        
        if (ingr) {
            [secondaryIngredients unionSet:ingr.types];
        }
    }
    return [secondaryIngredients copy];
}

// assumes that the secondary ingredients have the correct types,
- (NSSet *) secondaryTypesOfIngredient:(EDIngredient *)aIngredient
{
    return [self typesForIngredients:aIngredient.containedIngredients];
}


- (NSArray *) sortAllIngredientsByName {
    return [self sortIngredientsByName:[[NSSet alloc] initWithArray:[self.ingredients allKeys]]];
}

- (NSDictionary *) sortAllIngredientsByType {
    return [self sortIngredientsByType:[[NSSet alloc] initWithArray:[self.ingredients allKeys]]];
}

- (NSArray *) sortIngredientsByName: (NSSet *) ingredientNames {
    //NSSortDescriptor *byName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    //NSArray *sortedMeals = [ingredients sortedArrayUsingDescriptors:@[byName]];
    //return [[NSDictionary alloc] initWithObjects:@[sortedMeals] forKeys:@[@"DEFAULT"]];
    
    NSArray *arrayOfIngredients = [[NSArray alloc] init];
    
    if (ingredientNames) {
        arrayOfIngredients = [ingredientNames allObjects];
    }
    
    return [self sortArrayOfString:arrayOfIngredients];
}

// dictionary of keys = (nsstring) types, objects = (nsarray) of ingredients
// ingredient in array iff it is of type according to key
// PAIR THE RUN OF THIS WITH ASSIGNMENT OF tableHeaders = ingredientTypes
- (NSDictionary *) sortIngredientsByType: (NSSet *) ingredientNames {
    
    NSMutableDictionary *ingredientsByTypes = [[NSMutableDictionary alloc] init];
    
    // for every type we make an entry in the dictionary of those ingredients having that type
    for (NSString *aType in self.ingredientTypes) {
        
        /// predicate, evaluatedObject is an ingredients
        // -- gets the (NSArray) ingredient.types and checks to see if it contains
        //     the object aType
        
        NSPredicate *predForType = [NSPredicate predicateWithBlock: ^BOOL(id evaluatedObject, NSDictionary *bindings){
            id array = [evaluatedObject valueForKeyPath:@"types"];
            
            if ([array respondsToSelector:@selector(containsObject:)]) {
                return [array performSelector:@selector(containsObject:) withObject:aType];
            }
            return FALSE;
        }];
        
        NSSet *filteredSet = [[self ingredientsForNames:ingredientNames] filteredSetUsingPredicate:predForType];
        
        NSSortDescriptor *sortByNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        
        NSArray *orderedIngredients = [filteredSet sortedArrayUsingDescriptors:@[sortByNameDescriptor]];
        
        [ingredientsByTypes setObject:orderedIngredients forKey:aType];
    }
    
    return ingredientsByTypes;
}

*/
@end
