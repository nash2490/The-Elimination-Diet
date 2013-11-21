//
//  EDIngredient+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDIngredient+Methods.h"

#import "EDFood+Methods.h"
#import "EDMeal+Methods.h"
#import "EDType+Methods.h"
#import "EDMedication+Methods.h"

#import "EDTag+Methods.h"

#import "NSError+MultipleErrors.h"

#import "EDEliminatedIngredient+Methods.h"

@implementation EDIngredient (Methods)


#pragma mark - Creation Methods -
// nothing really special to do here
//      - this ingredient has no ingredients or meals
//      - has no secondary types
+ (EDIngredient *) createIngredientWithName:(NSString *)name
                               primaryTypes:(NSSet *)typesPrimary
                                       tags:(NSSet *)tags
                                withContext:(NSManagedObjectContext *)context
{
    
    NSError *error;
    
    NSFetchRequest *fetchIngr = [EDFood fetchObjectsForEntityName:INGREDIENT_ENTITY_NAME withFoodName:name];
    NSArray *sameNameObjects = [context executeFetchRequest:fetchIngr
                                                      error:&error];
    
    EDIngredient *newIngredient;

    if (![sameNameObjects count]) {
        newIngredient = [NSEntityDescription insertNewObjectForEntityForName:INGREDIENT_ENTITY_NAME
                                      inManagedObjectContext:context];
        
        newIngredient.name = name;
        newIngredient.uniqueID = [newIngredient createUniqueID];
        newIngredient.whenEliminated = nil;
        
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
    }
    
    else {
        // ERROR  - shouldn't be another with same name
       // NSLog(@"Ingredient with name '%@' already exists ", name);
        return nil;
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
    newIngredient.uniqueID = [newIngredient createUniqueID];
    newIngredient.whenEliminated = nil;
    
    if (tags) {
        newIngredient.tags = tags;
    }
    
    if (ingredParents) {
        
        newIngredient.ingredientParents = ingredParents;
        newIngredient.ingredientChildren = [[NSSet alloc] init];
        
        newIngredient.typesPrimary = [[NSSet alloc] init];
        
        
        newIngredient.mealsPrimary = [[NSSet alloc] init];
        newIngredient.mealsSecondary = [[NSSet alloc] init];
        
    }

    return newIngredient;
}

+ (void) setUpDefaultIngredientsWithContext: (NSManagedObjectContext *) context
{
    [EDType setUpDefaultIngredientTypesWithContext:context];
    
    NSArray *glutenIngrNames = @[@"Wheat", @"Rye", @"Barley", @"Spelt", @"Oats (gluten)"];
    NSArray *nutsIngrNames = @[@"Tree nuts", @"Almonds", @"Pecans", @"Brazil nuts", @"Cashews", @"Chestnuts", @"Hazelnuts", @"Macadamia", @"Pine nuts", @"Pistachios"];
    NSArray *dairyIngrNames = @[@"Milk", @"Cheese", @"Yogurt", @"Butter", @"Casein"];
    NSArray *soyIngrNames = @[@"Tofu", @"Soynuts", @"Soybeans", @"Soy milk"]; // soy milk??
    NSArray *eggsIngrNames = @[@"Eggs"];
    NSArray *fishIngrNames = @[@"Salmon", @"Tuna", @"Pollock", @"Eel", @"Snapper", @"Tilapia"];
    NSArray *shellfishIngrNames = @[@"Crab", @"Lobster", @"Crayfish", @"Shrimp", @"Prawn", @"Mussels", @"Oysters", @"Scallops", @"Clams"];
    NSArray *poultryIngrNames = @[@"Chicken", @"Duck", @"Turkey"];
    NSArray *beefIngrNames = @[@"Beef"]; /// What else?
    NSArray *porkIngrNames = @[@"Ham", @"Bacon", @"Pork"];
    NSArray *grainsIngrNames = @[@"Millet", @"Quinoa", @"Rice", @"Corn", @"Buckwheat", @"Oats (gluten-free)", @"Sorghum", @"Teff"];
    NSArray *fruitIngrNames = @[@"Apple", @"Grape", @"Lemon", @"Lime", @"Orange", @"Peach", @"Nectarine", @"Pear", @"Plum", @"Strawberry", @"Cherry", @"Rasberry", @"Blackberry", @"Blueberry", @"Melon", @"Watermelon", @"Avacado", @"Tomato"]; // Tomato???
    NSArray *vegetablesIngrNames = @[@"Potato", @"Celery", @"Carrots", @"Parsley", @"Peppers", @"Caraway", @"Coriander", @"Squash", @"Broccoli", @"Asparagus", @"Cucumber", @"Eggplant", @"Mushrooms", @"Onions", @"Spinach", @"Sweet Potatoes", @"Lettuce"];
    NSArray *beansIngrNames = @[@"Peanuts", @"Black beans", @"Kidney beans", @"Lima beans", @"Mung beans", @"Navy beans", @"Pinto beans", @"String beans"];
    NSArray *otherIngrNames = @[@"Tapioca", @"Xanthan gum", @"Guar gum"];
    
    NSError *error;
    NSArray *allTypes = [context executeFetchRequest:[EDType fetchAllTypes] error:&error];
    
    for (EDType *type in allTypes) {
        NSArray *ingrNames = [[NSArray alloc] init];
        
        NSString *typeName = type.name;
        
        if ([typeName isEqualToString:@"Dairy"]) {
            ingrNames = dairyIngrNames;
        }
        else if ([typeName isEqualToString:@"Soy"]) {
            ingrNames = soyIngrNames;
        }
        else if ([typeName isEqualToString:@"Tree Nuts"]) {
            ingrNames = nutsIngrNames;
        }
        else if ([typeName isEqualToString:@"Gluten"]) {
            ingrNames = glutenIngrNames;
        }
        else if ([typeName isEqualToString:@"Eggs"]) {
            ingrNames = eggsIngrNames;
        }
        else if ([typeName isEqualToString:@"Fish"]) {
            ingrNames = fishIngrNames;
        }
        else if ([typeName isEqualToString:@"Shellfish"]) {
            ingrNames = shellfishIngrNames;
        }
        else if ([typeName isEqualToString:@"Poultry"]) {
            ingrNames = poultryIngrNames;
        }
        else if ([typeName isEqualToString:@"Beef"]) {
            ingrNames = beefIngrNames;
        }
        else if ([typeName isEqualToString:@"Pork"]) {
            ingrNames = porkIngrNames;
        }
        else if ([typeName isEqualToString:@"Grains (gluten-free)"]) {
            ingrNames = grainsIngrNames;
        }
        else if ([typeName isEqualToString:@"Fruit"]) {
            ingrNames = fruitIngrNames;
        }
        else if ([typeName isEqualToString:@"Vegetables"]) {
            ingrNames = vegetablesIngrNames;
        }
        else if ([typeName isEqualToString:@"Beans"]) {
            ingrNames = beansIngrNames;
        }
        else if ([typeName isEqualToString:@"Other"]) {
            ingrNames = otherIngrNames;
        }
        
        for (NSString *ingrName in ingrNames) {
            [EDIngredient createIngredientWithName:ingrName
                                      primaryTypes:[NSSet setWithObject:type]
                                              tags:nil
                                       withContext:context];        }
    }
}
#pragma mark - Property Helper Methods -
// ------------------------------------------------------

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
    
    NSMutableSet *mutNewChildren = [self.ingredientChildren mutableCopy];
    
    // new children are those in self.ingredientChildren that aren't in descendants
    [mutNewChildren minusSet:descendants];
    NSSet *newChildren = [mutNewChildren copy];
    
    // add the ingredientChildren to descendants
    descendants = [descendants setByAddingObjectsFromSet:newChildren];
    
    // for each ingredient in newChildren
    for (EDIngredient *ingr in newChildren) {
        
        // add the descendants (and the knownRelatives passed as arguement) of ingr to descendants
        descendants = [ingr descendantsCyclical:descendants];
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
    
    NSMutableSet *mutNewParents = [self.ingredientParents mutableCopy];
    
    // new parents are those in self.ingredientParents that aren't in ancestors
    [mutNewParents minusSet:ancestors];
    NSSet *newParents = [mutNewParents copy];
    
    // add the ingredientParents to ancestors
    ancestors= [ancestors setByAddingObjectsFromSet:newParents];
    
    // for each ingredient in newParents
    for (EDIngredient *ingr in newParents) {
        
        // add the ancestors (and the knownRelatives passed as arguement) of ingr to ancestors
        ancestors = [ingr ancestorsCyclical:ancestors];
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

// get all the descendants for the mealsPrimary (not including mealsPrimary)
- (NSSet *) primaryMealsDescendants
{
    NSMutableSet *mutDescendants = [[NSMutableSet alloc] initWithCapacity:10];

    for (EDMeal *meal in self.mealsPrimary) {
        [mutDescendants addObjectsFromArray:[[meal descendants] allObjects]];
    }
    return [mutDescendants copy];
}

// get all the descendants for the medicationPrimary (not including mealsPrimary)
- (NSSet *) primaryMedicationDescendants
{
    NSMutableSet *mutDescendants = [[NSMutableSet alloc] initWithCapacity:10];
    
    for (EDMedication *med in self.medicationPrimary) {
        [mutDescendants addObjectsFromArray:[[med descendants] allObjects]];
    }
    return [mutDescendants copy];
}


/* OLD VERSION
// returns all the descendants (includes children) of the receiver
- (NSSet *) descendants
{
    NSMutableSet *mutDescendants = [NSMutableSet set];
    
    // add the children
    [mutDescendants addObjectsFromArray:[self.ingredientChildren allObjects]];
    
    // get the descendants of the children
    for (EDIngredient *child in self.ingredientChildren) {
        [mutDescendants addObjectsFromArray:[[child descendants] allObjects]];
    }
    
    return [mutDescendants copy];
}

- (NSSet *) ancestors
{
    NSMutableSet *mutAncestors = [NSMutableSet set];
    
    // adds the parents
    [mutAncestors addObjectsFromArray:[self.ingredientParents allObjects]];
    
    // gets the ancestors of the parents
    for (EDIngredient *parent in self.ingredientParents) {
        [mutAncestors addObjectsFromArray:[[parent ancestors] allObjects]];
    }
    
    return [mutAncestors copy];
}
*/

#pragma mark - Elimination Methods -
//---------------------------------------------------------------

// determines if the ingredient, a parent ingredient, or a contained type is currently eliminated
- (BOOL) isCurrentlyEliminated
{
    // check to see if this object is directly eliminated
    if ([super isCurrentlyEliminated]) {
        return TRUE;
    }
    
    // check the primary types
    if (self.typesPrimary) {
        for (EDType *type in self.typesPrimary) {
            if ([type isCurrentlyEliminated]) {
                return TRUE;
            }
        }
    }
    
    // recursively call isCurrentlyEliminated on all the ingredients in ingredientParents
    if (self.ingredientParents) {
        for (EDIngredient *ingr in self.ingredientParents) {
            if ([ingr isCurrentlyEliminated]) {
                return TRUE;
            }
        }
    }
    
    return FALSE;
}


#pragma mark - Determining transient properties -
//// - we calculate the properties and set them
//// - **** only get a transient property directly if we know it was just calculated and set ***
//// -          , some methods give a property for free
//---------------------------------------------------------------


// determine the mealsSecondary
// - this method returns the receiver's mealsSecondary for recursive purposes
// - DOES NOT check validity of self by looking for cycles
//      - this should be done before this method, by calling the ancestor/descendant methods
- (NSSet *) determineMealsSecondary
{
    //NSLog(@"ingr name = %@", self.name);
    
    // get all the descendants for the mealsPrimary (but not mealsPrimary)
    NSMutableSet *mutMealsSecondary = [NSMutableSet set];

    NSSet *primaryMealsDesc = [self primaryMealsDescendants];
    [mutMealsSecondary unionSet:primaryMealsDesc];
    
    // for each ingredientChild
    // - get mealsPrimary
    // - recursively call this method on it to get
    //     - descendants of mealsPrimary
    //     - meals contained in ingr.ingredientChildren
    for (EDIngredient *ingr in self.ingredientChildren) {
        [mutMealsSecondary unionSet:ingr.mealsPrimary];
        //[mutIngrSecondary unionSet:[meal addedIngredientAncestors]];

        [mutMealsSecondary unionSet:[ingr determineMealsSecondary]];

    }

    return [mutMealsSecondary copy];
}


// ingredients secondary
- (NSSet *) determineTypesSecondary
{
    NSMutableSet *mutTypesSecondary = [NSMutableSet set];
    NSMutableSet *mutGreatAncestors = [NSMutableSet set];
    
    // for each parent ingredient we add the ancestors to the set
    for (EDIngredient *ingr in self.ingredientParents) {
        [mutGreatAncestors addObjectsFromArray:[[ingr ancestors] allObjects]];
    }
    
    NSSet *greatAncestors = [mutGreatAncestors copy];
    
    //
    for (EDIngredient *ingr in greatAncestors) {
        [mutTypesSecondary addObjectsFromArray:[ingr.typesPrimary allObjects]];
    }
    
    NSSet *secondary = [mutTypesSecondary copy];
    
    if ([secondary intersectsSet:self.typesPrimary]) {
        // then there is an error somewhere because a member of secondary cannot be primary
    }
    
    
    return secondary;
}


//// determine the medicationSecondary
//// - this method returns the receiver's medicationSecondary for recursive purposes
//// - DOES NOT check validity of self by looking for cycles
////      - this should be done before this method, by calling the ancestor/descendant methods
//- (NSSet *) determineMedicationSecondary
//{
//    //NSLog(@"ingr name = %@", self.name);
//    
//    // get all the descendants for the mealsPrimary (but not mealsPrimary)
//    NSMutableSet *mutMedicationSecondary = [NSMutableSet set];
//    
//    NSSet *primaryMedDesc = [self primaryMedicationDescendants];
//    [mutMedicationSecondary unionSet:primaryMedDesc];
//    
//    // for each ingredientChild
//    // - get mealsPrimary
//    // - recursively call this method on it to get
//    //     - descendants of mealsPrimary
//    //     - meals contained in ingr.ingredientChildren
//    for (EDIngredient *ingr in self.ingredientChildren) {
//        [mutMedicationSecondary unionSet:ingr.mealsPrimary];
//        //[mutIngrSecondary unionSet:[meal addedIngredientAncestors]];
//        
//        [mutMedicationSecondary unionSet:[ingr determineMedicationSecondary]];
//        
//    }
//    
//    return [mutMedicationSecondary copy];
//}

/* OLD VERSION 1.0
// meals secondary
/// - we get all the descendants, get the primary meals from them (and self), and then get the meal descendants from those meals
- (NSSet *) determineMealsSecondary
{
    NSMutableSet *mutMealsSecondary = [NSMutableSet set];
    NSMutableSet *mutMealsFromDescendants = [NSMutableSet set];

    NSSet *descendants = [self descendants];
    
    // get the primary meals of the descendants
    for (EDIngredient *ingr in descendants) {
        [mutMealsFromDescendants addObjectsFromArray:[ingr.mealsPrimary allObjects]];
    }
    
    NSSet *mealsFromDescendants = [mutMealsFromDescendants copy];
    
    // add the primary meals from the descendants to the secondary meals
    [mutMealsSecondary addObjectsFromArray:[mealsFromDescendants allObjects]];
    
    //get all the descendant meals from the descendant meals
    for (EDMeal *meal in mealsFromDescendants) {
        [mutMealsSecondary addObjectsFromArray:[[meal descendants] allObjects]];
    }
    
    NSSet *mealsSecondary = [mutMealsSecondary copy];
    
    if ([mealsSecondary intersectsSet:self.mealsPrimary]) {
        // then there is an error somewhere because a member of secondary cannot be primary
    }
    
    self.mealsSecondary = mealsSecondary;
    
    return self.mealsSecondary;
}
*/


#pragma mark - Fetching -
// --------------------------------------------------

+ (NSFetchRequest *) fetchAllIngredients
{
    return [EDFood fetchObjectsForEntityName:INGREDIENT_ENTITY_NAME];
}


#pragma mark - Tagging -
// --------------------------------------------------
- (BOOL) isBeverage
{
    EDTag *bevTag = [EDTag getBeverageTagInContext:self.managedObjectContext];
    if ([self.tags containsObject:bevTag]) {
        return TRUE;
    }
    return FALSE;
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
        NSString *containsCyclesString = @"Ingredients cannot contain themself as a parent ingredient";
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


#pragma mark - Validation methods -
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
//      - no overlap of eliminated food
//      - that there aren't both typesPrimary and ingredientParents
//      - that there are NO cycles of ingredients
- (BOOL)validateConsistency:(NSError **)error
{
    // check overlap of elim 
    BOOL valid = [super validateConsistency:error];
    
    // NOT SURE IF I REALLY WANT THIS AS A HARD RULE
    // if there are both typesPrimary and ingredientParents
    if ([self.typesPrimary count] * [self.ingredientParents count]) {
        
        valid = NO;
        
        if (error != NULL) {
            NSString *definitionErrorString = @"The ingredient CANNOT be an instance of types AND a combination of ingredients";
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
            
            NSLog(@" uuu %@", definitionErrorString);
        }
    }
    
    if (valid) {
        valid = ![self hasCycles:error];
        // no need to deal with error here since hasCycles: method deals with it
    }
    
    if (!valid) {
        NSLog(@"%@", [*error localizedDescription]);
    }
    
    return valid;
}

@end
