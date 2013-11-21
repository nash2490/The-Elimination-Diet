//
//  EDType.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/11/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EDFood.h"

@class EDIngredient, EDMeal;

@interface EDType : EDFood

@property (nonatomic, retain) NSSet *ingredientsPrimary;
@property (nonatomic, retain) NSSet *ingredientsSecondary;
@property (nonatomic, retain) NSSet *meals;
@end

@interface EDType (CoreDataGeneratedAccessors)

- (void)addIngredientsPrimaryObject:(EDIngredient *)value;
- (void)removeIngredientsPrimaryObject:(EDIngredient *)value;
- (void)addIngredientsPrimary:(NSSet *)values;
- (void)removeIngredientsPrimary:(NSSet *)values;

- (void)addIngredientsSecondaryObject:(EDIngredient *)value;
- (void)removeIngredientsSecondaryObject:(EDIngredient *)value;
- (void)addIngredientsSecondary:(NSSet *)values;
- (void)removeIngredientsSecondary:(NSSet *)values;

- (void)addMealsObject:(EDMeal *)value;
- (void)removeMealsObject:(EDMeal *)value;
- (void)addMeals:(NSSet *)values;
- (void)removeMeals:(NSSet *)values;

@end
