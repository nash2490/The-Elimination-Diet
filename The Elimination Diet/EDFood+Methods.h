//
//  EDFood+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/28/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDFood.h"


#define FOOD_ENTITY_NAME @"EDFood"

typedef NS_ENUM(NSUInteger, FoodSortType) {ByName, ByIngredients, ByTypes, ByFavorite, ByTags, ByRestaurant, ByRecent, ByUniqueID, ByParentFood};
typedef NS_ENUM(NSUInteger, FoodTypeForTable) {MealFoodType, IngredientFoodType, MedicationFoodType};

@class EDTag;





@interface EDFood (Methods)

#pragma mark - Property Creation

/// creates a unique id for the food object
-(NSString *) createUniqueID;


#pragma mark - Images

/// saves the given images as EDImage objects and sets as the images of the food
- (void) addUIImagesToFood:(NSSet *) images error: (NSError **) error;

#pragma mark - Elimination Methods

/// determines if the type is currently on the elimination list
- (BOOL) isCurrentlyEliminated;

/// returns the date when type will be added back to non-eliminated
- (NSDate *) whenNotEliminated;




#pragma mark - Fetching and searching


/// get all of this entity
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName;

/// get the food objects of entity, with a string value for keyPath that equals (case insensitive) the 'string' parameter
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                 stringKeyPath: (NSString *) path
                                 equalToString: (NSString *) stringValue;


/// get the food objects of entity, with a set for keyPath that contains the 'value' parameter
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                    setKeyPath: (NSString *) path
                                 containsValue: (id) value;

/// get the food objects of entity that are in set
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
                                 withSelfInSet:(NSSet *) objects;

/// get the food objects of entity and for the name
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                  withFoodName: (NSString *) foodName;

/// get the food objects of entity and have a name from foodNames
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
                                 withfoodNames:(NSArray *) foodNames;

/// get the food objects of entity and for the uniqueID
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                      UniqueID: (NSString *) uniqueID;

#pragma mark - Tag And Favorite Fetching -
/// get the food objects of entity and for the tags
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                          Tags: (NSSet *) tags;


/// fetch objects of entity that have self.favorite == YES
+ (NSFetchRequest *) fetchFavoriteObjectsForEntityName:(NSString *)entityName;

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

#pragma mark - Tags and Favorites

/// is favorite/favorite
- (BOOL) isFavorite;

/// is beverage - can't do just yet

/// tags as string
- (NSString *) tagsAsString;

//


#pragma mark - Validation

- (BOOL) validateConsistency:(NSError **) error;


#pragma mark - sorting methods

- (NSString *) nameFirstLetter;

@end
