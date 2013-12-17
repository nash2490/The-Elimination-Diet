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

#import "EDEliminatedAPI.h"


NSString *const mhedFoodDataUpdateNotification = @"mhedFoodDataUpdateNotification";



// Objects Dictionary keys - use to retrieve arrays from objectsDictionary
NSString *const mhedObjectsDictionaryMealsKey = @"Meals List Key";
NSString *const mhedObjectsDictionaryIngredientsKey = @"Ingredients List Key";
NSString *const mhedObjectsDictionaryMedicationKey = @"Medication List Key";
NSString *const mhedObjectsDictionarySymptomsKey = @"Symptom List Key";
NSString *const mhedObjectsDictionaryImagesKey = @"Images List Key";

NSString *const mhedObjectsDictionaryRestaurantKey = @"Restaurant Key";
NSString *const mhedObjectsDictionaryTagsKey = @"Tags Key";

NSString *const mhedObjectsDictionaryDateKey = @"Date Key";

NSString *const mhedObjectsDictionaryNameKey = @"Name Key";



@interface MHEDObjectsDictionary()

@property (nonatomic, strong) NSDictionary *objectsDictionary;

@end


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


- (void) mhedPostFoodDataUpdateNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:mhedFoodDataUpdateNotification
                                                        object:nil];
}


#pragma mark - Data getters and setters

- (EDRestaurant *) restaurant
{
    if ([self.objectsDictionary[mhedObjectsDictionaryRestaurantKey] count]) {
        return self.objectsDictionary[mhedObjectsDictionaryRestaurantKey][0];
    }
    
    return nil;
}

- (void) setNewRestaurant:(NSArray *)restaurant
{
    if (restaurant) {
        NSMutableDictionary *mutObjectDictionary = [self.objectsDictionary mutableCopy];
        mutObjectDictionary[mhedObjectsDictionaryRestaurantKey] = restaurant;
        self.objectsDictionary = [mutObjectDictionary copy];
        [self mhedPostFoodDataUpdateNotification];
    }
}



- (NSArray *) tagsList
{
    return self.objectsDictionary[mhedObjectsDictionaryTagsKey];
}

- (void) setNewTagsList: (NSArray *) newTagsList
{
    
    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
    [mutObjectsDictionary setObject:[newTagsList copy] forKey:mhedObjectsDictionaryTagsKey];
    
    self.objectsDictionary = [mutObjectsDictionary copy];
    [self mhedPostFoodDataUpdateNotification];
}

- (void) addToTagsList: (NSArray *) tags
{

    
    NSArray *oldList = self.objectsDictionary[mhedObjectsDictionaryTagsKey];
    NSArray *newList = [oldList arrayByAddingObjectsFromArray:tags];
    
    [self setNewTagsList:newList];
}

- (void) removeTagsFromTagsList:(NSArray *)tags
{
    NSArray *oldList = self.objectsDictionary[mhedObjectsDictionaryTagsKey];
    NSMutableArray *mutOldList = [oldList mutableCopy];
    [mutOldList removeObjectsInArray:tags];
    
    [self setNewTagsList:mutOldList];
}


- (BOOL) doesTagsListContainTags:(NSArray *)tags
{
    BOOL contains = YES;
    for (EDTag *tag in tags) {
        if ([tag isKindOfClass:[EDTag class]]) {
            contains = (contains && [[self tagsList] containsObject:tag]);
        }
        else {
            contains = NO;
        }
    }
    return contains;
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





- (NSArray *) imagesArray
{
    return self.objectsDictionary[mhedObjectsDictionaryImagesKey];
}

- (void) setNewImagesArray:(NSArray *)images
{
    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
    [mutObjectsDictionary setObject:[images copy] forKey:mhedObjectsDictionaryImagesKey];
    
    self.objectsDictionary = [mutObjectsDictionary copy];
    [self mhedPostFoodDataUpdateNotification];
    
}

- (void) addToImagesArray:(NSArray *)images
{
    NSArray *oldList = [self imagesArray];
    NSArray *newList = [oldList arrayByAddingObjectsFromArray:images];
    
    [self setNewImagesArray:newList];
}

- (void) removeImagesFromImagesArray:(NSArray *)images
{
    NSArray *oldList = [self imagesArray];
    NSMutableArray *mutOldList = [oldList mutableCopy];
    [mutOldList removeObjectsInArray:images];
    
    [self setNewImagesArray:mutOldList];
}

- (void) removeImageAtIndex:(NSUInteger)index
{
    NSArray *oldList = [self imagesArray];
    NSMutableArray *mutOldList = [oldList mutableCopy];
    [mutOldList removeObjectAtIndex:index];
    
    [self setNewImagesArray: mutOldList];
}


- (NSDate *) date
{
    if (!self.objectsDictionary[mhedObjectsDictionaryDateKey]) {
        [self setDate:[NSDate date]];
    }
    
    return self.objectsDictionary[mhedObjectsDictionaryDateKey];
}

- (void) setDate: (NSDate *) date
{
    if (date) {
        NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
        [mutObjectsDictionary setObject:date forKey:mhedObjectsDictionaryDateKey];
        
        self.objectsDictionary = [mutObjectsDictionary copy];
        [self mhedPostFoodDataUpdateNotification];
    }
}



- (NSString *) objectName
{
    if (!self.objectsDictionary[mhedObjectsDictionaryNameKey]) {
        [self setObjectName:@""];
    }
    
    return self.objectsDictionary[mhedObjectsDictionaryNameKey];
}

- (void) setObjectName: (NSString *) objectName
{
    if (objectName) {
        NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
        [mutObjectsDictionary setObject:objectName forKey:mhedObjectsDictionaryNameKey];
        
        self.objectsDictionary = [mutObjectsDictionary copy];
        [self mhedPostFoodDataUpdateNotification];
    }
}



#pragma mark - Key access

- (NSArray *) allKeys
{
    return [self.objectsDictionary allKeys];
}
- (id) objectForKey: (id) key
{
    return [self.objectsDictionary objectForKey:key];
}

#pragma mark - Equality

//- (BOOL) isEqualToObjectsDictionary:(MHEDObjectsDictionary *) objectsDictionary;



#pragma mark - Model Object Creation

- (void) createMealInContext:(NSManagedObjectContext *)managedObjectContext
{
    // if we don't have a context, we get one and call this method again
    if (!managedObjectContext) {
        
        if ([self.mealsList count] + [self.ingredientsList count]) { // we can get context from one of them
            NSManagedObjectContext *mealContext = [[[self.mealsList arrayByAddingObjectsFromArray:self.ingredientsList] lastObject] managedObjectContext];
            [self createMealInContext:mealContext];
        }
        else {
            // need to
            [EDEliminatedAPI performBlockWithContext:^(NSManagedObjectContext *context) {
                if (context) {
                    [self createMealInContext:context];
                }
            }];
        }
    }
    
    
    else if ([self.mealsList count] == 1 && [self.ingredientsList count] == 0)
    {
        // also should check the restaurant
        // but anyways, this means we don't need to create a new meal
        
        [managedObjectContext performBlockAndWait:^{
            [EDEatenMeal createEatenMealWithMeal:self.mealsList[0] atTime:self.date forContext:managedObjectContext];
            
        }];
        
    }
    
    else
    { // we need to create a new new meal first
        
        [managedObjectContext performBlockAndWait:^{
            EDMeal *newMeal = [EDMeal createMealWithName:self.objectName
                                        ingredientsAdded:[NSSet setWithArray:self.ingredientsList]
                                             mealParents:[NSSet setWithArray:self.mealsList]
                                              restaurant:self.restaurant tags:nil
                                              forContext:managedObjectContext];
            
            
            
            if ([self.imagesArray count]) {
                [newMeal addUIImagesToFood:[NSSet setWithArray:self.imagesArray] error:nil];
            }
            
            
            [EDEatenMeal createEatenMealWithMeal:newMeal atTime:self.date forContext:managedObjectContext];
        }];
        
        
        
    }
}

@end
