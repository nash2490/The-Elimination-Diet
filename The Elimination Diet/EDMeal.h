//
//  EDMeal.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/11/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EDFood.h"

@class EDEatenMeal, EDIngredient, EDMeal, EDRestaurant, EDType;

@interface EDMeal : EDFood

@property (nonatomic, retain) NSSet *ingredientsAdded;
@property (nonatomic, retain) NSSet *ingredientsSecondary;
@property (nonatomic, retain) NSSet *mealChildren;
@property (nonatomic, retain) NSSet *mealParents;
@property (nonatomic, retain) EDRestaurant *restaurant;
@property (nonatomic, retain) NSSet *timesEaten;
@property (nonatomic, retain) NSSet *types;
@end

@interface EDMeal (CoreDataGeneratedAccessors)

- (void)addIngredientsAddedObject:(EDIngredient *)value;
- (void)removeIngredientsAddedObject:(EDIngredient *)value;
- (void)addIngredientsAdded:(NSSet *)values;
- (void)removeIngredientsAdded:(NSSet *)values;

- (void)addIngredientsSecondaryObject:(EDIngredient *)value;
- (void)removeIngredientsSecondaryObject:(EDIngredient *)value;
- (void)addIngredientsSecondary:(NSSet *)values;
- (void)removeIngredientsSecondary:(NSSet *)values;

- (void)addMealChildrenObject:(EDMeal *)value;
- (void)removeMealChildrenObject:(EDMeal *)value;
- (void)addMealChildren:(NSSet *)values;
- (void)removeMealChildren:(NSSet *)values;

- (void)addMealParentsObject:(EDMeal *)value;
- (void)removeMealParentsObject:(EDMeal *)value;
- (void)addMealParents:(NSSet *)values;
- (void)removeMealParents:(NSSet *)values;

- (void)addTimesEatenObject:(EDEatenMeal *)value;
- (void)removeTimesEatenObject:(EDEatenMeal *)value;
- (void)addTimesEaten:(NSSet *)values;
- (void)removeTimesEaten:(NSSet *)values;

- (void)addTypesObject:(EDType *)value;
- (void)removeTypesObject:(EDType *)value;
- (void)addTypes:(NSSet *)values;
- (void)removeTypes:(NSSet *)values;

@end
