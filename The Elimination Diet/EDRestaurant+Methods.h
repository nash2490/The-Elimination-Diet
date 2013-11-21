//
//  EDRestaurant+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/28/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDRestaurant.h"

@class CLRegion, CLLocation;

#define RESTAURANT_ENTITY_NAME @"EDRestaurant"

@interface EDRestaurant (Methods)

#pragma mark - Creation Methods

/// checks to see if restaurant with same name exists
///      - if YES, then adds the location (if not close) and meals to the existing
+ (EDRestaurant *) createRestaurantWithName:(NSString *) name
                                   location:(EDLocation *) location
                                      meals:(NSSet *) meals
                                       tags:(NSSet *) tags
                                withContext:(NSManagedObjectContext *) context;

/// creates EDLocation object from longitude and latitude, then uses above method
+ (EDRestaurant *) createRestaurantWithName:(NSString *) name
                                  longitude:(double) longitude
                                   latitude:(double) latitude
                                      meals:(NSSet *) meals
                                       tags:(NSSet *) tags
                                withContext:(NSManagedObjectContext *) context;

+ (void) setUpDefaultRestaurantsWithContext: (NSManagedObjectContext *) context;

#pragma mark - property helper methods


#pragma mark - Elimination Methods

/// determines if the restaurant is currently on the elimination list
- (BOOL) isCurrentlyEliminated;



#pragma mark - Fetching

+ (NSFetchRequest *) fetchAllRestaurants;

+ (NSFetchRequest *) fetchRestaurantForName: (NSString *) name;

+ (NSSet *) getRestaurantsWithinRegion: (CLRegion *) region inContext:(NSManagedObjectContext *) context;

+ (NSSet *) getRestaurantsOnTopOf:(CLLocation *)location inContext:(NSManagedObjectContext *) context;

#pragma mark - Tagging

@end
