//
//  EDEatenMeal+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEatenMeal+Methods.h"
#import "EDEvent+Methods.h"

#import "EDEliminatedAPI+Fetching.h"
#import "EDEliminatedAPI+Helpers.h"

#import "EDMeal+Methods.h"



@implementation EDEatenMeal (Methods)

// Creation Methods
//---------------------------------------------------------------

// universal method -
+ (EDEatenMeal *) createEatenMealWithMeal:(EDMeal *) meal
                                   atTime:(NSDate *) eatTime
                               forContext:(NSManagedObjectContext *)context
{
    if (meal && eatTime && context) {
        EDEatenMeal *temp = [NSEntityDescription insertNewObjectForEntityForName:EATEN_MEAL_ENTITY_NAME
                                                          inManagedObjectContext:context];
        
        // set object properties to obvious or empty;
        temp.uniqueID = [EDEliminatedAPI createUniqueID];
        temp.date = eatTime;
        temp.meal = meal;
        
        return temp;
    }
    
    return nil;
}

// Now method -
+ (EDEatenMeal *) eatMealNow:(EDMeal *)meal
                  forContext:(NSManagedObjectContext *)context
{
    return [EDEatenMeal createEatenMealWithMeal:meal
                                         atTime:[NSDate date]
                                     forContext:context];
}


+ (void) setUpDefaultEatenMealsWithContext:(NSManagedObjectContext *)context
{
    [EDEatenMeal generateRandomEatenMealsInContext:context];
}

+ (void) generateRandomEatenMealsInContext: (NSManagedObjectContext *) context
{
    NSArray *allMeals = [context executeFetchRequest:[EDMeal fetchAllMeals] error:nil];

    for (int j=0; j < 6; j++) {
        
        int randTime = arc4random() % 600000;
        NSDate *date = [NSDate dateWithTimeInterval:-randTime sinceDate:[NSDate date]];
        
        int randMealIndex = arc4random() % ([allMeals count] -1);
        EDMeal *mealToEat = allMeals[randMealIndex];
        [EDEatenMeal createEatenMealWithMeal:mealToEat atTime:date forContext:context];
        
    }
   
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
//      - has a meal
- (BOOL)validateConsistency:(NSError **)error
{
    //check overlap of elim
    BOOL valid = [super validateConsistency:error];
    
    // if there are no ingredients or meals, then there must be a restaurant and an associated eaten meal
    if (valid && !self.meal)
    {
        
        valid = NO;
        
        if (error != NULL) {
            NSString *errorString = @"If a meal does NOT have ingredients or parent meals, then it must at least specify a restaurant and a time when it was recently eaten";
            NSMutableDictionary *errorInfo = [NSMutableDictionary dictionary];
            errorInfo[NSLocalizedFailureReasonErrorKey] = errorString;
            errorInfo[NSValidationObjectErrorKey] = self;
            
            NSError *definitionErrorError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                                code:NSManagedObjectValidationError
                                                            userInfo:errorInfo];
            
            // if there was no previous error, return the new error
            if (*error == nil) {
                *error = definitionErrorError;
            }
            // if there was a previous error, combine it with the existing one
            else {
                *error = [NSError errorFromOriginalError:*error error:definitionErrorError];
            }
            NSLog(@" kjkj %@", errorString);
        }
    }
    
    if (!valid) {
        NSLog(@"%@", [*error localizedDescription]);
    }
    
    return valid;
}





// Fetching
// --------------------------------------------------

// order by most recent
+ (NSFetchRequest *) fetchAllEatenMealsWithMedication:(BOOL)medication
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:EATEN_MEAL_ENTITY_NAME];
    
    fetch.includesSubentities = medication;
    return fetch;
}

// fetch those between dates given
+ (NSFetchRequest *) fetchEatenMealsBetweenStart:(NSDate *) start
                                         andStop:(NSDate *) stop withMedication:(BOOL)medication
{
    NSFetchRequest *fetch = [EDEvent fetchEvents:EATEN_MEAL_ENTITY_NAME BetweenStart:start andStop:stop];
    
    fetch.sortDescriptors = [fetch.sortDescriptors arrayByAddingObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    fetch.includesSubentities = medication;

    return fetch;
}

// fetch for last week
+ (NSFetchRequest *) fetchEatenMealsForLastWeekWithMedication:(BOOL)medication
{
    NSFetchRequest *fetch = [EDEvent fetchEventsForLastWeek:EATEN_MEAL_ENTITY_NAME];
    
    fetch.sortDescriptors = [fetch.sortDescriptors arrayByAddingObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    fetch.includesSubentities = medication;
    
    return fetch;
}

// fetch for last 24 hrs
+ (NSFetchRequest *) fetchEatenMealsForYesterdayAndTodayWithMedication:(BOOL)medication
{
    NSFetchRequest *fetch = [EDEvent fetchEventsForYesterdayAndToday:EATEN_MEAL_ENTITY_NAME];
    
    fetch.sortDescriptors = [fetch.sortDescriptors arrayByAddingObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    fetch.includesSubentities = medication;

    return fetch;
}

// fetch for current day
+ (NSFetchRequest *) fetchEatenMealsForTodayWithMedication:(BOOL)medication
{
    NSFetchRequest *fetch = [EDEvent fetchEventsForToday:EATEN_MEAL_ENTITY_NAME];
    
    //fetch.sortDescriptors = [fetch.sortDescriptors arrayByAddingObject:[NSSortDescriptor sortDescriptorWithKey:@"meal.name" ascending:YES]];
    
    fetch.includesSubentities = medication;

    return fetch;
}


// fetch from date
+ (NSFetchRequest *) fetchEatenMealsFromDate:(NSDate *) date withMedication:(BOOL)medication
{
    NSFetchRequest *fetch = [EDEvent fetchEvents:EATEN_MEAL_ENTITY_NAME FromDate:date];
    
    fetch.sortDescriptors = [fetch.sortDescriptors arrayByAddingObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    fetch.includesSubentities = medication;

    return fetch;
}

@end
