//
//  EDType+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//



#import "EDType+Methods.h"

#import "EDFood+Methods.h"

#import "EDMeal+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDEliminatedType+Methods.h"

#import "NSSet+MoreSetOperations.h"
#import "NSError+MultipleErrors.h"

@implementation EDType (Methods)

// Creation Methods
//-----------------------------------------------------

// creates a new type
//      - if one of the same name already exists, then add primaryIngredients to it and return
//      - if two or more of the same name exists, then ERROR
+ (EDType *) createTypeWithName:(NSString *)name
             primaryIngredients:(NSSet *)primaryIngred
                           tags:(NSSet *)tags
                     forContext:(NSManagedObjectContext *)context
{
    // check if a type with the same name already exists
    NSPredicate *namePred = [NSPredicate predicateWithFormat:@"name like[cd] %@", name];
    
    NSFetchRequest *fetchType = [NSFetchRequest fetchRequestWithEntityName:TYPE_ENTITY_NAME];
    fetchType.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[namePred]];
    
    NSError *error;
    NSArray *sameObjects = [context executeFetchRequest:fetchType error:&error];
    
    // if there are not types with this name then lets create it and check its values
    if (![sameObjects count]) {
        
        EDType *temp = [NSEntityDescription insertNewObjectForEntityForName:TYPE_ENTITY_NAME
                                                     inManagedObjectContext:context];
        
        // set object properties
        temp.name = name;
        temp.uniqueID = [temp createUniqueID];
        
        // if there are primary ingredients then set them and set the secondary and meals
        if (primaryIngred) { 
            temp.ingredientsPrimary = primaryIngred;
            temp.ingredientsSecondary = [temp determineIngredientsSecondary];
        }

        temp.whenEliminated = nil;
        temp.meals = [[NSMutableSet alloc] init];
        
        //NSLog(@"meals has %i", [temp.meals count]);
        
        if (tags) { // if there are tags then set them
            temp.tags = tags;
        }
        else { // otherwise set as empty set
            temp.tags = [[NSSet alloc] init];
        }
        
        return temp;
    }
    
    // named object already exists, consolidate ingredientsPrimary, but still error
    else if ([sameObjects count] == 1){
        
        EDType *temp = sameObjects[0];
        [temp addIngredientsPrimary:primaryIngred];
        //NSLog(@"A Type with name = %@ existed, so we combined their primaryIngredients", name);
        
        return temp;
    }
    else { // 2+ objects with same name
        //NSLog(@"%d Types exist with name = %@, which is not allowed", [sameObjects count], name);
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



+ (void) setUpDefaultIngredientTypesWithContext: (NSManagedObjectContext *) context
{
    NSArray *iTypes = @[@"Dairy", @"Soy", @"Tree Nuts", @"Gluten", @"Eggs", @"Fish", @"Shellfish", @"Poultry", @"Beef", @"Pork", @"Grains (gluten-free)", @"Fruit", @"Vegetables", @"Beans", @"Other"]; // Starches??
    
    
    
    for (NSString *typeName in iTypes) {
        [EDType createTypeWithName:typeName tags:nil forContext:context];
    }
}

- (void) awakeFromFetch
{
    [super awakeFromFetch];
}

// Elimination Methods
//---------------------------------------------------------------



// Fetching
//---------------------------------------------------------------


+ (NSFetchRequest *) fetchAllTypes
{
    return [EDFood fetchObjectsForEntityName:TYPE_ENTITY_NAME];
}

- (NSFetchRequest *) fetchMealsWithType
{
    
    
    //return [EDFood fetchObjectsForEntityName:MEAL_ENTITY_NAME setKeyPath:@"types" containsValue:self];
    
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:MEAL_ENTITY_NAME];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"ANY types.name = %@", self.name];

    fetch.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[pred]];
    
    return fetch;
    
}


// find the EDType with this uniqueID
+ (EDType *) typeForUniqueID:(NSString *)uniqueID
                  forContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchID = [NSFetchRequest fetchRequestWithEntityName:TYPE_ENTITY_NAME];
    
    fetchID.predicate = [NSPredicate predicateWithFormat:@"uniqueID = %@", uniqueID];
    
    NSError *error;
    NSArray *fetchedTypes = [context executeFetchRequest:fetchID error:&error];
    
    NSString *descrString;
    NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionary];
    
    EDType *result; 
    
    switch ([fetchedTypes count]) {
     
        case 0:
            // error - no objects
            descrString = @"There were no Types with the searched uniqueId";
            userInfoDict[NSLocalizedDescriptionKey] = descrString;
            
            result = nil;
            break;
            
        case 1:
            result = fetchedTypes[0];
            break;
                    
        default:
            
            if (fetchedTypes) {
                // happens when there are 2 or more objects
                // change error object
                descrString = @"There were multiple objects with the same uniqueId";
                userInfoDict[NSLocalizedDescriptionKey] = descrString;
                
                result = nil;
            }
            else { // fetchedTypes = nil
                // error - fetch didn't work, the error we want is returned by the fetch request
                result = nil;
            }
            
            break;
    }
    
    if (&error != NULL) {
        // create the error
        NSError * typeValidationError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSManagedObjectValidationError userInfo:userInfoDict];

        
        // if there was no previous error (no fetch error)
        if (error == nil) {
            error = typeValidationError;
        }
        
        // if there was a previous error, then combine it with the existing one
        else {
            error = [NSError errorFromOriginalError:error error:typeValidationError];
        }
    }
    
    return result;
}

// find the EDType with the given value for the property associated with key path
+ (EDType *) typeForValue:(id)value
                ofKeyPath:(NSString *)path
               forContext:(NSManagedObjectContext *)context
{
    return nil;
}

// Determining transient properties
//// - we calculate the properties and set them
//// - **** only get a transient property directly if we know it was just calculated and set ***
//// -          , some methods give a property for free
//---------------------------------------------------------------


// ingredients secondary
- (NSSet *) determineIngredientsSecondary
{
    NSMutableSet *mutIngredientsSecondary = [NSMutableSet set];
    
    // for each ingr in Primary we add the descendants to the set
    for (EDIngredient *ingr in self.ingredientsPrimary) {
        [mutIngredientsSecondary addObjectsFromArray:[[ingr descendants] allObjects]];
    }
    
    NSSet *secondary = [mutIngredientsSecondary copy];
    
    if ([secondary intersectsSet:self.ingredientsPrimary]) {
        // then there is an error somewhere because a member of secondary cannot be primary
    }
    
    
    return secondary;
}

// meals
- (NSSet *) determineMeals
{
    
    
    NSMutableSet *mutMeals = [[NSMutableSet alloc] initWithCapacity:10];
    
    // for each ingr in Primary we add ingr.mealsPrimary and ingr.mealsSecondary (after we calculate it)
    for (EDIngredient *ingr in self.ingredientsPrimary) {
        //NSLog(@"ingr name = %@", ingr.name);
        [mutMeals addObjectsFromArray:[ingr.mealsPrimary allObjects]];
        [mutMeals addObjectsFromArray:[[ingr determineMealsSecondary] allObjects]];
    }
    
    NSSet *meals = [mutMeals copy];
    return meals;
}


// Modify properties
//---------------------------------------------------------------

- (void) clearValueAtKeyPath: (NSString *) path
{
    
}


// Validation methods
//---------------------------------------------------------------

- (BOOL)validateForInsert:(NSError **)error
{
    BOOL propertiesValid = [super validateForInsert:error];
    if (!propertiesValid) {
        
        NSLog(@"%@", [*error localizedDescription]);
        return FALSE;
    }
    
    BOOL consistencyValid = [self validateConsistency:error];
    return (propertiesValid && consistencyValid);
}

- (BOOL)validateForUpdate:(NSError **)error
{
    BOOL propertiesValid = [super validateForUpdate:error];
    if (!propertiesValid) {
        
        NSLog(@"%@", [*error localizedDescription]);
        return FALSE;
    }
    
    BOOL consistencyValid = [self validateConsistency:error];
    return (propertiesValid && consistencyValid);
}

// **** CENTRAL VALIDATION METHOD ****
/// - 
- (BOOL)validateConsistency:(NSError **)error
{
    
    // check whether or not there are overlapping eliminatedObject
    BOOL valid = [super validateConsistency: error];
    
    if (!valid) {
        NSLog(@"%@", [*error localizedDescription]);
    }
    return valid;
}

@end