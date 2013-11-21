//
//  EDEatenMeal+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEatenMeal.h"
#import "EDEvent+Methods.h"

#define EATEN_MEAL_ENTITY_NAME @"EDEatenMeal"

@class EDMeal;

@interface EDEatenMeal (Methods)

#pragma mark - Creation Methods

/// universal method -
///      - sets meal
///      - asks for time
+ (EDEatenMeal *) createEatenMealWithMeal:(EDMeal *) meal
                                   atTime:(NSDate *) eatTime
                               forContext:(NSManagedObjectContext *)context;

/// Now method -
///      - sets meal
///      - uses current time for eating
+ (EDEatenMeal *) eatMealNow:(EDMeal *) meal
                  forContext:(NSManagedObjectContext *)context;

+ (void) setUpDefaultEatenMealsWithContext: (NSManagedObjectContext *) context;

#pragma mark - Fetching


/// order by most recent
+ (NSFetchRequest *) fetchAllEatenMealsWithMedication: (BOOL) medication;

/// fetch those between dates given
+ (NSFetchRequest *) fetchEatenMealsBetweenStart:(NSDate *) start
                                         andStop:(NSDate *) stop
                                  withMedication: (BOOL) medication;

/// fetch for last week
+ (NSFetchRequest *) fetchEatenMealsForLastWeekWithMedication: (BOOL) medication;

/// fetch for last 24 hrs
+ (NSFetchRequest *) fetchEatenMealsForYesterdayAndTodayWithMedication: (BOOL) medication;

/// fetch for current day
+ (NSFetchRequest *) fetchEatenMealsForTodayWithMedication: (BOOL) medication;

/// fetch from date
+ (NSFetchRequest *) fetchEatenMealsFromDate:(NSDate *) date withMedication: (BOOL) medication;



@end
