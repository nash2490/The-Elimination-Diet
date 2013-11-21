//
//  EDMedicationDose+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/24/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

/*

 Validation 
    - all objects are valid
    - dosage of self is >= sum(parentMed dosages)
 
 
*/



#import "EDMedicationDose.h"


#define MEDICATION_DOSE_ENTITY_NAME @"EDMedicationDose"


@class EDMedication;


@interface EDMedicationDose (Methods)

#pragma mark - Creation Methods -

// basic
+ (EDMedicationDose *) createWithMedication:(EDMedication *) medication
                                 withDosage:(double) dosage
                                     ofUnit:(EDUnitOfMeasure *) unit
                           parentMedDosages:(NSSet *) parentMedDosages
                                    andTags:(NSSet *) tags
                                  inContext:(NSManagedObjectContext *) context;


+ (EDMedicationDose *) generateRandomMedDoseForMed: (EDMedication *) medication
                                         inContext: (NSManagedObjectContext *) context;


#pragma mark - Fetching -

+ (NSFetchRequest *) fetchAllMedicationDosages;


#pragma mark - Tag Fetching -
/// get the food objects of entity and for the tags
+ (NSFetchRequest *) fetchAllMedicationDosagesForTags: (NSSet *) tags;

#pragma mark - Searching -

/// search through name and tags
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
                               forSearchString:(NSString *)text;

///// search through names and tags, but exclude those in the given set
//+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
//                               forSearchString:(NSString *)text
//                                  exludingTag:(EDTag *) tag;

/// search only through food names for the given text
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName foodNameContainingText:(NSString *)text;

#pragma mark - Tagging

/// is favorite/favorite
- (BOOL) isFavorite;

/// is beverage - can't do just yet

/// tags as string
- (NSString *) tagsAsString;


#pragma mark - property helper methods

- (NSString *) name;

- (NSString *) nameFirstLetter;


- (NSSet *) descendants;
- (NSSet *) ancestors;

/// returns YES if a cycle is created in parents/children
- (BOOL) hasCycles: (NSError **) error;

#pragma mark - Helpers


@end
