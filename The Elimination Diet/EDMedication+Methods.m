//
//  EDMedication+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/23/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDMedication+Methods.h"

#import "EDTakenMedication+Methods.h"

#import "EDMeal+Methods.h"
#import "EDFood+Methods.h"

#import "EDIngredient+Methods.h"
#import "EDRestaurant+Methods.h"
#import "EDTag+Methods.h"

#import "NSError+MHED_MultipleErrors.h"

@implementation EDMedication (Methods)


#pragma mark - Creation Methods -
//-----------------------------------------------------
+ (EDMedication *) createMedicationWithName:(NSString *)name
                           ingredientsAdded:(NSSet *)added
                          medicationParents:(NSSet *)medParents
                                    company:(EDRestaurant *)company
                                       tags:(NSSet *)tags
                                 forContext:(NSManagedObjectContext *)context
{
    // check if a meal with the same name already exists
    NSFetchRequest *fetchMed = [EDFood fetchObjectsForEntityName:MEDICATION_ENTITY_NAME withFoodName:name];
    
    NSError *error;
    NSArray *sameName = [context executeFetchRequest:fetchMed error:&error];
    
    // unique will be used to determine if another object exists with the same
    //      - name
    //      - added ingredients
    //      - parents
    //      - restaurant
    
    BOOL unique = TRUE;
    
    EDMedication *dupMed;
    
    if ([sameName count]) {
        for (int i = 0; i< [sameName count]; i++) {
            dupMed = sameName[i];
            
            ///////// sending isEqual to nil object will always return nil
            // if restaurant exists then see if it is equal
            if (company) {
                unique = [company isEqual:dupMed.restaurant];
            }
            // if restaurant DNE then the meal is the same only if there is no restaurant
            else if (!company && dupMed.restaurant)
            {
                unique = FALSE;
            }
            
            // added ingredients are the same if either
            //      - both are empty/nil
            //      - are set equal
            if (!added || ![added count]) { // if added = 0, then unique if dupMed has ingredients
                unique = unique && [dupMed.ingredientsAdded count];
            }
            else if (added && dupMed.ingredientsAdded){
                unique = unique && ![added isEqualToSet:dupMed.ingredientsAdded];
            }
            
            // meal parents are the same if either
            //      - both are empty/nil
            //      - are set equal
            if (!medParents || ![medParents count]) {
                unique = unique && [dupMed.medicationParents count];
            }
            else if (medParents && dupMed.medicationParents){
                unique = unique && ![medParents isEqualToSet:dupMed.medicationParents];
            }
            
            
            if (!unique) {
                
                // error - med already exists
                
                // end the for loop
                i = [sameName count];
            }
        }
    }
    
    
    // if this meal is unique, then create it
    if (unique) {
        
        EDMedication *temp = [NSEntityDescription insertNewObjectForEntityForName:MEDICATION_ENTITY_NAME
                                                     inManagedObjectContext:context];
        
        // set object properties to obvious or empty;
        temp.name = name;
        temp.uniqueID = [temp createUniqueID];
        temp.restaurant = company;
        temp.ingredientsAdded = [[NSSet alloc] init];
        temp.medicationParents = [[NSSet alloc] init];
        temp.medicationChildren = [[NSSet alloc] init];
        temp.tags = [[NSSet alloc] init];
        
        // if there are ingredientsAdded then set them
        if (added) {
            temp.ingredientsAdded = added;
        }
        if (medParents) {
            temp.medicationChildren = medParents;
        }
        
        //[temp determineAllTransientProperties];
        
        if (tags) { // if there are tags then set them
            temp.tags = tags;
        }
        
        return temp;
    }
    
    else { // the meal already exists, so we should just return it
        return dupMed;
    }
}


+ (void) setUpDefaultMedicationInContext:(NSManagedObjectContext *)context
{
    [EDIngredient setUpDefaultIngredientsWithContext:context];
    
    NSArray *allMeds = [context executeFetchRequest:[EDMedication fetchAllMedication] error:nil];
    if ([allMeds count] < 50)
    {
        
        [EDMedication createMedicationWithName:@"Asprin"
                              ingredientsAdded:nil
                             medicationParents:nil
                                       company:nil
                                          tags:nil
                                    forContext:context];
        
        [EDMedication createMedicationWithName:@"Tylenol"
                              ingredientsAdded:nil
                             medicationParents:nil
                                       company:nil
                                          tags:nil
                                    forContext:context];
        
        [EDMedication createMedicationWithName:@"Adderall"
                              ingredientsAdded:nil
                             medicationParents:nil
                                       company:nil
                                          tags:[NSSet setWithObject:[EDTag createTagWithName:@"Daily" inContext:context]]
                                    forContext:context];
        
        for (int a=0; a < 39; a++) {
            EDMedication *randMed = [EDMedication generateRandomMedInContext:context];
            if (a % 2) {
                //EDTag *favoriteTag = [EDTag getFavoriteTagInContext:context];
                //[randMed addTagsObject:favoriteTag];
                //NSLog(@"%@", randMed.name);
                
                randMed.favorite = @(YES);
            }
            if (a % 5) {
                EDTag *newTag = [EDTag createTagWithName:@"new" inContext:context];
                [randMed addTagsObject:newTag];
            }
            
            
            for (EDTag *tag in randMed.tags) {
                //NSLog(@"tag = %@", tag.name);
            }
        }
    }
    
    
    
    //NSArray *allIngredient = [context executeFetchRequest:[EDIngredient fetchAllIngredients] error:&error];
    
    
}


+ (EDMedication *) generateRandomMedInContext: (NSManagedObjectContext *) context
{
    NSArray *allMeds = [context executeFetchRequest:[EDMedication fetchAllMedication] error:nil];
    NSArray *allIngr = [context executeFetchRequest:[EDIngredient fetchAllIngredients] error:nil];
    
    int numOfIngr = (arc4random() % (6)) +1 ;
    int numOfMeds = arc4random() % (3) ;
    
    NSMutableSet *medIngr = [NSMutableSet setWithCapacity:numOfIngr];
    NSMutableSet *medMeds = [NSMutableSet setWithCapacity:numOfMeds];
    
    NSString *medName = [NSString stringWithFormat:@"Med (%i, %i) - ", numOfIngr, numOfMeds];
    
    for (int i=0; i < numOfIngr; i++) {
        int randomIndex = arc4random() % [allIngr count];
        EDIngredient *newIngr = allIngr[randomIndex];
        [medIngr addObject:newIngr];
    }
    
    NSArray *newIngrs = [[medIngr valueForKey:@"name"] allObjects];
    NSString *ingrNames = [newIngrs componentsJoinedByString:@", "];
    medName = [medName stringByAppendingString:ingrNames];
    
    for (int j=0; j < numOfMeds; j++) {
        int randomIndex = arc4random() % [allMeds count];
        [medMeds addObject:allMeds[randomIndex]];
    }
    
    
    
    EDMedication *newMed = [EDMedication createMedicationWithName:medName ingredientsAdded:[medIngr copy] medicationParents:[medMeds copy] company:nil tags:nil forContext:context];
    
    
    return newMed;
}



#pragma mark - Property getter and setter methods
- (NSSet *) medicationParents
{
    return [self mealParents];
}

- (void) setMedicationParents: (NSSet *) values;
{
    [self setMealParents:values];
}

- (void) addMedicationParents:(NSSet *) values;
{
    [self addMealParents:values];
}

- (void) removeMedicationParents:(NSSet *) values;
{
    [self removeMealParents:values];
}

- (void) addMedicationParentObject: (EDMedication *) value;
{
    [self addMealParentsObject:value];
}

- (void) removeMedicationParentObject: (EDMedication *) value;
{
    [self removeMealParentsObject:value];
}

- (NSSet *) medicationChildren;
{
    return [self mealChildren];
}

- (void) setMedicationChildren: (NSSet *) values;
{
    [self setMealChildren:values];
}

- (void) addMedicationChildren: (NSSet *) values;
{
    [self addMealChildren:values];
}

- (void) removeMedicationChildren: (NSSet *) values;
{
    [self removeMealChildren:values];
}

- (void) addMedicationChildObject: (EDMedication *) value;
{
    [self addMealChildrenObject:value];
}

- (void) removeMedicationChildObject: (EDMedication *) value;
{
    [self removeMealChildrenObject:value];
}


- (NSSet *) timesTaken;
{
    return [self timesEaten];
}

- (void) setTimesTaken: (NSSet *) values;
{
    [self setTimesEaten:values];
}

- (void) addTimesTaken: (NSSet *) values;
{
    [self addTimesEaten:values];
}

- (void) removeTimesTaken: (NSSet *) values;
{
    [self removeTimesEaten:values];
}

- (void) addTimeTaken:(EDTakenMedication *) value;
{
    [self addTimesEatenObject:value];
}

- (void) removeTimeTaken: (EDTakenMedication *)  value;
{
    [self removeTimesEatenObject:value];
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
    
    NSMutableSet *mutNewChildren = [self.medicationChildren mutableCopy];
    
    // new children are those in self.ingredientChildren that aren't in descendants
    [mutNewChildren minusSet:descendants];
    NSSet *newChildren = [mutNewChildren copy];
    
    // add the ingredientChildren to descendants
    descendants = [descendants setByAddingObjectsFromSet:newChildren];
    
    // for each ingredient in newChildren
    for (EDMedication *med in newChildren) {
        
        // add the descendants (and the knownRelatives passed as arguement) of ingr to descendants
        descendants = [med descendantsCyclical:descendants];
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
    
    NSMutableSet *mutNewParents = [self.medicationParents mutableCopy];
    
    // new parents are those in self.ingredientParents that aren't in ancestors
    [mutNewParents minusSet:ancestors];
    NSSet *newParents = [mutNewParents copy];
    
    // add the ingredientParents to ancestors
    ancestors= [ancestors setByAddingObjectsFromSet:newParents];
    
    // for each ingredient in newParents
    for (EDMedication *med in newParents) {
        
        // add the ancestors (and the knownRelatives passed as arguement) of ingr to ancestors
        ancestors = [med ancestorsCyclical:ancestors];
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
    
    NSSet *ingredientsSecondary = [self determineIngredientsSecondary];
    NSSet *allIngredients = [ingredientsSecondary setByAddingObjectsFromSet:self.ingredientsAdded];
    
    NSMutableSet *mutTypes = [NSMutableSet set];

    // get the types for the meal
    for (EDIngredient *ingr in allIngredients) {
        [mutTypes addObjectsFromArray:[ingr.typesPrimary allObjects]];
    }
    return [mutTypes copy];
}





// determine the ingredientsSecondary
// - this method returns the receiver's ingredientsSecondary
// - DOES NOT check validity of self by looking for cycles
//      - this should be done before this method, by calling the ancestor methods
- (NSSet *) determineIngredientsSecondary
{
    // get all the ancestors for the ingredientsAdded
    NSMutableSet *mutIngrSecondary = [NSMutableSet set];
    [mutIngrSecondary unionSet:[self addedIngredientAncestors]];
    
    // for each medParent
    // - get ingrAdded
    // - recursively call this method on it to get
    //     - ancestors of ingredientsAdded
    //     - ingredients contained in meal.mealParents
    for (EDMedication *med in self.medicationParents) {
        [mutIngrSecondary unionSet:med.ingredientsAdded];
        //[mutIngrSecondary unionSet:[meal addedIngredientAncestors]];
        
        [mutIngrSecondary unionSet:[med determineIngredientsSecondary]];
    }
    
    return [mutIngrSecondary copy];
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
    if (self.medicationParents) {
        for (EDMedication *med in self.medicationParents) {
            if ([med isCurrentlyEliminated]) {
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
+ (NSFetchRequest *) fetchAllMedication
{
    return [EDFood fetchObjectsForEntityName:MEDICATION_ENTITY_NAME];
}

+ (NSFetchRequest *) fetchFavoriteMedication
{
    NSFetchRequest *fetchRequest = [EDMedication fetchAllMedication];
    //fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%@ IN tags.name", [EDTag favoriteTag]];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"favorite = YES"];
    
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
        NSString *containsCyclesString = @"Medication cannot contain themself as a parent med";
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
        
        NSLog(@"%@", containsCyclesError);
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
        NSLog(@"error event");
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
//      - that there are NO cycles of meds
- (BOOL)validateConsistency:(NSError **)error
{
    // checks the meal validity
    BOOL valid = [super validateConsistency:error];
    
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
