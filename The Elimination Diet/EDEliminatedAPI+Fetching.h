//
//  EDEliminatedAPI+Fetching.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/25/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedAPI.h"

@interface EDEliminatedAPI (Fetching)

#pragma mark - Fetching and searching

+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName withSortDescriptors: (NSArray *) sortDescriptors;


+ (NSFetchRequest *) fetchObjectsSortedByNameForEntityName: (NSString *) entityName;


/// get all of this entity and sort by @property name
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName;

/// get the objects of entity, with a string value for keyPath that equals (case insensitive) the 'string' parameter
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                 stringKeyPath: (NSString *) path
                                 equalToString: (NSString *) stringValue;


/// get the objects of entity, with a set for keyPath that contains the 'value' parameter
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                    setKeyPath: (NSString *) path
                                 containsValue: (id) value;

/// get the objects of entity that are in set
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
                                 withSelfInSet:(NSSet *) objects;

/// get the objects of entity and for the name
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                      withName: (NSString *) name;

/// get the objects of entity and have a name from Names
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
                                     withNames:(NSArray *) names;

/// get the objects of entity and for the uniqueID
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                      UniqueID: (NSString *) uniqueID;


#pragma mark - Favorites

/// fetch objects of entity that have self.favorite == YES
+ (NSFetchRequest *) fetchFavoriteObjectsForEntityName:(NSString *)entityName;

#pragma mark - Predicates

/// predicate for favorite in a food
+ (NSPredicate *) favoritePredicate;


@end
