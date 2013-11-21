//
//  Meal.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/24/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Meal;

@interface Meal : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * kjkj;
@property (nonatomic, retain) NSSet *parent_meals;
@property (nonatomic, retain) NSSet *child_meals;
@end

@interface Meal (CoreDataGeneratedAccessors)

- (void)addParent_mealsObject:(Meal *)value;
- (void)removeParent_mealsObject:(Meal *)value;
- (void)addParent_meals:(NSSet *)values;
- (void)removeParent_meals:(NSSet *)values;

- (void)addChild_mealsObject:(Meal *)value;
- (void)removeChild_mealsObject:(Meal *)value;
- (void)addChild_meals:(NSSet *)values;
- (void)removeChild_meals:(NSSet *)values;

@end
