//
//  EDRestaurant+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/28/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDRestaurant+Methods.h"

#import "EDFood+Methods.h"
#import "EDMeal+Methods.h"
#import "EDLocation+Methods.h"

#import <CoreLocation/CoreLocation.h>

@implementation EDRestaurant (Methods)

// Creation Methods
// ---------------------------------------------------------

+ (EDRestaurant *) createRestaurantWithName:(NSString *) name
                                   location:(EDLocation *) location
                                      meals:(NSSet *) meals
                                       tags:(NSSet *) tags
                                withContext:(NSManagedObjectContext *) context
{
    NSError *error;
        
    CLLocation *restaurantLocation = [location convertToCLLocation];
    
    NSArray *sameNameRestaurants = [context executeFetchRequest:[EDRestaurant fetchRestaurantForName:name] error:&error];
    
    EDRestaurant *newRestaurant;
    
    BOOL new = YES; // used to determine if we should create a new Restaurant
    
    if ([sameNameRestaurants count]) {
        newRestaurant = sameNameRestaurants[0];
        
        // if an existing location for this restaurant is within 50 meters of the new location then we already have recorded this location
        for (EDLocation *loc in newRestaurant.locations) {
            CLLocation *existingRestaruantLocation = [loc convertToCLLocation];
            
            double distance = [restaurantLocation distanceFromLocation:existingRestaruantLocation];
            
            if (distance < 50.0) { 
                new = NO;
            }
        }
    }
    
    else {
        newRestaurant = [NSEntityDescription insertNewObjectForEntityForName:RESTAURANT_ENTITY_NAME inManagedObjectContext:context];
        [newRestaurant addMeals:meals];
        [newRestaurant addTags:tags];
    }
    
    
    if (new) {
        [newRestaurant addLocationsObject:location];
    }
    
    return newRestaurant;
    
    
}

+ (EDRestaurant *) createRestaurantWithName:(NSString *)name
                                  longitude:(double)longitude
                                   latitude:(double)latitude
                                      meals:(NSSet *)meals
                                       tags:(NSSet *)tags
                                withContext:(NSManagedObjectContext *)context
{
    EDLocation *loc = [EDLocation createLocationWithLongitude:@(longitude) latitude:@(latitude) andRestaurant:nil inContext:context];
    
    EDRestaurant *rest = [EDRestaurant createRestaurantWithName:name location:loc meals:meals tags:tags withContext:context];
    
    return rest;
}

+ (void) setUpDefaultRestaurantsWithContext: (NSManagedObjectContext *) context
{
    
}

// property helper methods
// ---------------------------------------------------------


// Elimination Methods
//---------------------------------------------------------------

// determines if the restaurant is currently on the elimination list
- (BOOL) isCurrentlyEliminated
{
    return [super isCurrentlyEliminated];
}



// Fetching
// --------------------------------------------------

+ (NSFetchRequest *) fetchAllRestaurants
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:RESTAURANT_ENTITY_NAME];
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    return fetch;
}

+ (NSFetchRequest *) fetchRestaurantForName:(NSString *)name
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:RESTAURANT_ENTITY_NAME];
    
    fetch.predicate = [NSPredicate predicateWithFormat:@"name like[cd] %@", name];
    
    return fetch;
}

+ (NSSet *) getRestaurantsWithinRegion: (CLRegion *) region inContext:(NSManagedObjectContext *) context
{
    // determine the EDLocations in region and then get the restaurants associated to them
    NSFetchRequest *fetch = [EDLocation fetchForEDLocationInRegion:region];
    
    NSArray *locations = [context executeFetchRequest:fetch error:nil];
    
    NSMutableSet *restaurants = [NSMutableSet set];
    
    for (EDLocation *loc in locations) {
        if (loc.restaurant) {
            [restaurants addObject:loc.restaurant];
        }
    }
    
    return restaurants;
}

+ (NSSet *) getRestaurantsOnTopOf:(CLLocation *)location inContext:(NSManagedObjectContext *) context
{
    // determine the EDLocations in region and then get the restaurants associated to them
    NSFetchRequest *fetch = [EDLocation fetchForEDLocationOnTopOf:location];
    
    NSArray *locations = [context executeFetchRequest:fetch error:nil];
    
    NSMutableSet *restaurants = [NSMutableSet set];
    
    for (EDLocation *loc in locations) {
        if (loc.restaurant) {
            [restaurants addObject:loc.restaurant];
        }
    }
    
    return restaurants;
}

// Tagging
// --------------------------------------------------


#pragma mark - Validation

// Validation Helpers
//---------------------------------------------------------------



// Validation methods
//---------------------------------------------------------------

- (BOOL)validateForInsert:(NSError **)error
{
    BOOL propertiesValid = [super validateForInsert:error];
    if (!propertiesValid) {
        
        NSLog(@"%@", [*error localizedDescription]);
        NSLog(@"error event");
        return FALSE;
    }
    
    BOOL consistencyValid = [self validateConsistency:error];
    return (propertiesValid && consistencyValid);
}

- (BOOL)validateForUpdate:(NSError **)error
{
    BOOL propertiesValid = [super validateForUpdate:error];
    if (!propertiesValid) {
        
        NSLog(@"%@", [*error localizedDescription]);
        return FALSE;
    }
    
    BOOL consistencyValid = [self validateConsistency:error];
    return (propertiesValid && consistencyValid);
}





// **** CENTRAL VALIDATION METHOD ****
/// - We need to check
//      -
//      - that there are NO cycles of parentMedicationDosages
- (BOOL)validateConsistency:(NSError **)error
{
    //  do cycles in parent/children exist
    BOOL valid = YES;
    
    //
    if (!valid)
    {
        
    }
    
    return valid;
}



@end
