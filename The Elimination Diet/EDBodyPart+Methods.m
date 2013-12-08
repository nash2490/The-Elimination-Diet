//
//  EDBodyPart+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/21/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDBodyPart+Methods.h"
#import "EDBodyLocation+Methods.h"

#import "EDEliminatedAPI+Fetching.h"
#import "EDEliminatedAPI+Searching.h"
#import "EDEliminatedAPI+Sorting.h"
#import "EDEliminatedAPI+Helpers.h"

#import "EDTag+Methods.h"
#import "EDEliminatedFood+Methods.h"

#import "EDSymptom+Methods.h"
#import "EDHadSymptom+Methods.h"
#import "EDSymptomDescription+Methods.h"

#import "NSError+MHED_MultipleErrors.h"
#import "NSString+MHED_EatDate.h"

@implementation EDBodyPart (Methods)

#pragma mark - Property Creation
// --------------------------------------------------

+ (EDBodyPart *) createBodyPartWithName:(NSString *)name
                             forContext:(NSManagedObjectContext *)context
{
    // we require all of these
    if (!name) {
        return nil;
    }
    
    // Check For Duplicate ------------------
    // check if a meal with the same name already exists
    NSFetchRequest *fetchBodyPart = [self fetchBodyPartsForName:name];
    
    NSError *error;
    NSArray *sameName = [context executeFetchRequest:fetchBodyPart error:&error];
    
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
        
        EDBodyPart *temp = [NSEntityDescription insertNewObjectForEntityForName:BODY_PART_ENTITY_NAME
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




+ (void) setUpDefaultBodyPartsInContext:(NSManagedObjectContext *) context
{
    // dictionary for creating body parts and location
    // key is the name of the part
    // object is array @[appendage, locationHorizontal, location] // @[@(appendage), @(locationHorizontal), @(location)];
    
    NSDictionary *defaultBodyParts = @{
                                       mhedBodyPartGeneral: @[@(EDBodyLocationAppendageEntireBody), @(EDBodyLocationAll), @(-1.0)],
                                       
                                       @"Head": @[@(EDBodyLocationAppendageHeadAndNeck), @(EDBodyLocationAll), @(-1.0)],
                                       @"Neck": @[@(EDBodyLocationAppendageHeadAndNeck ), @(EDBodyLocationAll), @(0.0)],
                                       @"Nose": @[@(EDBodyLocationAppendageHeadAndNeck ), @(EDBodyLocationCenter), @(0.5)],
                                       @"Eyes": @[@(EDBodyLocationAppendageHeadAndNeck ), @(EDBodyLocationCenter), @(0.75)],
                                       @"Ears": @[@(EDBodyLocationAppendageHeadAndNeck ), @(EDBodyLocationCenter), @(0.75)],
                                       @"Mouth": @[@(EDBodyLocationAppendageHeadAndNeck ), @(EDBodyLocationCenter), @(0.25)],
                                       @"Throat": @[@(EDBodyLocationAppendageHeadAndNeck ), @(EDBodyLocationCenter), @(0.1)],
                                       
                                       
                                       @"Foot": @[@(EDBodyLocationAppendageLeg ), @(EDBodyLocationCenter), @(0.0)],
                                       @"Ankle": @[@(EDBodyLocationAppendageLeg ), @(EDBodyLocationCenter), @(0.1)],
                                       @"Shin": @[@(EDBodyLocationAppendageLeg ), @(EDBodyLocationCenter), @(0.25)],
                                       @"Calf": @[@(EDBodyLocationAppendageLeg ), @(EDBodyLocationCenter), @(0.25)],
                                       @"Knee": @[@(EDBodyLocationAppendageLeg ), @(EDBodyLocationCenter), @(0.5)],
                                       @"Thigh": @[@(EDBodyLocationAppendageLeg ), @(EDBodyLocationCenter), @(0.75)],
                                       @"Leg": @[@(EDBodyLocationAppendageLeg ), @(EDBodyLocationCenter), @(-1)],
                                       
                                       
                                       @"Fingers": @[@(EDBodyLocationAppendageArm ), @(EDBodyLocationCenter), @(0.0)],
                                       @"Hand": @[@(EDBodyLocationAppendageArm ), @(EDBodyLocationCenter), @(0.1)],
                                       @"Wrist": @[@(EDBodyLocationAppendageArm ), @(EDBodyLocationCenter), @(0.2)],
                                       @"Elbow": @[@(EDBodyLocationAppendageArm ), @(EDBodyLocationCenter), @(0.5)],
                                       @"Shoulder": @[@(EDBodyLocationAppendageArm ), @(EDBodyLocationCenter), @(1.0)],
                                       @"Arm": @[@(EDBodyLocationAppendageArm ), @(EDBodyLocationCenter), @(-1.0)],
                                       
                                       @"Back": @[@(EDBodyLocationAppendageBack ), @(EDBodyLocationAll), @(-1.0)],
                                       @"Lower Back": @[@(EDBodyLocationAppendageBack ), @(EDBodyLocationCenter), @(0.1)],
                                       @"Mid Back": @[@(EDBodyLocationAppendageBack ), @(EDBodyLocationCenter), @(0.5)],
                                       @"Upper Back": @[@(EDBodyLocationAppendageBack ), @(EDBodyLocationCenter), @(0.9)],
                                       
                                       @"Butt": @[@(EDBodyLocationAppendageBack ), @(EDBodyLocationCenter), @(0.0)],
                                       
                                       @"Stomach": @[@(EDBodyLocationAppendageTorso ), @(EDBodyLocationCenter), @(0.25)],
                                       @"Chest": @[@(EDBodyLocationAppendageTorso ), @(EDBodyLocationCenter), @(0.75)],
                                       @"Lungs": @[@(EDBodyLocationAppendageTorso ), @(EDBodyLocationAll), @(0.75)],
                                       @"Heart": @[@(EDBodyLocationAppendageTorso ), @(EDBodyLocationLeft), @(0.75)],
                                       @"Groin": @[@(EDBodyLocationAppendageTorso ), @(EDBodyLocationCenter), @(0.0)],
                                       
                                       };
    
    
    for (NSString *part in [defaultBodyParts allKeys]) {
        NSArray *loc = defaultBodyParts[part];
        NSNumber *appendage = loc[0];
        NSNumber *leftRight = loc[1];
        NSNumber *locFloat = loc[2];
        
        EDBodyLocation *newLocation = [EDBodyLocation createBodyLocationWithAppendage:[appendage integerValue]
                                                                            leftRight:[leftRight integerValue]
                                                                        locationFloat:[locFloat floatValue]
                                                                           forContext:context];
        
        EDBodyPart *newPart = [EDBodyPart createBodyPartWithName:part forContext:context];
        newPart.bodyLocation = newLocation;
    }
}




#pragma mark - Fetching


+ (NSFetchRequest *) fetchAllBodyParts
{
    NSFetchRequest *fetch = [self fetchObjectsForEntityName:BODY_PART_ENTITY_NAME];
    
    return fetch;
}




+ (NSFetchRequest *) fetchBodyPartsForName:(NSString *) name
{
    NSFetchRequest *fetch = [self fetchObjectsForEntityName:BODY_PART_ENTITY_NAME];
    
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
                                 stringKeyPath: (NSString *) path
                                 equalToString: (NSString *) stringValue
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName stringKeyPath:path equalToString:stringValue];
    
    return fetch;
}

+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                    setKeyPath: (NSString *) path
                                 containsValue: (id) value
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName setKeyPath:path containsValue:value];
    
    return fetch;
}

+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
                                 withSelfInSet:(NSSet *)objects
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName withSelfInSet:objects];
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
