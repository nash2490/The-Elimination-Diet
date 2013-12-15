//
//  MHEDObjectsDictionary.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/14/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDObjectsDictionary.h"

#import "EDTag+Methods.h"
#import "EDRestaurant+Methods.h"
#import "EDFood+Methods.h"
#import "EDMeal+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDEatenMeal+Methods.h"
#import "EDMedication+Methods.h"
#import "EDTakenMedication+Methods.h"
#import "EDImage+Methods.h"



NSString *const mhedFoodDataUpdateNotification = @"mhedFoodDataUpdateNotification";



// Objects Dictionary keys - use to retrieve arrays from objectsDictionary
static NSString *mhedObjectsDictionaryMealsKey = @"Meals List Key";
static NSString *mhedObjectsDictionaryIngredientsKey = @"Ingredients List Key";
static NSString *mhedObjectsDictionaryMedicationKey = @"Medication List Key";
static NSString *mhedObjectsDictionarySymptomsKey = @"Symptom List Key";
static NSString *mhedObjectsDictionaryImagesKey = @"Images List Key";

static NSString *mhedObjectsDictionaryRestaurantKey = @"Restaurant Key";
static NSString *mhedObjectsDictionaryTagsKey = @"Tags Key";



@implementation MHEDObjectsDictionary

- (instancetype) initWithDefaults
{
    self = [self init];
    
    self.objectsDictionary = @{mhedObjectsDictionaryMealsKey : @[],
                               mhedObjectsDictionaryIngredientsKey : @[],
                               mhedObjectsDictionaryMedicationKey : @[],
                               mhedObjectsDictionaryImagesKey : @[],
                               mhedObjectsDictionaryRestaurantKey : @[],
                               mhedObjectsDictionarySymptomsKey : @[],
                               mhedObjectsDictionaryTagsKey : @[]};
    
    return self;
}

- (NSDictionary *) objectsDictionary
{
    if (!_objectsDictionary) {
        _objectsDictionary = @{mhedObjectsDictionaryMealsKey : @[],
                               mhedObjectsDictionaryIngredientsKey : @[],
                               mhedObjectsDictionaryMedicationKey : @[],
                               mhedObjectsDictionaryImagesKey : @[],
                               mhedObjectsDictionaryRestaurantKey : @[],
                               mhedObjectsDictionarySymptomsKey : @[],
                               mhedObjectsDictionaryTagsKey : @[]};
    }
    return _objectsDictionary;
}

- (EDRestaurant *) restaurant
{
    return self.objectsDictionary[mhedObjectsDictionaryRestaurantKey];
}

- (void) setNewRestaurant:(EDRestaurant *)restaurant
{
    if (restaurant && [restaurant isKindOfClass:[EDRestaurant class]]) {
        NSMutableDictionary *mutObjectDictionary = [self.objectsDictionary mutableCopy];
        mutObjectDictionary[mhedObjectsDictionaryRestaurantKey] = restaurant;
        self.objectsDictionary = [mutObjectDictionary copy];
        [
    }
}

- (NSArray *) tagsList
{
    if (!_tagsList) {
        _tagsList = [[NSArray alloc] init];
    }
    return _tagsList;
}

- (void) addToTagsList: (NSArray *) tags
{
    if (tags) {
        self.tagsList = [self.tagsList arrayByAddingObjectsFromArray:tags];
    }
}

- (void) setNewTagsList: (NSArray *) newTagsList
{
    if (newTagsList) {
        self.tagsList = newTagsList;
    }
}


- (NSArray *) mealsList
{
    return self.objectsDictionary[mhedObjectsDictionaryMealsKey];
    
}

- (void) setNewMealsList: (NSArray *) newMealsList
{
    
    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
    [mutObjectsDictionary setObject:[newMealsList copy] forKey:mhedObjectsDictionaryMealsKey];
    
    self.objectsDictionary = [mutObjectsDictionary copy];
    [self mhedPostFoodDataUpdateNotification];
}

- (void) addToMealsList: (NSArray *) meals
{
    //    if (meals) {
    //        self.mealsList = [self.mealsList arrayByAddingObjectsFromArray:meals];
    //        for (EDTag *tag in [meals[0] tags]) {
    //            NSLog(@"tag name = %@", tag.name);
    //        }
    //    }
    
    
    NSArray *oldList = self.objectsDictionary[mhedObjectsDictionaryMealsKey];
    NSArray *newList = [oldList arrayByAddingObjectsFromArray:meals];
    
    [self setNewMealsList:newList];
}

- (void) removeMealsFromMealsList: (NSArray *) meals
{
    NSArray *oldList = self.objectsDictionary[mhedObjectsDictionaryMealsKey];
    NSMutableArray *mutOldList = [oldList mutableCopy];
    [mutOldList removeObjectsInArray:meals];
    
    [self setNewMealsList:mutOldList];
}


- (BOOL) doesMealsListContainMeals:(NSArray *) meals
{
    BOOL contains = YES;
    for (EDMeal *meal in meals) {
        if ([meal isKindOfClass:[EDMeal class]]) {
            contains = (contains && [[self mealsList] containsObject:meal]);
        }
        else {
            contains = NO;
        }
    }
    return contains;
}



- (NSArray *) ingredientsList
{
    //    if (!_ingredientsList) {
    //        _ingredientsList = [[NSArray alloc] init];
    //    }
    //    return _ingredientsList;
    
    return self.objectsDictionary[mhedObjectsDictionaryIngredientsKey];
}




- (void) setNewIngredientsList: (NSArray *) newIngredientsList
{
    //    if (newIngredientsList) {
    //        self.ingredientsList = newIngredientsList;
    //    }
    
    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
    [mutObjectsDictionary setObject:[newIngredientsList copy] forKey:mhedObjectsDictionaryIngredientsKey];
    
    self.objectsDictionary = [mutObjectsDictionary copy];
    [self mhedPostFoodDataUpdateNotification];
}




- (void) addToIngredientsList: (NSArray *) ingredients
{
    //    if (ingredients) {
    //        self.ingredientsList = [self.ingredientsList arrayByAddingObjectsFromArray:ingredients];
    //    }
    
    NSArray *oldList = [self ingredientsList];
    NSArray *newList = [oldList arrayByAddingObjectsFromArray:ingredients];
    
    [self setNewIngredientsList:newList];
}


- (void) removeIngredientsFromIngredientsList:(NSArray *)ingredients
{
    NSArray *oldList = [self ingredientsList];
    NSMutableArray *mutOldList = [oldList mutableCopy];
    [mutOldList removeObjectsInArray:ingredients];
    
    [self setNewIngredientsList:mutOldList];
}


- (BOOL) doesIngredientsListContainIngredients:(NSArray *)ingredients
{
    BOOL contains = YES;
    for (EDIngredient *ingr in ingredients) {
        if ([ingr isKindOfClass:[EDIngredient class]]) {
            contains = (contains && [[self ingredientsList] containsObject:ingr]);
        }
        else {
            contains = NO;
        }
    }
    return contains;
}



- (NSArray *) medicationsList
{
    return self.objectsDictionary[mhedObjectsDictionaryMedicationKey];
}

- (void) setNewMedicationsList: (NSArray *) newMedicationsList
{
    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
    [mutObjectsDictionary setObject:[newMedicationsList copy] forKey:mhedObjectsDictionaryMedicationKey];
    
    self.objectsDictionary = [mutObjectsDictionary copy];
    [self mhedPostFoodDataUpdateNotification];
    
}

- (void) addToMedicationsList: (NSArray *) medications
{
    NSArray *oldList = [self medicationsList];
    NSArray *newList = [oldList arrayByAddingObjectsFromArray:medications];
    
    [self setNewMedicationsList:newList];
}

- (void) removeMedicationsFromMedicationsList:(NSArray *)medications
{
    NSArray *oldList = [self medicationsList];
    NSMutableArray *mutOldList = [oldList mutableCopy];
    [mutOldList removeObjectsInArray:medications];
    
    [self setNewMedicationsList:mutOldList];
}

- (BOOL) doesMedicationsListContainMedications:(NSArray *)medications
{
    BOOL contains = YES;
    for (EDMedication *medication in medications) {
        if ([medication isKindOfClass:[EDMedication class]]) {
            contains = (contains && [[self medicationsList] containsObject:medication]);
        }
        else {
            contains = NO;
        }
    }
    return contains;
}



- (void) mhedPostFoodDataUpdateNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:mhedFoodDataUpdateNotification
                                                        object:nil];
}





@end
