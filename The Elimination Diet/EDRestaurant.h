//
//  EDRestaurant.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/11/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EDFood.h"

@class EDLocation, EDMeal;

@interface EDRestaurant : EDFood

@property (nonatomic, retain) NSSet *locations;
@property (nonatomic, retain) NSSet *meals;
@end

@interface EDRestaurant (CoreDataGeneratedAccessors)

- (void)addLocationsObject:(EDLocation *)value;
- (void)removeLocationsObject:(EDLocation *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

- (void)addMealsObject:(EDMeal *)value;
- (void)removeMealsObject:(EDMeal *)value;
- (void)addMeals:(NSSet *)values;
- (void)removeMeals:(NSSet *)values;

@end
