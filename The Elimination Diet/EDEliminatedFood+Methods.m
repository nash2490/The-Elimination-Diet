//
//  EDEliminatedFood+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/29/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedFood+Methods.h"
#import "EDEvent+Methods.h"

#import "EDFood+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDMeal+Methods.h"
#import "EDType+Methods.h"

#import "EDEliminatedAPI+Helpers.h"

@implementation EDEliminatedFood (Methods)


/*! 
 @discussion Create Eliminated Foods from a food and start time with optional stop time
 
 * @param food The food to eliminate
 * @param start The date of the time when the food is first eliminated
 * @param stop (optional) the date of the time when the food is no longer eliminated
 *  - is set to [NSDate distantFuture] if was nil
 
 @return A new Eliminated Food object added to the context
 */
+ (EDEliminatedFood *) createWithFood:(EDFood *)food
                            startTime:(NSDate *)start
                             stopTime:(NSDate *)stop
                           forContext:(NSManagedObjectContext *)context
{
    // Check if an existing EDEliminatedFood exists for this food and has overlaping time
    //      - if one exists then we don't create a new one
    //          - but we change the start/stop of the existing 
    
    BOOL overlap = FALSE;
    
    
    NSDate *newStart = start;
    NSDate *newStop = stop ? : [NSDate distantFuture];
    
    if (food) { // we only eliminate if there is a food
        
        // for every EliminatedFood related to food we check if it overlaps with the proposed start and stop times
        //      - if YES then we want to delete the existing object and create a new one with the new start and stop times
        //      - if NO then we want to create a new EliminatedFood object
        
        for (EDEliminatedFood *elim in food.whenEliminated) {
            
            if ([elim overlapWithStart:newStart stop:newStop]) {
                // ERROR --------
                overlap = TRUE;
            }
            
            if (overlap) { // We want to delete old elim and make a new one with updated start and stop times
                
                overlap = FALSE; // we set it back to FALSE for the next iteration of the for loop
                
                newStart = [newStart earlierDate:elim.date];
                newStop = [newStop laterDate:elim.stop];
                
                return elim;
                //[context deleteObject:elim];
            }
            
            
        }
        
        EDEliminatedFood *temp = [NSEntityDescription insertNewObjectForEntityForName:ELIMINATED_FOOD_ENTITY_NAME
                                                               inManagedObjectContext:context];
        
        // set object properties to obvious or empty;
        temp.uniqueID = [EDEliminatedAPI createUniqueID];
        temp.eliminatedFood = food;
        
        if ([newStart isEqual:[newStart earlierDate:newStop]] &&
            ![newStart isEqual:newStop])
        { // if newStart is before and not equal to newStop
            temp.date = newStart;
            temp.stop = newStop;
        }
        else { // otherwise we choose earlier date for newStart, and just set stop to [nsdate distantFuture]
            temp.date = [newStop earlierDate:newStart];
            temp.stop = [NSDate distantFuture];
        }
        
        
        return temp;
    }
    

    
    else { // then there is no food to eliminate
        return nil;
    }
    
    
}




+ (void) setUpDefaultEliminatedFoodsInContext:(NSManagedObjectContext *)context
{
    [EDMeal setUpDefaultMealsInContext:context];
        
    //NSArray *allIngredient = [context executeFetchRequest:[EDIngredient fetchAllIngredients] error:&error];
    
    NSError *error;
    NSArray *allTypes = [context executeFetchRequest:[EDType fetchAllTypes] error:&error];
    NSArray *allIngredients = [context executeFetchRequest:[EDIngredient fetchAllIngredients] error:&error];
    NSArray *allElim = [context executeFetchRequest:[EDEliminatedFood fetchAllEliminatedFoods] error:&error];
    
    NSMutableArray *mutTemp = [NSMutableArray array];
    
    for (EDEliminatedFood *elim in allElim) {
        [mutTemp addObject:elim.eliminatedFood];
    }
    NSArray *allFoodsElim = [mutTemp copy];
    
    NSArray *currentElim = [context executeFetchRequest:[EDEliminatedFood fetchAllCurrentEliminatedFoods] error:&error];
    
    if ([currentElim count] < 10) {
        if ([allTypes count]) {
            
            for (int i=0; i < 2; i++) {
                int randMealIndex = arc4random() % ([allTypes count] -1);
                EDType *typeToElim = allTypes[randMealIndex];
                if (![allFoodsElim containsObject:typeToElim]) {
                    [EDEliminatedFood createWithFood:typeToElim startTime:[NSDate date] stopTime:nil forContext:context];
                }
            }
        }
        
        if ([allIngredients count]) {
            for (int i=0; i < 1; i++) {
                int randMealIndex = arc4random() % ([allIngredients count] -1);
                EDIngredient *ingrToElim = allIngredients[randMealIndex];

                if (![allFoodsElim containsObject:ingrToElim]) {
                    [EDEliminatedFood createWithFood:ingrToElim startTime:[NSDate date] stopTime:nil forContext:context];
                }
            }
        }
        
    }
    
    
}

#pragma mark - Fetch Requests -
//---------------------------------------------------------------



+ (NSFetchRequest *) fetchAllEliminatedFoodsOfFoodEntity:(NSString *)entityName
                                              ForContext: (NSManagedObjectContext *) context
{
    // we are fetching for objects of entity ...
    NSFetchRequest *fetchForEntity = [EDFood fetchObjectsForEntityName:entityName];
    
    NSError *error;
    // get the objects of entityName
    NSSet *allOfEntity = [NSSet setWithArray:[context executeFetchRequest:fetchForEntity error:&error]];
    
    //return [EDFood fetchObjectsForEntityName:ELIMINATED_FOOD_ENTITY_NAME withSelfInSet:allOfEntity];
    
    // fetch elim objects based on the elimObj.eliminatedFood is in set
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"eliminatedFoods IN %@", allOfEntity];
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:ELIMINATED_FOOD_ENTITY_NAME];
    fetch.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[pred]];
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"eliminatedFood.name" ascending:YES]];
    
    
    return fetch;
}

+ (NSFetchRequest *) fetchAllEliminatedFoods
{
    NSFetchRequest *fetch = [EDFood fetchObjectsForEntityName:ELIMINATED_FOOD_ENTITY_NAME];
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"eliminatedFood.name" ascending:YES]];
    return fetch;
}

+ (NSFetchRequest *) fetchAllCurrentEliminatedFoods
{
    NSDate *today = [NSDate date];
    NSPredicate *predStart = [NSPredicate predicateWithFormat:@"date < %@", today];
    
    NSPredicate *predStop1 = [NSPredicate predicateWithFormat:@"stop == NULL"];
    NSPredicate *predStop2 = [NSPredicate predicateWithFormat:@"stop > %@", today];
    NSPredicate *predStop = [NSCompoundPredicate orPredicateWithSubpredicates:@[predStop1, predStop2]];
    
    NSPredicate *predCurrent = [NSCompoundPredicate andPredicateWithSubpredicates:@[predStart, predStop]];
    
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:ELIMINATED_FOOD_ENTITY_NAME];
    fetch.predicate = predCurrent;
    
    // sort by most recently added to elim foods
    
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    //fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"eliminatedFood.name" ascending:YES]];
    
    return fetch;
}


+ (NSFetchRequest *) fetchAllEliminatedTypesForContext:(NSManagedObjectContext *)context
{
    return [EDEliminatedFood fetchAllEliminatedFoodsOfFoodEntity:TYPE_ENTITY_NAME ForContext:context];
}

+ (NSFetchRequest *) fetchAllEliminatedIngredientsForContext:(NSManagedObjectContext *)context
{
    return [EDEliminatedFood fetchAllEliminatedFoodsOfFoodEntity:INGREDIENT_ENTITY_NAME ForContext:context];
}

+ (NSFetchRequest *) fetchAllEliminatedMealsForContext:(NSManagedObjectContext *)context
{
    return [EDEliminatedFood fetchAllEliminatedFoodsOfFoodEntity:MEAL_ENTITY_NAME ForContext:context];
}

+ (NSFetchRequest *) fetchAllEliminatedRestaurantsForContext:(NSManagedObjectContext *)context
{
    //  return [EDEliminatedFood fetchAllEliminatedFoodsOfFoodEntity: ForContext:context];
    return nil;
}


#pragma mark - Validation Methods -
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
    // only thing we check here is if start < stop
    BOOL valid = [super validateConsistency:error];
    
    if (self.stop) {
        valid = [self.date isEqualToDate:[self.date earlierDate:self.stop]];
    }
    
    if (!valid && error != NULL) {
        NSString *startAfterStopString = @"The start value occurs after the stop value";
        NSMutableDictionary *startAfterStopInfo = [NSMutableDictionary dictionary];
        startAfterStopInfo[NSLocalizedFailureReasonErrorKey] = startAfterStopString;
        startAfterStopInfo[NSValidationObjectErrorKey] = self;
        
        NSError *startAfterStopError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                           code:NSManagedObjectValidationError
                                                       userInfo:startAfterStopInfo];
        
        // if there was no previous error, return the new error
        if (*error == nil) {
            *error = startAfterStopError;
        }
        // if there was a previous error, combine it with the existing one
        else {
            *error = [NSError errorFromOriginalError:*error error:startAfterStopError];
        }
    }
    
    if (!valid) {
        NSLog(@"%@", [*error localizedDescription]);
    }
    
    return valid;
}

#pragma mark - Helper Methods -
//---------------------------------------------------------------

- (BOOL)isCurrent
{
    return [EDEliminatedFood isTime:[NSDate date]
                        betweenPast:self.date
                          andFuture:self.stop];
}

+ (BOOL) isTime:(NSDate *)time
    betweenPast:(NSDate *)past
      andFuture:(NSDate *)future
{
    BOOL between = FALSE;
    
    NSDate *earlier = [time earlierDate:past];
    NSDate *later = [time laterDate:future];
    
    // if past is earlier than time, and future is later
    if ([earlier isEqualToDate:past] && [later isEqualToDate:future]) {
        between = TRUE;
    }
    
    return between;
}

- (NSTimeInterval) getTimeInterval
{
    return [self.date timeIntervalSinceDate:self.stop];
}

- (BOOL) overlapWithEliminatedFood:(EDEliminatedFood *)elim
{
    return [self overlapWithStart:elim.date stop:elim.stop];
}

- (BOOL) overlapWithStart:(NSDate *)start
                     stop:(NSDate *)stop
{
    // overlap occurs if either startStop.date or startStop.stop is between start and stop of receiver
    // thankfully we have a helpful method isTime:betweenPast:andFuture:
    BOOL startsBetween = FALSE;
    BOOL stopsBetween = FALSE;
    
    startsBetween = [EDEliminatedFood isTime:start
                                 betweenPast:self.date
                                   andFuture:self.stop];
    
    stopsBetween = [EDEliminatedFood isTime:stop
                                betweenPast:self.date
                                  andFuture:self.stop];
    
    if (startsBetween && stopsBetween) {
        NSLog(@"Input times lie completely between receiving object");
        return TRUE;
    }
    else if (startsBetween || stopsBetween){
        NSLog(@"Input times have a partial overlap with receiving object");
        return TRUE;
    }
    else if (!startsBetween &&
             !stopsBetween &&
             [EDEliminatedFood isTime:self.date betweenPast:start andFuture:stop])
    {
        NSLog(@"Receiving EDStartStop completely contains the start and stop times");
        return TRUE;
    }
    
    return FALSE;
}

- (NSString *) nameFirstLetter
{
    if ([self.eliminatedFood.name length]) {
        return [self.eliminatedFood.name substringToIndex:1];
    }
    
    return @"";
    
}

- (NSDate *) endDateForSorting
{
    if (!self.stop) {
        self.stop = [NSDate distantFuture];
    }
    
    return self.stop;
}

- (NSDate *) startDateForSorting
{
    return self.date;
}

- (NSString *) currentForSorting
{
    if ([self isCurrent]) {
        return @"Current";
    }
    else {
        return @"Past";
    }
}

@end
