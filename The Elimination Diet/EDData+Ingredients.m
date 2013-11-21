//
//  EDData+Ingredients.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/10/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDData+Ingredients.h"
#import "EDData.m"

@implementation EDData (Ingredients)

// ingredients
////////////////////////////////////////////////

- (EDIngredient *) newIngredient: (EDIngredient *) aIngredient {
    
    EDIngredient *result = nil;
    
    if (self.ingredients == nil) {
        self.ingredients = [[NSDictionary alloc] initWithObjectsAndKeys:aIngredient, aIngredient.name, nil];
        result = aIngredient;
    }
    else {
        NSMutableDictionary *mutIngredients = [self.ingredients mutableCopy];
        [mutIngredients setObject:aIngredient forKey:aIngredient.name];
        self.ingredients = [mutIngredients copy];
        result = aIngredient;
    }
    return result;
}

- (void) removeIngredient:(NSString *) ingredientName {
    
    NSMutableDictionary *mutIngredients = [self.ingredients mutableCopy];
    [mutIngredients removeObjectForKey:ingredientName];
    self.ingredients = [mutIngredients copy];
}

- (EDIngredient *) replaceIngredient: (EDIngredient *) aIngredient {
    [self removeIngredient:aIngredient.name];
    return [self newIngredient:aIngredient];
}


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




// ingredient types
////////////////////////////////////////////////

- (void) newIngredientType: (NSString *) aType {
    if (self.ingredientTypes == nil) {
        self.ingredientTypes = [[NSArray alloc] initWithObjects: aType, nil];
    }
    else {
        NSMutableArray *mutIngredientTypes = [self.ingredientTypes mutableCopy];
        [mutIngredientTypes addObject:aType];
        self.ingredientTypes = [self sortArrayOfString:[mutIngredientTypes copy]];
    }
}

- (void) removeIngredientType: (NSString *) aType {
    NSMutableArray *mutIngredientTypes = [self.ingredientTypes mutableCopy];
    [mutIngredientTypes removeObject:aType];
    self.ingredientTypes = [mutIngredientTypes copy];
}


@end
