//
//  EDSymptom+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDSymptom+Methods.h"

#import "EDEliminatedAPI+Fetching.h"
#import "EDEliminatedAPI+Searching.h"
#import "EDEliminatedAPI+Sorting.h"
#import "EDEliminatedAPI+Helpers.h"

#import "EDTag+Methods.h"
#import "EDEliminatedFood+Methods.h"

#import "EDBodyPart+Methods.h"
#import "EDHadSymptom+Methods.h"
#import "EDSymptomDescription+Methods.h"

#import "NSError+MHED_MultipleErrors.h"
#import "NSString+MHED_EatDate.h"

@implementation EDSymptom (Methods)

#pragma mark - Property Creation
// --------------------------------------------------

+ (EDSymptom *) createSymptomWithName:(NSString *)name
                             favorite:(BOOL) isFavorite
                             bodyPart:(EDBodyPart *) bodyPart
                   symptomDescription:(EDSymptomDescription *) symptomDescription
                                 tags:(NSSet *)tags
                           forContext:(NSManagedObjectContext *)context
{
    // we require all of these
    if (!bodyPart || !name) {
        return nil;
    }
    
    // Check For Duplicate ------------------
    // check if a meal with the same name already exists
    NSFetchRequest *fetchSymptom = [self fetchSymptomsForName:name];
    
    NSError *error;
    NSArray *sameName = [context executeFetchRequest:fetchSymptom error:&error];
    
    // unique will be used to determine if another object exists with the same
    //      - name
    //      - added ingredients
    //      - parents
    //      - restaurant
    
    BOOL unique = TRUE;
    
    EDSymptom *dupSymptom;
    
    if ([sameName count]) {
        for (int i = 0; i< [sameName count]; i++) {
            dupSymptom = sameName[i];
            
            // body parts must be different for uniqueness
            unique = ![bodyPart isEqual:dupSymptom.bodyPart];

            // symptoms must be different for uniqueness
            if (symptomDescription) {
                unique = ![symptomDescription isEqual:dupSymptom.symptomDescription];
            }
            else { // if symptomDescription are both nil then not unique
                unique = !(dupSymptom.symptomDescription == nil);
            }
            
            
            
            if (!unique) {
                
                // error - meal already exists
                
                // end the for loop
                i = [sameName count];
            }
        }
    }
    
    

    // if this meal is unique, then create it
    if (unique) {
        
        EDSymptom *temp = [NSEntityDescription insertNewObjectForEntityForName:SYMPTOM_ENTITY_NAME
                                                        inManagedObjectContext:context];
        
        // set object properties to obvious or empty;
        temp.name = name;
        temp.uniqueID = [EDEliminatedAPI createUniqueID];
        temp.favorite = @(isFavorite);
        temp.bodyPart = bodyPart;
        temp.symptomDescription = symptomDescription;
        temp.timesHad = [[NSSet alloc] init];
        temp.tags = [[NSSet alloc] init];
        
        //[temp determineAllTransientProperties];
        
        if (tags) { // if there are tags then set them
            temp.tags = tags;
        }
        
        return temp;
    }
    
    else { // the meal already exists, so we should just return it
        return dupSymptom;
    }
}

+ (void) setUpDefaultSymptomsInContext:(NSManagedObjectContext *) context
{
    [EDBodyPart setUpDefaultBodyPartsInContext:context];
    [EDSymptomDescription setUpDefaultSymptomDescriptionsInContext:context];
    
    EDSymptomDescription *ache = [EDSymptomDescription createSymptomDescriptionWithName:@"Ache" forContext:context];
    EDSymptomDescription *nausea = [EDSymptomDescription createSymptomDescriptionWithName:@"Nausea" forContext:context];
    EDSymptomDescription *musclePain = [EDSymptomDescription createSymptomDescriptionWithName:@"Muscle Pain" forContext:context];
    EDSymptomDescription *jointPain = [EDSymptomDescription createSymptomDescriptionWithName:@"Joint Pain" forContext:context];
    EDSymptomDescription *fatigue = [EDSymptomDescription createSymptomDescriptionWithName:@"Fatigue" forContext:context];
    EDSymptomDescription *cramp = [EDSymptomDescription createSymptomDescriptionWithName:@"Cramp" forContext:context];
    EDSymptomDescription *sharpPain = [EDSymptomDescription createSymptomDescriptionWithName:@"Sharp Pain" forContext:context];
    EDSymptomDescription *stiffJoint = [EDSymptomDescription createSymptomDescriptionWithName:@"Stiff Joint(s)" forContext:context];


    
    // Headache
    EDBodyPart *head = [EDBodyPart createBodyPartWithName:mhedBodyPartHead forContext:context];
    [EDSymptom createSymptomWithName:@"Headache" favorite:NO bodyPart:head symptomDescription:ache tags:nil forContext:context];
    
    // Stomach ache
    EDBodyPart *stomach = [EDBodyPart createBodyPartWithName:mhedBodyPartTorsoStomach forContext:context];
    [EDSymptom createSymptomWithName:@"Stomachache" favorite:NO bodyPart:stomach symptomDescription:ache tags:nil forContext:context];
    
    // General Fatigue
    EDBodyPart *general = [EDBodyPart createBodyPartWithName:mhedBodyPartGeneral forContext:context];
    [EDSymptom createSymptomWithName:@"General Fatigue" favorite:NO bodyPart:general symptomDescription:fatigue tags:nil forContext:context];
    
    // Nausea
    [EDSymptom createSymptomWithName:@"Nausea" favorite:NO bodyPart:stomach symptomDescription:nausea tags:nil forContext:context];
    
    // Back Pain (muscle)
    EDBodyPart *back = [EDBodyPart createBodyPartWithName:mhedBodyPartBack forContext:context];
    [EDSymptom createSymptomWithName:@"Back Pain (muscle)" favorite:NO bodyPart:back symptomDescription:musclePain tags:nil forContext:context];
    
    // Back Pain (sharp)
    [EDSymptom createSymptomWithName:@"Back Pain (sharp)" favorite:NO bodyPart:back symptomDescription:sharpPain tags:nil forContext:context];
    
    
    // Leg Pain
    EDBodyPart *leg = [EDBodyPart createBodyPartWithName:mhedBodyPartLeg forContext:context];
    [EDSymptom createSymptomWithName:@"Leg Pain (muscle)" favorite:NO bodyPart:leg symptomDescription:musclePain tags:nil forContext:context];
    
    // Knee Joint Pain
    EDBodyPart *knee = [EDBodyPart createBodyPartWithName:mhedBodyPartLegKnee forContext:context];
    [EDSymptom createSymptomWithName:@"Knee Joint Pain" favorite:NO bodyPart:knee symptomDescription:jointPain tags:nil forContext:context];
    
    // Leg Cramp
    [EDSymptom createSymptomWithName:@"Leg Cramp" favorite:NO bodyPart:leg symptomDescription:cramp tags:nil forContext:context];
    
    // Hand Cramp
    EDBodyPart *hand = [EDBodyPart createBodyPartWithName:mhedBodyPartArmHand forContext:context];
    [EDSymptom createSymptomWithName:@"Hand Cramp" favorite:NO bodyPart:hand symptomDescription:cramp tags:nil forContext:context];
    
    // Hand Stiff Joints
    [EDSymptom createSymptomWithName:@"Hand Stiff Joints" favorite:NO bodyPart:hand symptomDescription:stiffJoint tags:nil forContext:context];
    
}




#pragma mark - Fetching


+ (NSFetchRequest *) fetchAllSymptoms
{
    NSFetchRequest *fetch = [self fetchObjectsForEntityName:SYMPTOM_ENTITY_NAME];
    
    return fetch;
}


+ (NSFetchRequest *) fetchFavoriteSymptoms
{
    NSFetchRequest *fetch = [self fetchFavoriteObjectsForEntityName:SYMPTOM_ENTITY_NAME];
    
    return fetch;
}


+ (NSFetchRequest *) fetchSymptomsForName:(NSString *) name
{
    NSFetchRequest *fetch = [self fetchObjectsForEntityName:SYMPTOM_ENTITY_NAME];
    
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
                                  withFoodName:(NSString *)foodName
{
    return [EDEliminatedAPI fetchObjectsForEntityName:entityName withName:foodName];
}


+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
                                 withfoodNames:(NSArray *) foodNames
{
    
    //NSExpression *rhs = [NSExpression expressionWithFormat:@"name"];
    //NSExpression *lhs = [NSExpression expressionWithFormat:@"%@", foodNames];
    
    //NSPredicate *pred = [NSComparisonPredicate predicateWithLeftExpression:lhs rightExpression:rhs modifier:NSAnyPredicateModifier type:NSLikePredicateOperatorType options:NSCaseInsensitivePredicateOption];
    
    
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName withNames:foodNames];
    
    return fetch;
}


+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                      UniqueID: (NSString *) uniqueID
{
    return [EDEliminatedAPI fetchObjectsForEntityName:entityName UniqueID:uniqueID];
}


#pragma mark - Tag And Favorite Fetching -

+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                          Tags: (NSSet *) tags
{
    return [EDTag fetchObjectsForEntityName:entityName withTags:tags];
}

+ (NSFetchRequest *) fetchFavoriteObjectsForEntityName:(NSString *)entityName
{
    return [EDEliminatedAPI fetchFavoriteObjectsForEntityName:entityName];
}


#pragma mark - Searching -

//---------
// search through name and tags
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName forSearchString:(NSString *)text
{
    
    
    return [EDEliminatedAPI fetchObjectsForEntityName:entityName forSearchString:text];
}



// only searches through the names
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName nameContainingText:(NSString *)text
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName nameContainingText:text];
    
    fetch.sortDescriptors = @[[EDEliminatedAPI nameSortDescriptor]];
    
    return fetch;
}

#pragma mark - Tags and Favorites
//- (BOOL) isFavorite
//{
//    EDTag *starTag = [EDTag getFavoriteTagInContext:self.managedObjectContext];
//    if ([self.tags containsObject:starTag]) {
//        return TRUE;
//    }
//    return FALSE;
//}

- (BOOL) isFavorite
{
    return [self.favorite boolValue];
}

- (NSString *) tagsAsString
{
    return [EDTag convertIntoString:self.tags];
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
