//
//  EDTakenMedication+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/23/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

/*
 
 Validation == same as EDEatenMeal
 
 
 */

#import "EDTakenMedication.h"

#define TAKEN_MEDICATION_ENTITY_NAME @"EDTakenMedication"


@class EDMedication;

@interface EDTakenMedication (Methods)


#pragma mark - Creation Methods -

// basic
+ (EDTakenMedication *) createWithMedication: (EDMedication *) medication
                                      onDate: (NSDate *) takenDate
                                   inContext: (NSManagedObjectContext *) context;

+ (EDTakenMedication *) takeMedicationNow: (EDMedication *) medication
                                inContext:(NSManagedObjectContext *) context;


#pragma mark - Property getter and setter methods
- (EDMedication *) medication;
- (void) setMedication: (EDMedication *) value;


#pragma mark - Fetching -

/// order by most recent
+ (NSFetchRequest *) fetchAllTakenMedication;

/// fetch those between dates given
+ (NSFetchRequest *) fetchTakenMedicationBetweenStart:(NSDate *) start
                                         andStop:(NSDate *) stop;

/// fetch for last week
+ (NSFetchRequest *) fetchTakenMedicationForLastWeek;

/// fetch for last 24 hrs
+ (NSFetchRequest *) fetchTakenMedicationForYesterdayAndToday;

/// fetch for current day
+ (NSFetchRequest *) fetchTakenMedicationForToday;

/// fetch from date
+ (NSFetchRequest *) fetchTakenMedicationFromDate:(NSDate *) date;

@end
