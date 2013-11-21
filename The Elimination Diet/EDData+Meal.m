//
//  EDData+Meal.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/10/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDData+Meal.h"
#import "EDData.m"

@implementation EDData (Meal)

// MEALS
////////////////////////////////////////////////

// if meal doesnt already exist add it to self.meals
- (EDMeal *) newMeal: (EDMeal *) aMeal {
    
    EDMeal *result = nil;
    
    // if self.meals is not defined then create a new dictionary with the meal and its name for the key
    if (self.meals == nil)
    {
        self.meals = [[NSDictionary alloc] initWithObjectsAndKeys:aMeal, aMeal.name, nil];
        result = aMeal;
    }
    
    // if the meal is not contained in self.meals then add it
    else if ([self mealForName:aMeal.name] == FALSE) {
        NSMutableDictionary *mutMeals = [self.meals mutableCopy];
        [mutMeals setObject:aMeal forKey:aMeal.name];
        self.meals = [mutMeals copy];
        return aMeal;
    }
    
    return result;
}

// if self.meals contains aMeal, remove it
- (void) removeMeal:(NSString *)mealName {
    if ([self.meals objectForKey:mealName]) {
        NSMutableDictionary *mutMeals = [self.meals mutableCopy];
        [mutMeals removeObjectForKey:mealName];
        self.meals = [mutMeals copy];
    }
}

// gets removes the meal with the same name and puts aMeal in its place
- (EDMeal *) replaceMealWithMeal: (EDMeal *) aMeal {
    [self removeMeal:aMeal.name];
    return [self newMeal:aMeal];
}


- (EDMeal *) mealForName:(NSString *)aName {
    return [self.meals objectForKey:aName];
}

- (NSSet *) mealsForNames: (NSSet *) names {
    
    NSMutableSet *mutMeals = nil;
    NSSet *meals = [[NSSet alloc] initWithObjects: nil];
    
    if ([names count]) {
        mutMeals = [[NSMutableSet alloc] initWithCapacity:[names count]];
        
        for (NSString *aName in names) {
            [mutMeals addObject:[self mealForName:aName]];
        }
        meals = [mutMeals copy];
    }
    
    return meals;
}

// just returns the property for the meal with the given name
- (NSSet *) mealsForMeal: (NSString *) mealName {
    EDMeal *meal = [self mealForName:mealName];
    if (meal) {
        return meal.containedMeals;
    }
    return nil;
}


// returns the property additionalIngredients for the meal with the name mealName
- (NSSet *) ingredientsForMeal: (NSString *) mealName {
    
    EDMeal *meal = [self mealForName:mealName];
    if (meal) {
        return meal.additionalIngredients;
    }
    return nil;
}

// unions the ingredients properties for the meals with the given names
- (NSSet *) ingredientsForMeals:(NSSet *) mealNames {
    NSMutableSet *ingredients = [[NSMutableSet alloc] init];
    
    for (NSString *name in mealNames) {
        [ingredients unionSet:[self ingredientsForMeal:name]];
    }
    return [ingredients copy];
}


- (NSSet *) allIngredientsForMeal:(EDMeal *)aMeal
{
    NSMutableSet *allIngredients = nil;
    
    if (aMeal) {
        allIngredients = [[NSMutableSet alloc] initWithSet:aMeal.additionalIngredients];
        [allIngredients unionSet:[self secondaryIngredientsOfMeal:aMeal]];
    }
    
    return [allIngredients copy];
}


- (BOOL)    doesMeal:(NSString *)mealName
   containIngredient:(NSString *)ingredientName
{
    NSSet *allIngredients = [self allIngredientsForMeal:[self mealForName:mealName]];
    return [allIngredients containsObject:ingredientName];
}


- (NSSet *) ingredientsNotInMeal: (EDMeal *) aMeal{
    NSMutableSet *missingIngredients = [[NSMutableSet alloc] initWithArray:[self.ingredients allKeys]];
    
    if (aMeal) {
        [missingIngredients minusSet:aMeal.additionalIngredients];
        [missingIngredients minusSet:[self secondaryIngredientsOfMeal:aMeal]];
    }
    
    return [missingIngredients copy];
}

// the meals that arent primary or secondary of mealName
- (NSSet *) mealsNotInMeal: (EDMeal *) aMeal{
    
    NSMutableSet *missingMeals = [[NSMutableSet alloc] initWithArray:[self.meals allKeys]];
    
    if (aMeal) {
        NSMutableSet *mutMeals = [[NSMutableSet alloc] initWithSet:aMeal.containedMeals];
        [mutMeals unionSet:[self secondaryMealsOfMeal:aMeal]];
        NSSet *meals = [mutMeals copy];
        
        [missingMeals minusSet:meals];
    }
    
    return [missingMeals copy];
    
}

// gets the ingredients for the meal and then returns the summed types for the ingredients
- (NSSet *) typesForMeal: (EDMeal *) aMeal {
    
    NSMutableSet *mealTypes = [[NSMutableSet alloc] init];
    
    if (aMeal) {
        NSMutableSet *mutIngredients = [[NSMutableSet alloc] initWithSet:aMeal.additionalIngredients];
        [mutIngredients unionSet:[self secondaryIngredientsOfMeal:aMeal]];
        NSSet *ingredients = [mutIngredients copy];
        
        for (NSString *ingrName in ingredients) {
            EDIngredient *ingr = (EDIngredient *)[self ingredientForName:ingrName];
            [mealTypes unionSet:ingr.types];
        }
    }
    
    return [mealTypes copy];
}

// just returns the
- (NSString *) restaurantForMealName:(NSString *)mealName
{
    EDMeal *tempMeal = [self mealForName:mealName];
    if (tempMeal) {
        return tempMeal.restaurant;
    }
    
    return @"";
}


// secondary meals are the meals that are contained in the primary meals, but not the primary themselves
///// - so cyclical containment ruins this concept
///// - the primary meals are immediately added to alreadyAddedMeals
- (NSSet *) secondaryMealsOfMeal: (EDMeal *) aMeal
{
    NSMutableSet *secondaryMeals = [[NSMutableSet alloc] init];
    
    // we dont want to add the primary meals
    NSMutableSet *alreadyAddedMeals = [[NSMutableSet alloc] initWithSet:aMeal.containedMeals];
    
    for (NSString *mealName in aMeal.containedMeals) {
        EDMeal *anotherMeal = [self mealForName:mealName];
        if (anotherMeal) {
            [secondaryMeals unionSet:[self newMealsOfMeal:anotherMeal withSet:alreadyAddedMeals]];
        }
    }
    return [secondaryMeals copy];
}

// helper to secondaryMealsOfMeal - returns the primary and secondary meals of aMeal
////// - otherMeals is a set of strings, if a meal is in this set then we skip it
- (NSSet *) newMealsOfMeal:(EDMeal *)aMeal withSet:(NSMutableSet *) otherMeals {
    
    NSMutableSet *newMeals = [[NSMutableSet alloc] init];
    
    NSMutableSet *mutMealsToAdd = [[NSMutableSet alloc] initWithSet:aMeal.containedMeals];
    [mutMealsToAdd minusSet:otherMeals]; // remove meals that have already been added
    [newMeals unionSet:mutMealsToAdd]; // add the meals to newMeals that havent been added already
    [otherMeals unionSet:mutMealsToAdd]; // add the meals to otherMeals since they have already been seen
    NSSet *mealsToAdd = [mutMealsToAdd copy];
    
    for (NSString *mealName in mealsToAdd) {
        EDMeal *anotherMeal = [self mealForName:mealName];
        [newMeals unionSet:[self newMealsOfMeal:anotherMeal withSet:otherMeals]];
    }
    
    return [newMeals copy];
}

// ingredients not directly contained in aMeal
//// this means ingredients contained in the meals and the ingredients
- (NSSet *) secondaryIngredientsOfMeal:(EDMeal *)aMeal
{
    // get all the meals, primary and secondary
    NSMutableSet *mutAllMeals = [[NSMutableSet alloc] initWithSet:aMeal.containedMeals];
    [mutAllMeals unionSet:[self secondaryMealsOfMeal:aMeal]];
    NSSet *allMeals = [mutAllMeals copy];
    
    // then get the ingredients of these meals
    NSMutableSet *secondaryIngredients = [[self ingredientsForMeals:allMeals] mutableCopy];
    
    // then add the secondary ingredients from the ingredients
    [secondaryIngredients unionSet:[self secondaryIngredientsOfIngredients:aMeal.additionalIngredients]];
    
    return [secondaryIngredients copy];
}


- (NSArray *) sortAllMealsByName {
    return [self sortMealsByName:[NSSet setWithArray:[self.meals allKeys]]];
}

- (NSArray *) sortMealsByName: (NSSet *) mealNames{
    //NSSortDescriptor *byName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    //NSArray *sortedMeals = [meals sortedArrayUsingDescriptors:@[byName]];
    //return [[NSDictionary alloc] initWithObjects:@[sortedMeals] forKeys:@[@"DEFAULT"]];
    
    NSArray *arrayOfMeals = [[NSArray alloc] init];
    
    if (mealNames) {
        arrayOfMeals = [mealNames allObjects];
    }
    
    return [self sortArrayOfString:arrayOfMeals];
}

- (NSDictionary *) sortAllMealsByIngredient
{
    return [self sortMealsByIngredient:[NSSet setWithArray:[self.meals allKeys]]];
}

- (NSDictionary *) sortMealsByIngredient: (NSSet *) mealNames {
    
    NSMutableDictionary *mealsByIngredient = [[NSMutableDictionary alloc] init];
    
    NSSet *allIngredients = [self ingredientsForNames:[NSSet setWithArray:[self.ingredients allKeys]]];
    
    // for every type we make an entry in the dictionary of those ingredients having that type
    for (EDIngredient *anIngredient in allIngredients) {
        
        /// predicate, evaluatedObject is a Meal
        // -- gets the (NSArray) meal.ingredients and checks to see if it contains
        //     the object anIngredient
        NSPredicate *predForIngredient = [NSPredicate predicateWithBlock: ^BOOL(id evaluatedObject, NSDictionary *bindings){
            NSSet *set = [evaluatedObject valueForKeyPath:@"ingredients"];
            
            return [set containsObject:anIngredient];
        }];
        
        NSSet *filteredMeals = nil;
        NSSet *meals = [self mealsForNames:mealNames];
        filteredMeals = [meals filteredSetUsingPredicate:predForIngredient];
        
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        
        NSArray *sortedMeals = [[NSArray alloc] init];
        
        if ([filteredMeals count]) {
            sortedMeals = [filteredMeals sortedArrayUsingDescriptors:@[sortByName]];
        }
        
        [mealsByIngredient setObject:sortedMeals forKey:anIngredient.name];
    }
    return [mealsByIngredient copy];
}

- (NSArray *) sortAllMealsByPlace{
    return [self sortMealsByPlace:[[NSSet alloc] initWithArray: [self.meals allKeys]]];
}

- (NSArray *) sortMealsByPlace: (NSSet *) mealNames { /////// NOT THE CORRECT CODE FOR THE PURPOSE
    NSMutableDictionary *mealsByPlace = [[NSMutableDictionary alloc] init];
    
    // for every type we make an entry in the dictionary of those ingredients having that type
    for (NSString *aType in self.ingredientTypes) {
        
        /// predicate, evaluatedObject is a Meal
        // -- gets the (NSArray) meal.ingredients and checks to see if it contains
        //     the object anIngredient
        NSPredicate *predForIngredientType = [NSPredicate predicateWithBlock: ^BOOL(id evaluatedObject, NSDictionary *bindings){
            id array = [evaluatedObject valueForKeyPath:@"restaurant"];
            
            if ([array respondsToSelector:@selector(containsObject:)]) {
                return [array performSelector:@selector(containsObject:) withObject:aType];
            }
            return FALSE;
        }];
        
        NSSet *filteredMeals = [[self mealsForNames:mealNames] filteredSetUsingPredicate:predForIngredientType];
        
        NSSortDescriptor *sortMealsByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        
        NSArray *sortedMeals = [filteredMeals sortedArrayUsingDescriptors:@[sortMealsByName]];
        
        [mealsByPlace setObject:sortedMeals forKey:aType];
    }
    return [mealsByPlace copy];
}




// eatenMeals
////////////////////////////////////////////////

- (void) eatMeal: (EDMeal *) aMeal atTime: (NSString *) time {
    if (self.eatenMeals == nil) {
        self.eatenMeals = [[NSDictionary alloc] initWithObjectsAndKeys:aMeal, time, nil];
    }
    else {
        NSMutableDictionary *mutEatenMeals = [self.eatenMeals mutableCopy];
        [mutEatenMeals setObject:aMeal forKey:time];
        self.eatenMeals = [mutEatenMeals copy];
    }
}

- (void) eatMealNow: (EDMeal *) aMeal
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM-DD-yyyy HH:mm:ss"];
    NSString *currentTime = [dateFormatter stringFromDate:now];
    
    [self eatMeal:aMeal atTime:currentTime];
}


- (void) removeEatenMeal:(EDMeal *)aMeal
                  atTime:(NSString *)time {
    
    NSMutableDictionary *mutEatenMeals = [self.eatenMeals mutableCopy];
    NSMutableArray *mealsAtTime = [mutEatenMeals objectForKey:time];
    [mutEatenMeals removeObjectForKey:time];
    [mealsAtTime removeObject:aMeal];
    [mutEatenMeals setObject:[mealsAtTime copy] forKey:time];
    self.eatenMeals = [mutEatenMeals copy];
}


// sorting
- (NSArray *) sortEatenMealsByTime: (NSDictionary *) eatenMeals
{
    // create array of nsdate objects from the keys of the dictionary
    NSArray *stringDates = [eatenMeals allKeys];
    NSArray *unsortedDates = [[NSArray alloc] init];
    
    // addDateToArray: is a method added to NSString by category EatDate
    [stringDates performSelector:@selector(addDateToArray:) withObject:unsortedDates];
    
    // sort the array of nsdate into an array by most recent first
    NSArray *sortedDates = [unsortedDates sortedArrayUsingSelector:@selector(compare:)];
    
    
    // create an array of EDMeal from the array
    NSMutableArray *mutSortedMeals = [[NSMutableArray alloc] initWithCapacity:[sortedDates count]];
    //[sortedDates performSelector:@selector(addMealForDateToArray:) withObject:mutSortedMeals];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-DD-yyyy HH:mm:ss"];
    
    for (int i=0; i<[sortedDates count]; i++) {
        NSString *stringDate = [dateFormatter stringFromDate: (NSDate *)[sortedDates objectAtIndex:i]];
        EDMeal * mealForDate = [eatenMeals objectForKey:stringDate];
        [mutSortedMeals insertObject:mealForDate atIndex:i];
    }
    
    return [mutSortedMeals copy];
}

- (NSArray *) sortAllEatenMealsByTime
{
    return [self sortEatenMealsByTime:self.eatenMeals];
}


@end
