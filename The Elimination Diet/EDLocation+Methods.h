//
//  EDLocation+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDLocation.h"

@class CLLocation, CLRegion;

#define LOCATION_ENTITY_NAME @"EDLocation"

@interface EDLocation (Methods)

/*! Create an instance of EDLocation inside of a context
 @param longitude
 @param latitude
 @param restaurant
 @param context
 @returns created instance of EDLocation
 */
+ (EDLocation *) createLocationWithLongitude: (NSNumber *) longitude
                                    latitude: (NSNumber *) latitude
                               andRestaurant: (EDRestaurant *) restaurant
                                   inContext: (NSManagedObjectContext *) context;

/*! Changes the location to the input location
 @param location new location to change to
 @returns void
 */
- (void) setLocationFromCLLocation: (CLLocation *) location;

/// returns the location of the EDLocation as CLLocation object
- (CLLocation *) convertToCLLocation;


#pragma mark - Fetch Requests
/// creates a fetch request with location equal to input
+ (NSFetchRequest *) fetchForEDLocationOnTopOf: (CLLocation *) location;

/// creates a fetch request within the default radius of the location
+ (NSFetchRequest *) fetchForEDLocationWithinDefaultRadius: (CLLocation *) location;

/// creates a fetch request within region
+ (NSFetchRequest *) fetchForEDLocationInRegion: (CLRegion *) region;


@end
