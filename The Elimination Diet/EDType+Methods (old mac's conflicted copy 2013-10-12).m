//
//  EDType+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDType+Methods.h"
#import "EDIngredient+Methods.h"

@implementation EDType (Methods)

// Creation Methods
//-----------------------------------------------------
+ (EDType *) createTypeWithName:(NSString *)name
             primaryIngredients:(NSSet *)primaryIngred
                           tags:(NSSet *)tags
                     forContext:(NSManagedObjectContext *)context
{
    // check if a type with the same name already exists
    NSPredicate *namePred = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSFetchRequest *fetchType = [NSFetchRequest fetchRequestWithEntityName:TYPE_ENTITY];
    fetchType.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[namePred]];
    
    NSError *error;
    NSArray *sameObjects = [context executeFetchRequest:fetchType error:&error];
    
    // if there are not types with this name then lets create it and check its values
    if (![sameObjects count]) {
        
        EDType *temp = [NSEntityDescription insertNewObjectForEntityForName:TYPE_ENTITY
                                                     inManagedObjectContext:context];
        
        // set object properties
        temp.name = name;
        temp.uniqueID = [[NSDate date] description];
        
        // if there are primary ingredients then set them and set the secondary and meals
        if (primaryIngred) { 
            [temp addIngredientsPrimary:primaryIngred];
            [temp addIngredientsSecondary:[[self class] secondaryIngredientsForPrimaryIngredients:temp.ingredientsPrimary]];
            [temp addMeals:[[self class] mealsForIngredientsPrimary:temp.ingredientsPrimary
                                                       andSecondary:temp.ingredientsSecondary]];
        }

        temp.ifEliminated = nil;
        
        
        if (tags) { // if there are tags then set them
            temp.tags = tags;
        }
        else { // otherwise set as empty set
            temp.tags = [[NSSet alloc] init];
        }
        
        return temp;
    }
    else {
        return nil;
    }
}

+ (EDType *) createTypeWithName:(NSString *)name
                           tags:(NSSet *)tags
                     forContext:(NSManagedObjectContext *)context
{
    // just call the higher level initializer
    return [EDType createTypeWithName:name
                   primaryIngredients:nil
                                 tags:tags
                           forContext:context];
}


// Property setting Helper Methods
// ------------------------------------------------------

// takes a set of sets and unions them, producing one set (method to be added to NSSet in category)
+ (NSSet *) unionOfSets:(NSSet *) setOfSets
{
    NSSet *temp = [[NSSet alloc] init];
    for (NSSet *set in setOfSets) {
        temp = [temp setByAddingObjectsFromSet:set];
    }
    return temp;
}
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

// Fetching
//---------------------------------------------------------------

// find the EDType with this uniqueID
+ (EDType *) typeForUniqueID:(NSString *)uniqueID
                  forContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchID = [NSFetchRequest fetchRequestWithEntityName:TYPE_ENTITY];
    
    fetchID.predicate = [NSPredicate predicateWithFormat:@"uniqueID = %@", uniqueID];
    
    NSError *error;
    NSArray *fetchedTypes = [context executeFetchRequest:fetchID error:&error];
    
    if (fetchedTypes && [fetchedTypes count]) {
        
    }
}

// find the EDType with the given value for the property associated with key path
+ (EDType *) typeForValue:(id)value
                ofKeyPath:(NSString *)path
               forContext:(NSManagedObjectContext *)context
{
    
}


// Modify properties
//---------------------------------------------------------------

- (void) clearValueAtKeyPath: (NSString *) path
{
    
}


@end
