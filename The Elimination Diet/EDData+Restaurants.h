//
//  EDData+Restaurants.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/10/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDData.h"

@interface EDData (Restaurants)

// Restaurants ////////////////////////////////////////////////
- (EDRestaurant *) newRestaurant: (EDRestaurant *) aRestaurant;
- (void) removeRestaurant: (NSString *) restaurantName;

- (NSArray *) sortAllRestaurantsByName;  //output is NSArray of NSString sorted from A - Z

- (NSArray *) sortRestaurantsByName: (NSSet *) restaurantNames; // input is NSSet of NSString
// output is NSArray of NSString


@end
