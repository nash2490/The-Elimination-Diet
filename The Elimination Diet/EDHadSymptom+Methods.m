//
//  EDHadSymptom+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDHadSymptom+Methods.h"

#import "EDSymptom+Methods.h"
#import "EDEvent+Methods.h"

#import "EDEliminatedAPI+Fetching.h"
#import "EDEliminatedAPI+Helpers.h"



@implementation EDHadSymptom (Methods)

// Creation Methods
//---------------------------------------------------------------

// universal method -
+ (EDHadSymptom *) createHadSymptomWithSymptom:(EDSymptom *)symptom
                                        atTime:(NSDate *)feelTime
                                    forContext:(NSManagedObjectContext *)context
{
    if (symptom && feelTime && context) {
        EDHadSymptom *temp = [NSEntityDescription insertNewObjectForEntityForName:HAD_SYMPTOM_ENTITY_NAME
                                                          inManagedObjectContext:context];
        
        // set object properties to obvious or empty;
        temp.uniqueID = [EDEliminatedAPI createUniqueID];
        temp.date = feelTime;
        temp.symptom = symptom;
        
        return temp;
    }
    
    return nil;
}

// Now method -
+ (EDHadSymptom *) createHadSymptomNowWithSymptom:(EDSymptom *)symptom
                                       forContext:(NSManagedObjectContext *)context
{
    return [EDHadSymptom createHadSymptomWithSymptom:symptom
                                              atTime:[NSDate date]
                                          forContext:context];
}


+ (void) setUpDefaultHadSymptomsWithContext:(NSManagedObjectContext *)context
{
    
}

//+ (void) generateRandomEatenMealsInContext: (NSManagedObjectContext *) context
//{
//    NSArray *allMeals = [context executeFetchRequest:[EDMeal fetchAllMeals] error:nil];
//    
//    for (int j=0; j < 6; j++) {
//        
//        int randTime = arc4random() % 600000;
//        NSDate *date = [NSDate dateWithTimeInterval:-randTime sinceDate:[NSDate date]];
//        
//        int randMealIndex = arc4random() % ([allMeals count] -1);
//        EDMeal *mealToEat = allMeals[randMealIndex];
//        [EDEatenMeal createEatenMealWithMeal:mealToEat atTime:date forContext:context];
//        
//    }
//    
//}


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
    
    if (valid && !self.symptom)
    {
        
        valid = NO;
        
        if (error != NULL) {
            NSString *errorString = @"Does not Have a valid symptom";
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
+ (NSFetchRequest *) fetchAllHadSymptom
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:HAD_SYMPTOM_ENTITY_NAME];
    
    return fetch;
}

// fetch those between dates given
+ (NSFetchRequest *) fetchHadSymptomsBetweenStart:(NSDate *) start
                                          andStop:(NSDate *) stop
{
    NSFetchRequest *fetch = [EDEvent fetchEvents:HAD_SYMPTOM_ENTITY_NAME BetweenStart:start andStop:stop];
    
    fetch.sortDescriptors = [fetch.sortDescriptors arrayByAddingObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    
    return fetch;
}

// fetch for last week
+ (NSFetchRequest *) fetchHadSymptomsForLastWeek
{
    NSFetchRequest *fetch = [EDEvent fetchEventsForLastWeek:HAD_SYMPTOM_ENTITY_NAME];
    
    fetch.sortDescriptors = [fetch.sortDescriptors arrayByAddingObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    
    return fetch;
}

// fetch for last 24 hrs
+ (NSFetchRequest *) fetchHadSymptomsForYesterdayAndToday
{
    NSFetchRequest *fetch = [EDEvent fetchEventsForYesterdayAndToday:HAD_SYMPTOM_ENTITY_NAME];
    
    fetch.sortDescriptors = [fetch.sortDescriptors arrayByAddingObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    
    return fetch;
}

// fetch for current day
+ (NSFetchRequest *) fetchHadSymptomsForToday
{
    NSFetchRequest *fetch = [EDEvent fetchEventsForToday:HAD_SYMPTOM_ENTITY_NAME];
    
    fetch.sortDescriptors = [fetch.sortDescriptors arrayByAddingObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    
    return fetch;
}


// fetch from date
+ (NSFetchRequest *) fetchHadSymptomsFromDate:(NSDate *) date
{
    NSFetchRequest *fetch = [EDEvent fetchEvents:HAD_SYMPTOM_ENTITY_NAME FromDate:date];
    
    fetch.sortDescriptors = [fetch.sortDescriptors arrayByAddingObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    
    return fetch;
}

@end
