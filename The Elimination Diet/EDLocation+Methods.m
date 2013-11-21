//
//  EDLocation+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDLocation+Methods.h"
#import "EDRestaurant+Methods.h"

#import <CoreLocation/CoreLocation.h>

@implementation EDLocation (Methods)

+ (EDLocation *) createLocationWithLongitude:(NSNumber *)longitude
                                    latitude:(NSNumber *)latitude
                               andRestaurant:(EDRestaurant *)restaurant
                                   inContext:(NSManagedObjectContext *)context
{
    NSError *error;
    
    //CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    
    NSArray *closeLocations = [context executeFetchRequest:[EDLocation fetchForEDLocationOnTopOf:location] error:&error];
    
    EDLocation *newLocation;
    
    BOOL new = YES; // used to determine if we should create a new location

    if ([closeLocations count])
    {
        // there was a previous location within 10 meters
        // if the restaurant is not a part of any of these locations, then create this new location
        
        for (EDLocation *loc in closeLocations) {
            if ([restaurant isEqual:loc.restaurant]) { // are they equal (assumes restaurant != nil)
                new = NO;
            }
            else if (!restaurant && !loc.restaurant){ // if both are nil
                new = NO;
            }
        }
    }
    
    if (new) {
        newLocation = [NSEntityDescription insertNewObjectForEntityForName:LOCATION_ENTITY_NAME inManagedObjectContext:context];
        
        newLocation.longitude = longitude;
        newLocation.latitude = latitude;
        
        newLocation.restaurant = restaurant;
    }
    
    return newLocation;
}


- (void) setLocationFromCLLocation:(CLLocation *)location
{
    self.longitude = @(location.coordinate.longitude);
    
    self.latitude = @(location.coordinate.latitude);
}

- (CLLocation *) convertToCLLocation
{
    return [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
}

+ (NSFetchRequest *) fetchForEDLocationOnTopOf:(CLLocation *)location
{
    NSString *regionId = [NSString stringWithFormat:@"(%f,%f) + 10.0", location.coordinate.latitude, location.coordinate.longitude];
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:location.coordinate radius:10.0 identifier:regionId];
    
    return [EDLocation fetchForEDLocationInRegion:region];
}

+ (NSFetchRequest *) fetchForEDLocationWithinDefaultRadius:(CLLocation *)location
{
    NSString *regionId = [NSString stringWithFormat:@"(%f,%f) + 1000.0", location.coordinate.latitude, location.coordinate.longitude];
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:location.coordinate radius:1000.0 identifier:regionId];
    
    return [EDLocation fetchForEDLocationInRegion:region];
}

+ (NSFetchRequest *) fetchForEDLocationInRegion: (CLRegion *) region
{
    
    
    NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
    {
        double longitude = [[(EDLocation *)evaluatedObject longitude] doubleValue];
        double latitude = [[(EDLocation *)evaluatedObject latitude] doubleValue];
        
        CLLocationCoordinate2D point = CLLocationCoordinate2DMake(latitude, longitude);
        
        return [region containsCoordinate: point];
    }];
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:LOCATION_ENTITY_NAME];
    fetch.predicate = pred;
    
    return fetch;
}


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
