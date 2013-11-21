//
//  EDTakenMedication+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/23/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDTakenMedication+Methods.h"

#import "EDMedication+Methods.h"

#import "EDEvent+Methods.h"

#import "EDEliminatedAPI.h"
#import "EDEliminatedAPI+Fetching.h"
#import "EDEliminatedAPI+Helpers.h"

@implementation EDTakenMedication (Methods)


#pragma mark - Creation Methods
//---------------------------------------------------------------

// universal method -
+ (EDTakenMedication *) createWithMedication: (EDMedication *) medication
                                      onDate: (NSDate *) takenDate
                                   inContext: (NSManagedObjectContext *) context;
{
    
    if (medication && takenDate && context) {
        EDTakenMedication *temp = [NSEntityDescription insertNewObjectForEntityForName:TAKEN_MEDICATION_ENTITY_NAME
                                                                inManagedObjectContext:context];
        
        // set object properties to obvious or empty;
        temp.uniqueID = [EDEliminatedAPI createUniqueID];
        temp.date = takenDate;
        temp.medication = medication;
        
        return temp;
    }
    return nil;
}

// Now method -
+ (EDTakenMedication *) takeMedicationNow: (EDMedication *) medication
                                inContext:(NSManagedObjectContext *) context;
{
    return [EDTakenMedication createWithMedication:medication onDate:[NSDate date] inContext:context];
}


//+ (void) setUpDefaultEatenMealsWithContext:(NSManagedObjectContext *)context
//{
//    [EDEatenMeal generateRandomEatenMealsInContext:context];
//}
//
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


#pragma mark - Validation methods
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
    //call validation for eaten meal
    BOOL valid = [super validateConsistency:error];
    
    return valid;
}



#pragma mark - Property getter and setter methods
- (EDMedication *) medication
{
    return (EDMedication *)self.meal;
}

- (void) setMedication: (EDMedication *) value
{
    [self setMeal:value];
}




#pragma mark - Fetching
// --------------------------------------------------

// order by most recent
+ (NSFetchRequest *) fetchAllTakenMedication
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:TAKEN_MEDICATION_ENTITY_NAME];
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];

    return fetch;
}

// fetch those between dates given
+ (NSFetchRequest *) fetchTakenMedicationBetweenStart:(NSDate *)start andStop:(NSDate *)stop
{
    NSFetchRequest *fetch = [EDEvent fetchEvents:TAKEN_MEDICATION_ENTITY_NAME BetweenStart:start andStop:stop];
    
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    return fetch;
}

// fetch for last week
+ (NSFetchRequest *) fetchTakenMedicationForLastWeek
{
    NSFetchRequest *fetch = [EDEvent fetchEventsForLastWeek:TAKEN_MEDICATION_ENTITY_NAME];
    
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    return fetch;
}

// fetch for last 24 hrs
+ (NSFetchRequest *) fetchTakenMedicationForYesterdayAndToday
{
    NSFetchRequest *fetch = [EDEvent fetchEventsForYesterdayAndToday:TAKEN_MEDICATION_ENTITY_NAME];
    
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    return fetch;
}

// fetch for current day
+ (NSFetchRequest *) fetchTakenMedicationForToday
{
    NSFetchRequest *fetch = [EDEvent fetchEventsForToday:TAKEN_MEDICATION_ENTITY_NAME];
    
    //fetch.sortDescriptors = [fetch.sortDescriptors arrayByAddingObject:[NSSortDescriptor sortDescriptorWithKey:@"meal.name" ascending:YES]];
    
    return fetch;}


// fetch from date
+ (NSFetchRequest *) fetchTakenMedicationFromDate:(NSDate *)date
{
    NSFetchRequest *fetch = [EDEvent fetchEvents:TAKEN_MEDICATION_ENTITY_NAME FromDate:date];
    
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    return fetch;}




@end
