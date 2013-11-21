//
//  EDTag.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/12/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EDIngredient, EDMeal, EDRestaurant, EDType;

@interface EDTag : NSManagedObject 

@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSSet *mealsWithTag;
@property (nonatomic, retain) NSSet *ingredientsWithTag;
@property (nonatomic, retain) NSSet *typesWithTag;
@property (nonatomic, retain) NSSet *restaurantsWithTag;
@end

@interface EDTag (CoreDataGeneratedAccessors)

- (void)addMealsWithTagObject:(EDMeal *)value;
- (void)removeMealsWithTagObject:(EDMeal *)value;
- (void)addMealsWithTag:(NSSet *)values;
- (void)removeMealsWithTag:(NSSet *)values;

- (void)addIngredientsWithTagObject:(EDIngredient *)value;
- (void)removeIngredientsWithTagObject:(EDIngredient *)value;
- (void)addIngredientsWithTag:(NSSet *)values;
- (void)removeIngredientsWithTag:(NSSet *)values;

- (void)addTypesWithTagObject:(EDType *)value;
- (void)removeTypesWithTagObject:(EDType *)value;
- (void)addTypesWithTag:(NSSet *)values;
- (void)removeTypesWithTag:(NSSet *)values;

- (void)addRestaurantsWithTagObject:(EDRestaurant *)value;
- (void)removeRestaurantsWithTagObject:(EDRestaurant *)value;
- (void)addRestaurantsWithTag:(NSSet *)values;
- (void)removeRestaurantsWithTag:(NSSet *)values;

@end
