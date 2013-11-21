//
//  EDUnitOfMeasure+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/24/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

// Unit of measure
///
/// Validation -
///     - unitName must be unique
///     - defaultValue is NSNumber double that is non-negative

#import "EDUnitOfMeasure.h"

#define UNIT_OF_MEASURE_ENTITY_NAME @"EDUnitOfMeasure"

@class EDDosage;

@interface EDUnitOfMeasure (Methods)

#pragma mark - Creation Methods -

// Basic Creation
+ (EDUnitOfMeasure *) createUnitOfMeasure:(NSString *) unitName withDefaultValue:(double) defaultValue inContext:(NSManagedObjectContext *) context;

+ (EDUnitOfMeasure *) createUnitOfMeasure:(NSString *)unitName withDefaultValue:(double)defaultValue andMedicationDoses: (NSSet *) medicationDoses inContext:(NSManagedObjectContext *) context;

+ (void) setUpDefaultUnitsInContext:(NSManagedObjectContext *)context;

#pragma mark - Fetching and Getting -

// fetch unit of measure for name
+ (NSFetchRequest *) fetchUnitForName:(NSString *) unitName;

// fetch all units
+ (NSFetchRequest *) fetchAllUnits;

@end
