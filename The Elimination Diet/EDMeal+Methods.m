//
//  EDMeal+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDMeal+Methods.h"

#import "EDFood+Methods.h"
#import "EDMedication+Methods.h"

#import "EDIngredient+Methods.h"
#import "EDRestaurant+Methods.h"
#import "EDTag+Methods.h"

#import "NSError+MultipleErrors.h"


@implementation EDMeal (Methods)



#pragma mark - Creation Methods -
//-----------------------------------------------------
+ (EDMeal *) createMealWithName:(NSString *)name
               ingredientsAdded:(NSSet *)added
                    mealParents:(NSSet *)meals
                     restaurant:(EDRestaurant *)restaurant
                           tags:(NSSet *)tags
                     forContext:(NSManagedObjectContext *)context
{
    // check if a meal with the same name already exists
    NSFetchRequest *fetchMeal = [EDFood fetchObjectsForEntityName:MEAL_ENTITY_NAME withFoodName:name];
    
    NSError *error;
    NSArray *sameName = [context executeFetchRequest:fetchMeal error:&error];
    
    // unique will be used to determine if another object exists with the same
    //      - name
    //      - added ingredients
    //      - parents
    //      - restaurant
    
    BOOL unique = TRUE;
    
    EDMeal *dupMeal;
    
    if ([sameName count]) {
        for (int i = 0; i< [sameName count]; i++) {
            dupMeal = sameName[i];
            
            ///////// sending isEqual to nil object will always return nil
            // if restaurant exists then see if it is equal
            if (restaurant) {
                unique = [restaurant isEqual:dupMeal.restaurant];
            }
            // if restaurant DNE then the meal is the same only if there is no restaurant
            else if (!restaurant && dupMeal.restaurant)
            {
                unique = FALSE;
            }
            
            // added ingredients are the same if either
            //      - both are empty/nil
            //      - are set equal
            if (!added || ![added count]) {
                unique = unique && [dupMeal.ingredientsAdded count];
            }
            else if (added && dupMeal.ingredientsAdded){
                unique = unique && ![added isEqualToSet:dupMeal.ingredientsAdded];
            }
            
            // meal parents are the same if either
            //      - both are empty/nil
            //      - are set equal
            if (!meals || ![meals count]) {
                unique = unique && [dupMeal.mealParents count];
            }
            else if (meals && dupMeal.mealParents){ // if both exist and are NOT equal then its unique
                unique = unique && ![meals isEqualToSet:dupMeal.mealParents];
            }

            
            if (!unique) {
                
                // error - meal already exists
                
                // end the for loop
                i = [sameName count];
            }
        }
    }
    
    
    // if this meal is unique, then create it
    if (unique) {
        
        EDMeal *temp = [NSEntityDescription insertNewObjectForEntityForName:MEAL_ENTITY_NAME
                                                     inManagedObjectContext:context];
        
        // set object properties to obvious or empty;
        temp.name = name;
        temp.uniqueID = [temp createUniqueID];
        temp.restaurant = restaurant;
        temp.ingredientsAdded = [[NSSet alloc] init];
        temp.mealParents = [[NSSet alloc] init];
        temp.mealChildren = [[NSSet alloc] init];
        temp.timesEaten = [[NSSet alloc] init];
        temp.tags = [[NSSet alloc] init];

        // if there are ingredientsAdded then set them
        if (added) {
            temp.ingredientsAdded = added;
        }
        if (meals) {
            temp.mealParents = meals;
        }
        
        //[temp determineAllTransientProperties];

        if (tags) { // if there are tags then set them
            temp.tags = tags;
        }
        
        return temp;
    }
    
    else { // the meal already exists, so we should just return it
        return dupMeal;
    }
}


+ (void) setUpDefaultMealsInContext:(NSManagedObjectContext *)context
{
    [EDIngredient setUpDefaultIngredientsWithContext:context];
    
    NSArray *allMeals = [context executeFetchRequest:[EDMeal fetchAllMeals] error:nil];
    if ([allMeals count] < 100)
    {
        
        NSArray *burgerIngr = @[@"cheese", @"Beef",  @"Tomato", @"Mushrooms"];
        NSArray *tomatoSoupIngr = @[@"tomato", @"milk", @"wheat", @"parsley"];
        NSArray *chickenParm = @[@"chicken", @"wheat" @"cheese", @"Tomato"];
        
        
        
        NSDictionary *mealDictionary = @{@"Cheese Burger": burgerIngr,
                                         @"Tomato Soup": tomatoSoupIngr,
                                         @"Chicken Parm": chickenParm};
        
        NSError *mealError;
        
        for (NSString *mealName in [mealDictionary allKeys]) {
            NSFetchRequest *fetchForIngr = [EDFood fetchObjectsForEntityName:INGREDIENT_ENTITY_NAME withfoodNames:mealDictionary[mealName]];
            
            NSError *error;
            NSArray *ingrForMeal = [context executeFetchRequest:fetchForIngr error:&error];
            
            [EDMeal createMealWithName:mealName
                      ingredientsAdded:[NSSet setWithArray:ingrForMeal]
                           mealParents:nil
                            restaurant:nil
                                  tags:nil
                            forContext:context];
            
            // if there was no previous error, return the new error
            if (mealError == nil) {
                mealError = error;
            }
            // if there was a previous error, combine it with the existing one
            else {
                mealError = [NSError errorFromOriginalError:mealError error:error];
            }
        }
        
        for (int a=0; a < 39; a++) {
            EDMeal *randMeal = [EDMeal generateRandomMealInContext:context];
            if (a % 2) {
                //EDTag *favoriteTag = [EDTag getFavoriteTagInContext:context];
               // [randMeal addTagsObject:favoriteTag];
                //NSLog(@"%@", randMeal.name);
                
                randMeal.favorite = @(YES);
            }
            if (a % 5) {
                EDTag *newTag = [EDTag createTagWithName:@"new" inContext:context];
                [randMeal addTagsObject:newTag];
            }
            
            
            for (EDTag *tag in randMeal.tags) {
                //NSLog(@"tag = %@", tag.name);
            }
        }
    }
    
    
    
    //NSArray *allIngredient = [context executeFetchRequest:[EDIngredient fetchAllIngredients] error:&error];
    
    
}

+ (EDMeal *) generateRandomMealInContext: (NSManagedObjectContext *) context
{
    NSArray *allMeals = [context executeFetchRequest:[EDMeal fetchAllMeals] error:nil];
    NSArray *allIngr = [context executeFetchRequest:[EDIngredient fetchAllIngredients] error:nil];
    
    int numOfIngr = (arc4random() % (6)) +1 ;
    int numOfMeals = arc4random() % (3) ;
    
    NSMutableSet *mealIngr = [NSMutableSet setWithCapacity:numOfIngr];
    NSMutableSet *mealMeals = [NSMutableSet setWithCapacity:numOfMeals];
    
    NSString *mealName = [NSString stringWithFormat:@"Meal (%i, %i) - ", numOfIngr, numOfMeals];
    
    for (int i=0; i < numOfIngr; i++) {
        int randomIndex = arc4random() % [allIngr count];
        EDIngredient *newIngr = allIngr[randomIndex];
        [mealIngr addObject:newIngr];
    }
    
    NSArray *newIngrs = [[mealIngr valueForKey:@"name"] allObjects];
    NSString *ingrNames = [newIngrs componentsJoinedByString:@", "];
    mealName = [mealName stringByAppendingString:ingrNames];
    
    for (int j=0; j < numOfMeals; j++) {
        int randomIndex = arc4random() % [allMeals count];
        [mealMeals addObject:allMeals[randomIndex]];
    }
    
    
    
    return [EDMeal createMealWithName:mealName ingredientsAdded:mealIngr mealParents:mealMeals restaurant:nil tags:nil forContext:context];
}

# pragma mark - Property helper methods -
// ---------------------------------------------------------

// returns all the descendants (includes children) of the receiver
// --- makes sure no to create an infinite loop from self inheritence
//      --- if self inheritence does occur, the result will contain self,
//           which can be tested easily to determine validity
- (NSSet *) descendantsCyclical: (NSSet *) knownRelatives
{
    NSSet *descendants = nil;
    
    if (!knownRelatives) {
        descendants = [[NSSet alloc] init];
    }
    else {
        descendants = [knownRelatives copy];
    }
    
    NSMutableSet *mutNewChildren = [self.mealChildren mutableCopy];
    
    // new children are those in self.ingredientChildren that aren't in descendants
    [mutNewChildren minusSet:descendants];
    NSSet *newChildren = [mutNewChildren copy];
    
    // add the ingredientChildren to descendants
    descendants = [descendants setByAddingObjectsFromSet:newChildren];
    
    // for each ingredient in newChildren
    for (EDMeal *meal in newChildren) {
        
        // add the descendants (and the knownRelatives passed as arguement) of ingr to descendants
        descendants = [meal descendantsCyclical:descendants];
    }
    
    return [descendants copy];
}

// returns all the ancestors (includes parents) of the receiver
// --- makes sure no to create an infinite loop from self inheritence
//      --- if self inheritence does occur, the result will contain self,
//           which can be tested easily to determine validity
- (NSSet *) ancestorsCyclical: (NSSet *) knownRelatives
{
    NSSet *ancestors = nil;
    
    if (!knownRelatives) {
        ancestors = [[NSSet alloc] init];
    }
    else {
        ancestors = [knownRelatives copy];
    }
    
    NSMutableSet *mutNewParents = [self.mealParents mutableCopy];
    
    // new parents are those in self.ingredientParents that aren't in ancestors
    [mutNewParents minusSet:ancestors];
    NSSet *newParents = [mutNewParents copy];
    
    // add the ingredientParents to ancestors
    ancestors= [ancestors setByAddingObjectsFromSet:newParents];
    
    // for each ingredient in newParents
    for (EDMeal *meal in newParents) {
        
        // add the ancestors (and the knownRelatives passed as arguement) of ingr to ancestors
        ancestors = [meal ancestorsCyclical:ancestors];
    }
    
    return [ancestors copy];
}


- (NSSet *) descendants
{
    return [self descendantsCyclical:nil];
}

- (NSSet *) ancestors
{
    return [self ancestorsCyclical:nil];
}


// get all the ancestors for the ingredientsAdded (not including ingredientsAdded)
- (NSSet *) addedIngredientAncestors
{
    NSMutableSet *mutAddedAncestors = [NSMutableSet set];
    for (EDIngredient *ingr in self.ingredientsAdded) {
        [mutAddedAncestors addObjectsFromArray:[[ingr ancestors] allObjects]];
    }
    return [mutAddedAncestors copy];
}

/* OLD VERSION
// returns all the descendants (includes children) of the receiver
- (NSSet *) descendants
{
    NSMutableSet *mutDescendants = [NSMutableSet set];
    
    // add the children
    [mutDescendants addObjectsFromArray:[self.mealChildren allObjects]];
    
    // get the descendants of the children
    for (EDMeal *child in self.mealChildren) {
        [mutDescendants addObjectsFromArray:[[child descendants] allObjects]];
    }
    
    return [mutDescendants copy];
}

// returns all the ancestors (includes parents) of the receiver
- (NSSet *) ancestors
{
    NSMutableSet *mutAncestors = [NSMutableSet set];
    
    // adds the parents
    [mutAncestors addObjectsFromArray:[self.mealParents allObjects]];
    
    // gets the ancestors of the parents
    for (EDMeal *parent in self.mealParents) {
        [mutAncestors addObjectsFromArray:[[parent ancestors] allObjects]];
    }
    
    return [mutAncestors copy];
}
 
*/


 

// Determining transient properties
//// - we calculate the properties and set them
//// - **** only get a transient property directly if we know it was just calculated and set ***
//// -          , some methods give a property for free
//---------------------------------------------------------------

// determines the types of the meal by getting all the ingredients and asking their typesPrimary
- (NSSet *) determineTypes
{
    [self determineAllTransientProperties];
    
    return self.types;
}





// determine the ingredientsSecondary, but by using a recursive pattern, that also saves the results for each mealParent
- (NSSet *) determineIngredientsSecondary
{
    [self determineAllTransientProperties];
    
    return self.ingredientsSecondary;
}


// determine the ingredientsSecondary and types
// - this method returns the receiver's ingredientsSecondary for recursive purposes
// - DOES NOT check validity of self by looking for cycles
//      - this should be done before this method, by calling the ancestor methods
- (NSSet *) determineAllTransientProperties
{    
    // get all the ancestors for the ingredientsAdded
    NSMutableSet *mutIngrSecondary = [NSMutableSet set];
    [mutIngrSecondary unionSet:[self addedIngredientAncestors]];
    
    // for each mealParent
    // - get ingrAdded
    // - recursively call this method on it to get 
    //     - ancestors of ingredientsAdded 
    //     - ingredients contained in meal.mealParents
    for (EDMeal *meal in self.mealParents) {
        [mutIngrSecondary unionSet:meal.ingredientsAdded];
        //[mutIngrSecondary unionSet:[meal addedIngredientAncestors]];
        
        [mutIngrSecondary unionSet:[meal determineAllTransientProperties]];
    }
    
    self.ingredientsSecondary = [mutIngrSecondary copy];
    
    
    NSMutableSet *mutTypes = [NSMutableSet set];
    
    NSSet *allIngredients = [self.ingredientsSecondary setByAddingObjectsFromSet:self.ingredientsAdded];

    // get the types for the meal
    for (EDIngredient *ingr in allIngredients) {
        [mutTypes addObjectsFromArray:[ingr.typesPrimary allObjects]];
    }
    self.types = [mutTypes copy];
    
    return self.ingredientsSecondary;
}



/*    OLD VERSION
 // get ancestors from ingredientsAdded
 //  - and all the ingredients/ancestors from mealParents
 // - Non-recursive method design
 - (NSSet *) determineIngredientsSecondary
 {
 // the meals that have self as a descendant
 NSSet *ancestorMeals = [self ancestors];
 
 // the ingredientsAdded from the ancestors
 NSSet *ancestorMealsIngredientsAdded = [ancestorMeals valueForKeyPath:@"ingredientsAdded"];
 
 NSMutableSet *mutAllIngredientsFromMeals = [NSMutableSet set];
 [mutAllIngredientsFromMeals addObjectsFromArray:[ancestorMealsIngredientsAdded allObjects]];
 
 // get the ancestors of the ingredients added to ancestor meals
 for (EDIngredient *ingr in ancestorMealsIngredientsAdded) {
 [mutAllIngredientsFromMeals addObjectsFromArray:[[ingr ancestors] allObjects]];
 }
 
 NSSet *allIngredientsFromMeals = [mutAllIngredientsFromMeals copy];
 
 NSMutableSet *mutAncestorsFromIngrAdded = [NSMutableSet set];
 
 // get the ancestors of the ingredients added to self
 for (EDIngredient *ingr in self.ingredientsAdded) {
 [mutAncestorsFromIngrAdded addObjectsFromArray:[[ingr ancestors] allObjects]];
 }
 
 NSSet *ancestorsFromIngrAdded = [mutAncestorsFromIngrAdded copy];
 
 // union together the ancestor ingredients of self.ingredientsAdded,
 //     the ingredients added to ancestor meals, and their ancestor ingredients
 NSSet *secondary = [ancestorsFromIngrAdded setByAddingObjectsFromSet:allIngredientsFromMeals];
 
 self.ingredientsSecondary = secondary;
 return self.ingredientsSecondary;
 }
 */


#pragma mark - Elimination Methods -
//---------------------------------------------------------------

// determines if the meal contains something that is eliminated
//      - an added ingredient
//      - a parent meal
- (BOOL) isCurrentlyEliminated
{
    // check if the meal is eliminated directly
    if ([super isCurrentlyEliminated]) {
        return TRUE;
    }
    
    // check the ingredientsAdded
    if (self.ingredientsAdded) {
        for (EDIngredient *ingr in self.ingredientsAdded) {
            if ([ingr isCurrentlyEliminated]) {
                return TRUE;
            }
        }
    }
    
    // recursively call isCurrentlyEliminated on all the meals in mealParents
    if (self.mealParents) {
        for (EDMeal *meal in self.mealParents) {
            if ([meal isCurrentlyEliminated]) {
                return TRUE;
            }
        }
    }
    
    return FALSE;
}


#pragma mark - Fetching -
// --------------------------------------------------
/*! Creates a fetch request to fetch all meals
 
 */
+ (NSFetchRequest *) fetchAllMeals
{
    return [EDFood fetchObjectsForEntityName:MEAL_ENTITY_NAME];
}

+ (NSFetchRequest *) fetchOnlyMeals
{
    NSFetchRequest *fetch = [EDFood fetchObjectsForEntityName:MEAL_ENTITY_NAME];
    [fetch setIncludesSubentities:NO];
    
    return fetch;
}

+ (NSFetchRequest *) fetchFavoriteMeals
{
    NSFetchRequest *fetchRequest = [EDMeal fetchAllMeals];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"favorite = YES"];
    
    return fetchRequest;
}

+ (NSFetchRequest *) fetchFavoriteMealsNonMedication
{
    NSFetchRequest *fetchRequest = [EDMeal fetchFavoriteMeals];
    fetchRequest.includesSubentities = NO;
    
    return fetchRequest;
}


#pragma mark - Validation Helper Methods -
// ------------------------------------------------------

// Determines the existance of cycles (self-containment) within parent/child objects
- (BOOL) hasCycles: (NSError **) error
{
    BOOL cycles = FALSE;
    NSSet *myAncestors = [self ancestors];
    
    if ([myAncestors containsObject:self]) {
        cycles = TRUE;
    }
    
    
    // don't create error if we don't want one
    if (cycles && error !=NULL) {
        NSString *containsCyclesString = @"Meals cannot contain themself as a parent meal";
        NSMutableDictionary *containsCyclesInfo = [NSMutableDictionary dictionary];
        containsCyclesInfo[NSLocalizedFailureReasonErrorKey] = containsCyclesString;
        containsCyclesInfo[NSValidationObjectErrorKey] = self;
        
        NSError *containsCyclesError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                           code:NSManagedObjectValidationError
                                                       userInfo:containsCyclesInfo];
        
        // if there was no previous error, return the new error
        if (*error == nil) {
            *error = containsCyclesError;
        }
        // if there was a previous error, combine it with the existing one
        else {
            *error = [NSError errorFromOriginalError:*error error:containsCyclesError];
        }
    }
    
    return cycles;
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
/// - We need to check
//      - no overlap of elim
//      - that there is at lease one object in ingredientsAdded and mealParents
//              - these can be empty if we specify it is to be changed later
//              - should have eaten meal associated with (but here is catch since meal must exist before the eaten meal)
//      - that there are NO cycles of meals
- (BOOL)validateConsistency:(NSError **)error
{
    //check overlap of elim
    BOOL valid = [super validateConsistency:error];
    
    // if it is not a medication, and there are no ingredients or meals, then there must be a restaurant OR an associated eaten meal
    if (valid &&
        ([self.ingredientsAdded count] + [self.mealParents count] == 0) &&
        !self.restaurant &&
        ![self.timesEaten count] &&
        ![self isKindOfClass:[EDMedication class]])
    {
        
        valid = NO;
        if (error != NULL) {
            NSString *definitionErrorString = @"If a meal does NOT have ingredients or parent meals, then it must at least specify a restaurant or a time when it was recently eaten";
            NSMutableDictionary *definitionErrorInfo = [NSMutableDictionary dictionary];
            definitionErrorInfo[NSLocalizedFailureReasonErrorKey] = definitionErrorString;
            definitionErrorInfo[NSValidationObjectErrorKey] = self;
            
            NSError *definitionErrorError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                                code:NSManagedObjectValidationError
                                                            userInfo:definitionErrorInfo];
            
            // if there was no previous error, return the new error
            if (*error == nil) {
                *error = definitionErrorError;
            }
            // if there was a previous error, combine it with the existing one
            else {
                *error = [NSError errorFromOriginalError:*error error:definitionErrorError];
            }
        }
        
    }
    
    // check if cycles exist
    if (valid) {
        valid = ![self hasCycles:error];
        // no need to deal with error here since hasCycles: method deals with it
    }
    if (!valid) {
        
        NSLog(@"%@", [*error localizedDescription]);
    }
    
    return valid;
}





// MEALS - old methods
//---------------------------------------------------------------
/*


- (BOOL)    doesMeal:(NSString *)mealName
   containIngredient:(NSString *)ingredientName
{
    NSSet *allIngredients = [self allIngredientsForMeal:[self mealForName:mealName]];
    return [allIngredients containsObject:ingredientName];
}






//////////// Other methods  //////////////////



// converts the ingredients of the meal into a string, alphabetized
- (NSString *) ingredientsAsString {
    NSString *ingredientString = @"";
    
    NSArray *ingredientNames = [self.additionalIngredients allObjects];
    
    NSArray *orderedIngredientNames = [ingredientNames sortedArrayUsingComparator:
                                       ^(id obj1, id obj2) {
                                           return [obj1 caseInsensitiveCompare:obj2];
                                       }];
    ingredientString = [orderedIngredientNames componentsJoinedByString:@","];
    
    return ingredientString;
}

// converts the contained meals of this meal into a string, alphabetized
- (NSString *) mealsAsString
{
    NSString *mealString = @"";
    NSArray *mealNames = [self.additionalIngredients allObjects];
    NSArray *orderedMealNames = [mealNames sortedArrayUsingComparator:
                                 ^(id obj1, id obj2) {
                                     return [obj1 caseInsensitiveCompare:obj2];
                                 }];
    mealString = [orderedMealNames componentsJoinedByString:@", "];
    
    return mealString;
}

- (NSString *) contentsAsString
{
    return [NSString stringWithFormat:@"%@ - %@", [self mealsAsString], [self ingredientsAsString]];
}
*/
@end
