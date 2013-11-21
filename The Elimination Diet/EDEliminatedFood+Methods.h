//
//  EDEliminatedFood+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/29/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedFood.h"

#define ELIMINATED_FOOD_ENTITY_NAME @"EDEliminatedFood"
@interface EDEliminatedFood (Methods)


#pragma mark - Creation Methods

+ (EDEliminatedFood *) createWithFood:(EDFood *) food
                            startTime:(NSDate *) start
                             stopTime:(NSDate *) stop
                           forContext:(NSManagedObjectContext *) context;





+ (void) setUpDefaultEliminatedFoodsInContext:(NSManagedObjectContext *)context;

#pragma mark -  Fetch Requests -

/// generic fetch that ask for the subentity of EDFood
+ (NSFetchRequest *) fetchAllEliminatedFoodsOfFoodEntity:(NSString *)entityName
                                              ForContext: (NSManagedObjectContext *) context;

/// get all eliminated
+ (NSFetchRequest *) fetchAllEliminatedFoods;

/// get all current eliminated
+ (NSFetchRequest *) fetchAllCurrentEliminatedFoods;

/// get all eliminated type
+ (NSFetchRequest *) fetchAllEliminatedTypesForContext: (NSManagedObjectContext *) context;

/// get all eliminated ingredient
+ (NSFetchRequest *) fetchAllEliminatedIngredientsForContext: (NSManagedObjectContext *) context;

/// get all eliminated meal
+ (NSFetchRequest *) fetchAllEliminatedMealsForContext: (NSManagedObjectContext *) context;

/// get all eliminated restaurant
+ (NSFetchRequest *) fetchAllEliminatedRestaurantsForContext: (NSManagedObjectContext *) context;


#pragma mark - Helper Methods -

/// returns whether today lies between start and stop
- (BOOL) isCurrent;

+ (BOOL) isTime:(NSDate *)time
    betweenPast:(NSDate *)past
      andFuture:(NSDate *)future;

/// gets the interval between self.start and self.stop
- (NSTimeInterval) getTimeInterval;

/// determines if the time interval of the receiver overlaps with that of the input
- (BOOL) overlapWithEliminatedFood:(EDEliminatedFood *) elim;

- (BOOL) overlapWithStart:(NSDate *)start
                     stop:(NSDate *)stop;

- (NSString *) nameFirstLetter;
- (NSDate *) endDateForSorting;
- (NSDate *) startDateForSorting;
- (NSString *) currentForSorting;



@end
