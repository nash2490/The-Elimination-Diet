//
//  EDUnitOfMeasure.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/26/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EDMedicationDose;

@interface EDUnitOfMeasure : NSManagedObject

@property (nonatomic, retain) NSNumber * defaultValue;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSSet *medicationDoses;
@end

@interface EDUnitOfMeasure (CoreDataGeneratedAccessors)

- (void)addMedicationDosesObject:(EDMedicationDose *)value;
- (void)removeMedicationDosesObject:(EDMedicationDose *)value;
- (void)addMedicationDoses:(NSSet *)values;
- (void)removeMedicationDoses:(NSSet *)values;

@end
