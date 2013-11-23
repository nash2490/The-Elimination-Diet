//
//  EDSymptomDescription+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/21/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDSymptomDescription+Methods.h"



#import "EDEliminatedAPI+Fetching.h"
#import "EDEliminatedAPI+Searching.h"
#import "EDEliminatedAPI+Sorting.h"
#import "EDEliminatedAPI+Helpers.h"

#import "EDTag+Methods.h"
#import "EDEliminatedFood+Methods.h"

#import "EDSymptom+Methods.h"
#import "EDHadSymptom+Methods.h"

#import "NSError+MultipleErrors.h"
#import "NSString+EatDate.h"



@implementation EDSymptomDescription (Methods)


#pragma mark - Property Creation
// --------------------------------------------------

+ (EDSymptomDescription *) createSymptomDescriptionWithName:(NSString *)name
                                                 forContext:(NSManagedObjectContext *)context
{
    // we require all of these
    if (!name) {
        return nil;
    }
    
    // Check For Duplicate ------------------
    // check if a meal with the same name already exists
    NSFetchRequest *fetch = [self fetchSymptomDescriptionsForName:name];
    
    NSError *error;
    NSArray *sameName = [context executeFetchRequest:fetch error:&error];
    
    // unique will be used to determine if another object exists with the same
    //      - name
    //      - added ingredients
    //      - parents
    //      - restaurant
    
    BOOL unique = TRUE;
    
    
    if ([sameName count]) {
        if ([sameName count] == 1) {
            return sameName[0];
        }
        else {  /// then we have an error since we should only have one
            return nil;
        }
    }
    
    
    
    // if this meal is unique, then create it
    if (unique) {
        
        EDSymptomDescription *temp = [NSEntityDescription insertNewObjectForEntityForName:SYMPTOM_DESCRIPTION_ENTITY_NAME
                                                         inManagedObjectContext:context];
        
        // set object properties to obvious or empty;
        temp.name = name;
        temp.uniqueID = [EDEliminatedAPI createUniqueID];
        
        return temp;
    }
    
    else {
        return nil;
    }
}

+ (void) setUpDefaultSymptomDescriptionsInContext:(NSManagedObjectContext *) context
{
    // dictionary for creating body parts and location
    // key is the name of the part
    // object is array @[appendage, leftRight, location] // @[@(appendage), @(leftRight), @(location)];
    
    NSArray *defaultSymptomDescriptions = @[@"Joint Pain", @"Muscle Pain", @"Ache", @"Nausea", @"Sharp Pain", @"Fatigue", @"Stiff Joint(s)"];
    
    
    for (NSString *desc in defaultSymptomDescriptions) {
        [EDSymptomDescription createSymptomDescriptionWithName:desc forContext:context];
    }
}




#pragma mark - Fetching


+ (NSFetchRequest *) fetchAllSymptomDescriptions
{
    NSFetchRequest *fetch = [self fetchObjectsForEntityName:SYMPTOM_DESCRIPTION_ENTITY_NAME];
    
    return fetch;
}




+ (NSFetchRequest *) fetchSymptomDescriptionsForName:(NSString *) name
{
    NSFetchRequest *fetch = [self fetchObjectsForEntityName:SYMPTOM_DESCRIPTION_ENTITY_NAME];
    
    fetch.predicate = [NSPredicate predicateWithFormat:@"name like[cd] %@", name];
    
    return fetch;
}

+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName];
    
    fetch.sortDescriptors = @[[EDEliminatedAPI nameSortDescriptor]];
    
    return fetch;
}



+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                      UniqueID: (NSString *) uniqueID
{
    return [EDEliminatedAPI fetchObjectsForEntityName:entityName UniqueID:uniqueID];
}






#pragma mark - Validation methods

- (BOOL)validateForInsert:(NSError **)error
{
    BOOL propertiesValid = [super validateForInsert:error];
    if (!propertiesValid) {
        
        NSLog(@"%@", [*error localizedDescription]);
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
/// - We need to check whether or not there are overlapping eliminatedObject
- (BOOL)validateConsistency:(NSError **)error
{
    BOOL valid = TRUE;
    
    return valid;
}

/// Other Methods
//---------------------------------------------------------------

- (NSString *) nameFirstLetter
{
    if ([self.name length]) {
        return [self.name substringToIndex:1];
    }
    
    return @"";
    
}

@end
