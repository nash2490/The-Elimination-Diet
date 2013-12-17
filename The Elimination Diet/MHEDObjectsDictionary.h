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



@interface MHEDObjectsDictionary : NSObject






- (instancetype) initWithDefaults;



#pragma mark - Data getters and setters
- (EDRestaurant *) restaurant;
- (void) setNewRestaurant: (NSArray *) restaurant;

- (NSArray *) tagsList;
- (void) setNewTagsList: (NSArray *) newTagsList;
- (void) addToTagsList: (NSArray *) tags;
- (void) removeTagsFromTagsList: (NSArray *) tags;
- (BOOL) doesTagsListContainTags:(NSArray *) tags;

- (NSArray *) mealsList;
- (void) setNewMealsList: (NSArray *) newMealsList;
- (void) addToMealsList: (NSArray *) meals;
- (void) removeMealsFromMealsList: (NSArray *) meals;
- (BOOL) doesMealsListContainMeals:(NSArray *) meals;

- (NSArray *) ingredientsList;
- (void) setNewIngredientsList: (NSArray *) newIngredientsList;
- (void) addToIngredientsList: (NSArray *) ingredients;
- (void) removeIngredientsFromIngredientsList: (NSArray *) ingredients;
- (BOOL) doesIngredientsListContainIngredients:(NSArray *) ingredients;

- (NSArray *) medicationsList;
- (void) setNewMedicationsList: (NSArray *) newMedicationsList;
- (void) addToMedicationsList: (NSArray *) medications;
- (void) removeMedicationsFromMedicationsList: (NSArray *) medications;
- (BOOL) doesMedicationsListContainMedications:(NSArray *) medications;

- (NSArray *) imagesArray;
- (void) setNewImagesArray: (NSArray *) images;
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

- (void) createMealInContext: (NSManagedObjectContext *) managedObjectContext;

@end





@protocol MHEDObjectsDictionaryProtocol <NSObject>

- (MHEDObjectsDictionary *) objectsDictionary;

@end

