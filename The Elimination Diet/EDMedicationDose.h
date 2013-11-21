//
//  EDMedicationDose.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EDMedication, EDMedicationDose, EDTag, EDTakenMedication, EDUnitOfMeasure;

@interface EDMedicationDose : NSManagedObject

@property (nonatomic, retain) NSNumber * dosage;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSSet *dosagesInChildren;
@property (nonatomic, retain) EDMedication *medication;
@property (nonatomic, retain) NSSet *parentMedicationDosages;
@property (nonatomic, retain) NSSet *timesTaken;
@property (nonatomic, retain) EDUnitOfMeasure *unit;
@property (nonatomic, retain) NSSet *tags;
@end

@interface EDMedicationDose (CoreDataGeneratedAccessors)

- (void)addDosagesInChildrenObject:(EDMedicationDose *)value;
- (void)removeDosagesInChildrenObject:(EDMedicationDose *)value;
- (void)addDosagesInChildren:(NSSet *)values;
- (void)removeDosagesInChildren:(NSSet *)values;

- (void)addParentMedicationDosagesObject:(EDMedicationDose *)value;
- (void)removeParentMedicationDosagesObject:(EDMedicationDose *)value;
- (void)addParentMedicationDosages:(NSSet *)values;
- (void)removeParentMedicationDosages:(NSSet *)values;

- (void)addTimesTakenObject:(EDTakenMedication *)value;
- (void)removeTimesTakenObject:(EDTakenMedication *)value;
- (void)addTimesTaken:(NSSet *)values;
- (void)removeTimesTaken:(NSSet *)values;

- (void)addTagsObject:(EDTag *)value;
- (void)removeTagsObject:(EDTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
