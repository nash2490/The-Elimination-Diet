//
//  EDHadSymptom+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDHadSymptom.h"

#define HAD_SYMPTOM_ENTITY_NAME @"EDHadSymptom"

@class EDSymptom;

@interface EDHadSymptom (Methods)

#pragma mark - Creation Methods

/// universal method -
///      - sets meal
///      - asks for time
+ (EDHadSymptom *) createHadSymptomWithSymptom:(EDSymptom *) symptom
                                        atTime:(NSDate *) feelTime
                                    forContext:(NSManagedObjectContext *)context;

/// Now method -
///      - sets meal
///      - uses current time for eating
+ (EDHadSymptom *) createHadSymptomNowWithSymptom:(EDSymptom *) symptom
                                    forContext:(NSManagedObjectContext *)context;

+ (void) setUpDefaultHadSymptomsWithContext: (NSManagedObjectContext *) context;

#pragma mark - Fetching


/// order by most recent
+ (NSFetchRequest *) fetchAllHadSymptom;

/// fetch those between dates given
+ (NSFetchRequest *) fetchHadSymptomsBetweenStart:(NSDate *) start
                                          andStop:(NSDate *) stop;

/// fetch for last week
+ (NSFetchRequest *) fetchHadSymptomsForLastWeek;

/// fetch for last 24 hrs
+ (NSFetchRequest *) fetchHadSymptomsForYesterdayAndToday;

/// fetch for current day
+ (NSFetchRequest *) fetchHadSymptomsForToday;

/// fetch from date
+ (NSFetchRequest *) fetchHadSymptomsFromDate:(NSDate *) date;

@end
