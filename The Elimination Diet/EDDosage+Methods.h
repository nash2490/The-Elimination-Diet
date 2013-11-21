//
//  EDDosage+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/24/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

// Dosage
///
/// Validation -
///     - dosage is non-negative
///     - unit is valid EDUnitOfMeasure
///     - medications are EDMedicationDose that don't already have this dosage/unit pair

#import "EDDosage.h"

@interface EDDosage (Methods)

#pragma mark - Creation Methods -

// basic creation
+ (EDDosage *) createDosage:(double) dosage ofUnit:(EDUnitOfMeasure *) unit inContext:(NSManagedObjectContext *) context;

+ (EDDosage *) createDosage:(double)dosage ofUnit:(EDUnitOfMeasure *)unit forMedications:(NSSet *) medications inContext:(NSManagedObjectContext *) context;


#pragma mark - Fetching -

// get all dosages

// get dosages for unit
//      - done by getting unit and then getting set of dosages



@end
