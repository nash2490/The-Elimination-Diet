//
//  EDData+Restaurants.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/10/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDData+Restaurants.h"
#import "EDData.m"

@implementation EDData (Restaurants)

// restaurants
////////////////////////////////////////////////

- (EDRestaurant *) newRestaurant: (EDRestaurant *) aRestaurant {
    
    EDRestaurant *result = nil;
    
    if (self.restaurants == nil) {
        self.restaurants = [[NSDictionary alloc] initWithObjectsAndKeys:aRestaurant, aRestaurant.name, nil];
        result = aRestaurant;
    }
    else {
        NSMutableDictionary *mutRestaurants = [self.restaurants mutableCopy];
        [mutRestaurants setObject:aRestaurant forKey:aRestaurant.name];
        self.restaurants = [mutRestaurants copy];
        result = aRestaurant;
    }
    return result;
}

- (void) removeRestaurant:(NSString *) restaurantName {
    NSMutableDictionary *mutRestaurant = [self.restaurants mutableCopy];
    [mutRestaurant removeObjectForKey:restaurantName];
    self.restaurants = [mutRestaurant copy];
}

- (NSArray *) sortAllRestaurantsByName
{
    NSSet *allRestaurants = [[NSSet alloc] initWithArray:[self.restaurants allKeys]];
    
    return [self sortRestaurantsByName:allRestaurants];
}

- (NSArray *) sortRestaurantsByName:(NSSet *)restaurantNames
{
    
    NSArray *sortedRestaurants = [[NSArray alloc] init];
    
    if ([restaurantNames count]) {
        sortedRestaurants = [self sortRestaurantsByName:restaurantNames];
    }
    
    return sortedRestaurants;
}

@end
