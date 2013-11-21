//
//  EDDosage.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/26/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EDMedicationDose, EDUnitOfMeasure;

@interface EDDosage : NSManagedObject

@property (nonatomic, retain) NSNumber * dosage;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSSet *medications;
@property (nonatomic, retain) EDUnitOfMeasure *unit;
@end

@interface EDDosage (CoreDataGeneratedAccessors)

- (void)addMedicationsObject:(EDMedicationDose *)value;
- (void)removeMedicationsObject:(EDMedicationDose *)value;
- (void)addMedications:(NSSet *)values;
- (void)removeMedications:(NSSet *)values;

@end
