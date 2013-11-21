//
//  EDMedicationDose+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/24/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDMedicationDose+Methods.h"

#import "EDEliminatedAPI+Fetching.h"
#import "EDEliminatedAPI+Searching.h"
#import "EDEliminatedAPI+Helpers.h"
#import "EDEliminatedAPI+Sorting.h"

#import "EDMedication+Methods.h"
#import "EDUnitOfMeasure+Methods.h"

#import "EDIngredient+Methods.h"

#import "EDTag+Methods.h"


@implementation EDMedicationDose (Methods)

#pragma mark - Creation Methods -

// basic
+ (EDMedicationDose *) createWithMedication:(EDMedication *) medication
                                 withDosage:(double) dosage
                                     ofUnit:(EDUnitOfMeasure *) unit
                           parentMedDosages:(NSSet *) parentMedDosages
                                    andTags:(NSSet *) tags
                                  inContext:(NSManagedObjectContext *) context
{
    EDMedicationDose *resultDose = [medication duplicateMediationDoseWithUnit:unit
                                                                   mainDosage:dosage
                                                             andParentDosages:parentMedDosages];
    
    BOOL unique = (resultDose == nil);
    
    // is double non-negative
    BOOL valid = (dosage >= 0);
    
    
    // if unique and valid, we create
    if (unique && valid && medication && unit) {
        resultDose = [NSEntityDescription insertNewObjectForEntityForName:MEDICATION_DOSE_ENTITY_NAME inManagedObjectContext:context];
        
        resultDose.uniqueID = [EDEliminatedAPI createUniqueID];
        
        resultDose.dosage = @(dosage);
        
        resultDose.unit = unit;
        resultDose.medication = medication;
        
        if (parentMedDosages) {
            resultDose.parentMedicationDosages = parentMedDosages;
        }
        else {
            resultDose.parentMedicationDosages = [[NSSet alloc] init];
        }
        
        if (tags) {
            resultDose.tags = tags;
        }
        else {
            resultDose.tags = [[NSSet alloc] init];
        }
        
    }
    
    return resultDose;
}



+ (EDMedicationDose *) generateRandomMedDoseForMed: (EDMedication *) medication
                                         inContext: (NSManagedObjectContext *) context
{
    //NSArray *allMedDose = [context executeFetchRequest:[EDMedication fetchAllMedication] error:nil];
    
    
    double dosage = (arc4random() % 100) + 25;
    

    
    NSMutableSet *mutParentMedDoses = [NSMutableSet set];
    
    for (EDMedication *medParent in medication.medicationParents) {
        if ([medParent.dosages count]) {
            [mutParentMedDoses addObject:[medParent.dosages anyObject]];
        }
    }
    
    EDUnitOfMeasure *mgUnit = [context executeFetchRequest:[EDUnitOfMeasure fetchUnitForName:@"mg"] error:nil][0];
    
    EDTag *favoriteTag = [EDTag getFavoriteTagInContext:context];

    
    return [EDMedicationDose createWithMedication:medication withDosage:dosage ofUnit:mgUnit  parentMedDosages:[mutParentMedDoses copy] andTags:[NSSet setWithObject:favoriteTag] inContext:context];
}


#pragma mark - Fetching and Getting -

+ (NSFetchRequest *) fetchAllUnits
{
    return [EDEliminatedAPI fetchObjectsSortedByNameForEntityName:MEDICATION_DOSE_ENTITY_NAME];
}

#pragma mark - Ancestor and Descendent methods


#pragma mark - Fetching -

+ (NSFetchRequest *) fetchAllMedicationDosages
{
    return [EDEliminatedAPI fetchObjectsForEntityName:MEDICATION_DOSE_ENTITY_NAME withSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dosage" ascending:YES]]];
}


+ (NSFetchRequest *) fetchAllMedicationDosagesForTags: (NSSet *) tags
{
    NSFetchRequest *fetch = [EDTag fetchObjectsForEntityName:MEDICATION_DOSE_ENTITY_NAME withTags:tags];
    fetch.sortDescriptors = @[[EDEliminatedAPI sortDescriptorForProperty:@"medication.name" caseInsensitive:YES]];
    
    return fetch;
}

// Sorting
//---------
// search through name and tags
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName forSearchString:(NSString *)text
{
    
    
    return [EDEliminatedAPI fetchObjectsForEntityName:entityName forSearchString:text];
}


//+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
//                               forSearchString:(NSString *)text
//                                  exludingTags:(NSSet *) tags
//{
//    NSFetchRequest *fetchObjects = [NSFetchRequest fetchRequestWithEntityName:entityName];
//
//    NSPredicate *nameSearchPred = [NSPredicate predicateWithFormat:@"name contains[cd] %@", text];
//    NSPredicate *tagSearchPred = [NSPredicate predicateWithFormat:@"ANY tags.name contains[cd] %@", text];
//
//    fetchObjects.predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[nameSearchPred, tagSearchPred]];
//
//    fetchObjects.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
//
//    return fetchObjects;
//}


// only searches through the names
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName foodNameContainingText:(NSString *)text
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName nameContainingText:text];
    
    fetch.sortDescriptors = @[[EDEliminatedAPI nameSortDescriptor]];
    
    return fetch;
}

#pragma mark - Tagging
- (BOOL) isFavorite
{
    EDTag *starTag = [EDTag getFavoriteTagInContext:self.managedObjectContext];
    if ([self.tags containsObject:starTag]) {
        return TRUE;
    }
    return FALSE;
}

- (NSString *) tagsAsString
{
    return [EDTag convertIntoString:self.tags];
}



# pragma mark - Property helper methods -
// ---------------------------------------------------------

- (NSString *) name
{
    if (self.medication) {
        NSString *shortenedMedName = [self.medication.name substringToIndex:8];
        
        if (![shortenedMedName isEqualToString:self.medication.name]) {
            shortenedMedName = [shortenedMedName stringByAppendingString:@"..."];
        }
        NSString *name = [NSString stringWithFormat:@"Dose - %@ - (%.2f)", shortenedMedName, [self.dosage doubleValue]];
        
        NSLog(@"%@", name);
        return name;
    }
    return @"";
}

- (NSString *) nameFirstLetter
{
    return [EDEliminatedAPI nameFirstLetter:self.name];
}


// returns all the descendants (includes children) of the receiver
// --- makes sure no to create an infinite loop from self inheritence
//      --- if self inheritence does occur, the result will contain self,
//           which can be tested easily to determine validity
- (NSSet *) descendantsCyclical: (NSSet *) knownRelatives
{
    NSSet *descendants = nil;
    
    if (!knownRelatives) {
        descendants = [[NSSet alloc] init];
    }
    else {
        descendants = [knownRelatives copy];
    }
    
    NSMutableSet *mutNewChildren = [self.dosagesInChildren mutableCopy];
    
    // new children are those in self.ingredientChildren that aren't in descendants
    [mutNewChildren minusSet:descendants];
    NSSet *newChildren = [mutNewChildren copy];
    
    // add the ingredientChildren to descendants
    descendants = [descendants setByAddingObjectsFromSet:newChildren];
    
    // for each ingredient in newChildren
    for (EDMedicationDose *child in newChildren) {
        
        // add the descendants (and the knownRelatives passed as arguement) of ingr to descendants
        descendants = [child descendantsCyclical:descendants];
    }
    
    return [descendants copy];
}

// returns all the ancestors (includes parents) of the receiver
// --- makes sure no to create an infinite loop from self inheritence
//      --- if self inheritence does occur, the result will contain self,
//           which can be tested easily to determine validity
- (NSSet *) ancestorsCyclical: (NSSet *) knownRelatives
{
    NSSet *ancestors = nil;
    
    if (!knownRelatives) {
        ancestors = [[NSSet alloc] init];
    }
    else {
        ancestors = [knownRelatives copy];
    }
    
    NSMutableSet *mutNewParents = [self.parentMedicationDosages mutableCopy];
    
    // new parents are those in self.ingredientParents that aren't in ancestors
    [mutNewParents minusSet:ancestors];
    NSSet *newParents = [mutNewParents copy];
    
    // add the ingredientParents to ancestors
    ancestors= [ancestors setByAddingObjectsFromSet:newParents];
    
    // for each ingredient in newParents
    for (EDMedicationDose *parent in newParents) {
        
        // add the ancestors (and the knownRelatives passed as arguement) of ingr to ancestors
        ancestors = [parent ancestorsCyclical:ancestors];
    }
    
    return [ancestors copy];
}


- (NSSet *) descendants
{
    return [self descendantsCyclical:nil];
}

- (NSSet *) ancestors
{
    return [self ancestorsCyclical:nil];
}


//
- (BOOL) hasCycles:(NSError *__autoreleasing *)error
{
    NSSet *ancestors = [self ancestors];
    if ([ancestors containsObject:self]) {
        
        NSString *definitionErrorString = @"The MedicationDose contains a cycle in its parent/child properties";
        NSMutableDictionary *definitionErrorInfo = [NSMutableDictionary dictionary];
        definitionErrorInfo[NSLocalizedFailureReasonErrorKey] = definitionErrorString;
        definitionErrorInfo[NSValidationObjectErrorKey] = self;
        
        NSError *definitionErrorError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                            code:NSManagedObjectValidationError
                                                        userInfo:definitionErrorInfo];
        
        // if there was no previous error, return the new error
        if (*error == nil) {
            *error = definitionErrorError;
        }
        // if there was a previous error, combine it with the existing one
        else {
            *error = [NSError errorFromOriginalError:*error error:definitionErrorError];
        }
        NSLog(@"%@", definitionErrorString);
        
        
        return YES;
    }
    return NO;
}

#pragma mark - Validation

// Validation Helpers
//---------------------------------------------------------------



// Validation methods
//---------------------------------------------------------------

- (BOOL)validateForInsert:(NSError **)error
{
    BOOL propertiesValid = [super validateForInsert:error];
    if (!propertiesValid) {
        
        NSLog(@"%@", [*error localizedDescription]);
        NSLog(@"error event");
        return FALSE;
    }
    
    BOOL consistencyValid = [self validateConsistency:error];
    return (propertiesValid && consistencyValid);
}

- (BOOL)validateForUpdate:(NSError **)error
{
    BOOL propertiesValid = [super validateForUpdate:error];
    if (!propertiesValid) {
        
        NSLog(@"%@", [*error localizedDescription]);
        return FALSE;
    }
    
    BOOL consistencyValid = [self validateConsistency:error];
    return (propertiesValid && consistencyValid);
}





// **** CENTRAL VALIDATION METHOD ****
/// - We need to check
//      -
//      - that there are NO cycles of parentMedicationDosages
- (BOOL)validateConsistency:(NSError **)error
{
    //  do cycles in parent/children exist
    BOOL valid = ![self hasCycles:error];
    
    //
    if (!valid)
    {
        
    }
    
    return valid;
}

@end
