//
//  EDBodyLocation+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/22/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDBodyLocation+Methods.h"

#import "EDEliminatedAPI+Fetching.h"
#import "EDEliminatedAPI+Searching.h"
#import "EDEliminatedAPI+Sorting.h"
#import "EDEliminatedAPI+Helpers.h"

#import "EDTag+Methods.h"
#import "EDEliminatedFood+Methods.h"

#import "EDBodyPart+Methods.h"
#import "EDSymptom+Methods.h"
#import "EDHadSymptom+Methods.h"
#import "EDSymptomDescription+Methods.h"

#import "NSError+MultipleErrors.h"
#import "NSString+EatDate.h"

@implementation EDBodyLocation (Methods)


#pragma mark - Property Creation
// --------------------------------------------------

+ (EDBodyLocation *) createBodyLocationWithAppendage:(EDBodyLocationAppendageName)appendage
                                           leftRight:(EDBodyLocationHorizontal)leftRight
                                       locationFloat:(float)locationFloat
                                          forContext:(NSManagedObjectContext *)context
{

    
    // Check For Duplicate ------------------
    // check if a meal with the same name already exists
    NSFetchRequest *fetch = [self fetchBodyLocationsForAppendage:appendage];
    
    NSError *error;
    NSArray *sameAppendage = [context executeFetchRequest:fetch error:&error];
    
    // unique will be used to determine if another object exists with the same
    //      - name
    //      - added ingredients
    //      - parents
    //      - restaurant
    
    BOOL unique = TRUE;
    
    
    for (EDBodyLocation *bodyLoc in sameAppendage) {
        if ([bodyLoc.leftRight isEqual: @(leftRight)] &&
            [bodyLoc.location isEqual:@(locationFloat)])
        {
            unique = FALSE;
            return bodyLoc;
        }
    }
    
    
    
    // if this meal is unique, then create it
    if (unique) {
        
        EDBodyLocation *temp = [NSEntityDescription insertNewObjectForEntityForName:BODY_LOCATION_ENTITY_NAME
                                                         inManagedObjectContext:context];
        
        // set object properties to obvious or empty;
        temp.appendage = @(appendage);
        temp.uniqueID = [EDEliminatedAPI createUniqueID];
        temp.leftRight = @(leftRight);
        temp.location = @(locationFloat);
        
        
        return temp;
    }
    
    else {
        return nil;
    }
}




#pragma mark - Fetching


+ (NSFetchRequest *) fetchAllBodyLocations
{
    NSFetchRequest *fetch = [self fetchObjectsForEntityName:BODY_LOCATION_ENTITY_NAME];
    
    return fetch;
}




+ (NSFetchRequest *) fetchBodyLocationsForAppendage:(EDBodyLocationAppendageName) appendage
{
    NSFetchRequest *fetch = [self fetchObjectsForEntityName:BODY_LOCATION_ENTITY_NAME];
    
    fetch.predicate = [NSPredicate predicateWithFormat:@"appendage == %@", @(appendage)];
    
    return fetch;
}

+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName];
    
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"appendage" ascending:YES]];
    
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


@end
