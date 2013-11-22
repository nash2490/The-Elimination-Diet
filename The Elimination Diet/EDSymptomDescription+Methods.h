//
//  EDSymptomDescription+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/21/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDSymptomDescription.h"


#define SYMPTOM_DESCRIPTION_ENTITY_NAME @"EDSymptomDescription"

@interface EDSymptomDescription (Methods)


#pragma mark - Property Creation

+ (EDSymptomDescription *) createSymptomDescriptionWithName:(NSString *)name
                                       forContext:(NSManagedObjectContext *)context;

+ (void) setUpDefaultSymptomDescriptionsInContext:(NSManagedObjectContext *) context;


#pragma mark - Fetching and searching


+ (NSFetchRequest *) fetchAllSymptomDescriptions;
+ (NSFetchRequest *) fetchSymptomDescriptionsForName: (NSString *) name;


/// get all of this entity
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName;


/// get the food objects of entity and for the uniqueID
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                      UniqueID: (NSString *) uniqueID;





#pragma mark - Validation

- (BOOL) validateConsistency:(NSError **) error;


#pragma mark - sorting methods

- (NSString *) nameFirstLetter;
@end
