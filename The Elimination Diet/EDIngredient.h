//
//  EDIngredient.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/23/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EDFood.h"

@class EDIngredient, EDMeal, EDMedication, EDType;

@interface EDIngredient : EDFood

@property (nonatomic, retain) NSSet *ingredientChildren;
@property (nonatomic, retain) NSSet *ingredientParents;
@property (nonatomic, retain) NSSet *mealsPrimary;
@property (nonatomic, retain) NSSet *mealsSecondary;
@property (nonatomic, retain) NSSet *typesPrimary;
@property (nonatomic, retain) NSSet *typesSecondary;
@property (nonatomic, retain) NSSet *medicationPrimary;
@end

@interface EDIngredient (CoreDataGeneratedAccessors)

- (void)addIngredientChildrenObject:(EDIngredient *)value;
- (void)removeIngredientChildrenObject:(EDIngredient *)value;
- (void)addIngredientChildren:(NSSet *)values;
- (void)removeIngredientChildren:(NSSet *)values;

- (void)addIngredientParentsObject:(EDIngredient *)value;
- (void)removeIngredientParentsObject:(EDIngredient *)value;
- (void)addIngredientParents:(NSSet *)values;
- (void)removeIngredientParents:(NSSet *)values;

- (void)addMealsPrimaryObject:(EDMeal *)value;
- (void)removeMealsPrimaryObject:(EDMeal *)value;
- (void)addMealsPrimary:(NSSet *)values;
- (void)removeMealsPrimary:(NSSet *)values;

- (void)addMealsSecondaryObject:(EDMeal *)value;
- (void)removeMealsSecondaryObject:(EDMeal *)value;
- (void)addMealsSecondary:(NSSet *)values;
- (void)removeMealsSecondary:(NSSet *)values;

- (void)addTypesPrimaryObject:(EDType *)value;
- (void)removeTypesPrimaryObject:(EDType *)value;
- (void)addTypesPrimary:(NSSet *)values;
- (void)removeTypesPrimary:(NSSet *)values;

- (void)addTypesSecondaryObject:(EDType *)value;
- (void)removeTypesSecondaryObject:(EDType *)value;
- (void)addTypesSecondary:(NSSet *)values;
- (void)removeTypesSecondary:(NSSet *)values;

- (void)addMedicationPrimaryObject:(EDMedication *)value;
- (void)removeMedicationPrimaryObject:(EDMedication *)value;
- (void)addMedicationPrimary:(NSSet *)values;
- (void)removeMedicationPrimary:(NSSet *)values;

@end
