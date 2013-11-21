//
//  EDDosage+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/24/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDDosage+Methods.h"
#import "EDUnitOfMeasure+Methods.h"
#import "EDEliminatedAPI+Fetching.h"

@implementation EDDosage (Methods)

#pragma mark - Creation Methods -

// basic creation
+ (EDDosage *) createDosage:(double) dosage ofUnit:(EDUnitOfMeasure *) unit inContext:(NSManagedObjectContext *) context
{
    // check for existance of unit with that name
    BOOL unique = TRUE;
    EDUnitOfMeasure *duplicateUnit = nil;
    NSError *error;
    
    NSArray *unitsForName = [context executeFetchRequest:[EDUnitOfMeasure fetchUnitForName:unitName]
                                                   error:&error];
    
    if ([unitsForName count] == 1) {
        duplicateUnit = unitsForName[0];
        unique = FALSE;
    }
    else if ([unitsForName count] > 1) {
        // error, there should only be 1 with this name
        unique = FALSE;
    }
    
    
    // is double non-negative
    BOOL valid = (defaultValue >= 0);
    
    // are usedDosages valid dosages?
    
    
    // if unique and valid, we create
    if (unique && valid) {
        duplicateUnit = [NSEntityDescription insertNewObjectForEntityForName:UNIT_OF_MEASURE_ENTITY_NAME inManagedObjectContext:context];
        
        duplicateUnit.uniqueID = [EDEliminatedAPI createUniqueID];
        duplicateUnit.name = unitName;
        duplicateUnit.defaultValue = @(defaultValue);
        
        if (!usedDosages) {
            duplicateUnit.usedDosages = [[NSSet alloc] init];
        }
        else {
            duplicateUnit.usedDosages = usedDosages;
        }
        
    }
    
    return duplicateUnit;
}

+ (EDDosage *) createDosage:(double)dosage ofUnit:(EDUnitOfMeasure *)unit forMedications:(NSSet *)medications inContext:(NSManagedObjectContext *)context
{
    
}

#pragma mark - Fetching -

+ (NSFetchRequest *) fetchUnitForName:(NSString *)unitName
{
    return [EDEliminatedAPI fetchObjectsForEntityName:UNIT_OF_MEASURE_ENTITY_NAME withName:unitName];
}

+ (NSFetchRequest *) fetchAllUnits
{
    return [EDEliminatedAPI fetchObjectsSortedByNameForEntityName:UNIT_OF_MEASURE_ENTITY_NAME];
}

#pragma mark - Validation Methods -
// ------------------------------------------------------


// Validation methods
//---------------------------------------------------------------

- (BOOL)validateForInsert:(NSError **)error
{
    BOOL propertiesValid = [super validateForInsert:error];
    if (!propertiesValid) return FALSE;
    
    BOOL consistencyValid = [self validateConsistency:error];
    return (propertiesValid && consistencyValid);
}

- (BOOL)validateForUpdate:(NSError **)error
{
    BOOL propertiesValid = [super validateForUpdate:error];
    if (!propertiesValid) return FALSE;
    
    BOOL consistencyValid = [self validateConsistency:error];
    return (propertiesValid && consistencyValid);
}




// **** CENTRAL VALIDATION METHOD ****
/// - We need to check
//      - no overlap of elim
//      - that there is at lease one object in ingredientsAdded and mealParents
//              - these can be empty if we specify it is to be changed later
//              - should have eaten meal associated with (but here is catch since meal must exist before the eaten meal)
//      - that there are NO cycles of meals
- (BOOL)validateConsistency:(NSError **)error
{
    //check overlap of elim
    BOOL valid = YES;
    
    // if there are no ingredients or meals, then there must be a restaurant and an associated eaten meal
    if (valid)
    {
        
        valid = NO;
        
        if (error != NULL) {
            NSString *definitionErrorString = @"If a meal does NOT have ingredients or parent meals, then it must at least specify a restaurant and a time when it was recently eaten";
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
            NSLog(@" kjkj %@", definitionErrorString);
        }
    }
    
    return valid;
}



@end
