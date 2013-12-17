//
//  MHEDObjectsDictionary.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/14/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EDRestaurant;


extern NSString *const mhedFoodDataUpdateNotification;


// Objects Dictionary keys - use to retrieve arrays from objectsDictionary
extern NSString *const mhedObjectsDictionaryMealsKey;
extern NSString *const mhedObjectsDictionaryIngredientsKey;
extern NSString *const mhedObjectsDictionaryMedicationKey ;
extern NSString *const mhedObjectsDictionarySymptomsKey ;
extern NSString *const mhedObjectsDictionaryImagesKey;

extern NSString *const mhedObjectsDictionaryRestaurantKey;
extern NSString *const mhedObjectsDictionaryTagsKey;

extern NSString *const mhedObjectsDictionaryDateKey;

extern NSString *const mhedObjectsDictionaryNameKey;

extern NSString *const mhedObjectsDictionaryCoreDataObject;

extern NSString *const mhedObjectsDictionaryFavoriteKey;

@interface MHEDObjectsDictionary : NSObject





/// Designated Initializer
- (instancetype) initWithDefaults;

- (instancetype) initWithDataFromObject:(id) dataObject;

#pragma mark - Data getters and setters

- (id) coreDataObject;
- (void) setCoreDataObject: (id) object;

- (EDRestaurant *) restaurant;
- (void) setRestaurant: (NSArray *) restaurant;

- (BOOL) isFavorite;
- (void) setIsFavorite: (BOOL) favorite;

- (NSArray *) tagsList;
- (void) setTagsList: (NSArray *) newTagsList;
- (void) addToTagsList: (NSArray *) tags;
- (void) removeTagsFromTagsList: (NSArray *) tags;
- (BOOL) doesTagsListContainTags:(NSArray *) tags;

- (NSArray *) mealsList;
- (void) setMealsList: (NSArray *) newMealsList;
- (void) addToMealsList: (NSArray *) meals;
- (void) removeMealsFromMealsList: (NSArray *) meals;
- (BOOL) doesMealsListContainMeals:(NSArray *) meals;

- (NSArray *) ingredientsList;
- (void) setIngredientsList: (NSArray *) newIngredientsList;
- (void) addToIngredientsList: (NSArray *) ingredients;
- (void) removeIngredientsFromIngredientsList: (NSArray *) ingredients;
- (BOOL) doesIngredientsListContainIngredients:(NSArray *) ingredients;

- (NSArray *) medicationsList;
- (void) setMedicationsList: (NSArray *) newMedicationsList;
- (void) addToMedicationsList: (NSArray *) medications;
- (void) removeMedicationsFromMedicationsList: (NSArray *) medications;
- (BOOL) doesMedicationsListContainMedications:(NSArray *) medications;

- (NSArray *) imagesArray;
- (void) setImagesArray: (NSArray *) images;
- (void) addToImagesArray: (NSArray *) images;
- (void) removeImagesFromImagesArray: (NSArray *) images;
- (void) removeImageAtIndex: (NSUInteger) index;


- (NSDate *) date;
- (void) setDate: (NSDate *) date;


- (NSString *) objectName;
- (void) setObjectName: (NSString *) objectName;

// symptoms???




#pragma mark - Key access

- (NSArray *) allKeys;
- (id) objectForKey: (id) key;

#pragma mark - Equality

//- (BOOL) isEqualToObjectsDictionary:(MHEDObjectsDictionary *) objectsDictionary;

#pragma mark - Model Object Creation

- (void) saveChangesToObject;

- (void) createMealInContext: (NSManagedObjectContext *) managedObjectContext;

@end





@protocol MHEDObjectsDictionaryProtocol <NSObject>

- (MHEDObjectsDictionary *) objectsDictionary;

@end

