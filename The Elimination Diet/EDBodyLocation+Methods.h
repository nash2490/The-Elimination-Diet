//
//  EDBodyLocation+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/22/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//


// appendage is integer
typedef NS_ENUM(NSUInteger, EDBodyLocationAppendageName) { EDBodyLocationAppendageTorso, EDBodyLocationAppendageLeg, EDBodyLocationAppendageArm, EDBodyLocationAppendageHeadAndNeck, EDBodyLocationAppendageBack, EDBodyLocationAppendageEntireBody};

// left/right is integer
typedef NS_ENUM(NSUInteger, EDBodyLocationHorizontal) { EDBodyLocationLeft, EDBodyLocationRight, EDBodyLocationCenter, EDBodyLocationAll};

// location is float between 0 and 1.0 to determine the position along the appendage vertical (-1 means all)


#import "EDBodyLocation.h"


#define BODY_LOCATION_ENTITY_NAME @"EDBodyLocation"




@interface EDBodyLocation (Methods)

#pragma mark - Property Creation

+ (EDBodyLocation *) createBodyLocationWithAppendage:(EDBodyLocationAppendageName) appendage
                                       leftRight:(EDBodyLocationHorizontal) leftRight
                                   locationFloat:(float) locationFloat
                                      forContext:(NSManagedObjectContext *)context;



// need default body locations and getter methods for
/// -- @"Head", @"Foot", @"Leg", @"Knee", @"Thigh", @"Ankle", @"Shin", @"Calf", @"Arm", @"Elbow", @"Shoulder", @"Wrist", @"Neck", @"Nose", @"Eyes", @"Mouth", @"Ears", @"Back", @"Lower Back", @"Mid Back", @"Upper Back", @"Butt", @"Stomach", @"Chest", @"Lungs", @"Throat", @"Heart", @"Groin"

#pragma mark - Fetching and searching


+ (NSFetchRequest *) fetchAllBodyLocations;
+ (NSFetchRequest *) fetchBodyLocationsForAppendage:(EDBodyLocationAppendageName) appendage;


/// get all of this entity
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName;


/// get the food objects of entity and for the uniqueID
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                      UniqueID: (NSString *) uniqueID;





#pragma mark - Validation

- (BOOL) validateConsistency:(NSError **) error;



@end
