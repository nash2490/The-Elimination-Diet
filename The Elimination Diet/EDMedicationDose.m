//
//  EDMedicationDose.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDMedicationDose.h"
#import "EDMedication.h"
#import "EDMedicationDose.h"
#import "EDTag.h"
#import "EDTakenMedication.h"
#import "EDUnitOfMeasure.h"


@implementation EDMedicationDose

@dynamic dosage;
@dynamic uniqueID;
@dynamic dosagesInChildren;
@dynamic medication;
@dynamic parentMedicationDosages;
@dynamic timesTaken;
@dynamic unit;
@dynamic tags;

@end
