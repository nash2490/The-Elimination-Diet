//
//  EDBodyPart+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/21/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDBodyPart.h"

#define BODY_PART_ENTITY_NAME @"EDBodyPart"







@class EDSymptom, EDSymptomDescription;


@interface EDBodyPart (Methods)

#pragma mark - Property Creation

+ (EDBodyPart *) createBodyPartWithName:(NSString *)name
                            forContext:(NSManagedObjectContext *)context;

+ (void) setUpDefaultBodyPartsInContext:(NSManagedObjectContext *) context;


#pragma mark - Fetching and searching


+ (NSFetchRequest *) fetchAllBodyParts;
+ (NSFetchRequest *) fetchBodyPartsForName: (NSString *) name;


/// get all of this entity
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName;

/// get the food objects of entity, with a string value for keyPath that equals (case insensitive) the 'string' parameter
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                 stringKeyPath: (NSString *) path
                                 equalToString: (NSString *) stringValue;


/// get the food objects of entity, with a set for keyPath that contains the 'value' parameter
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                    setKeyPath: (NSString *) path
                                 containsValue: (id) value;

/// get the food objects of entity that are in set
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
                                 withSelfInSet:(NSSet *) objects;


/// get the food objects of entity and for the uniqueID
+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                      UniqueID: (NSString *) uniqueID;





#pragma mark - Validation

- (BOOL) validateConsistency:(NSError **) error;


#pragma mark - sorting methods

- (NSString *) nameFirstLetter;

@end


static NSString *mhedBodyPartGeneral = @"General";

static NSString *mhedBodyPartHead = @"Head";

static NSString *mhedBodyPartHeadNeck = @"Neck";
static NSString *mhedBodyPartHeadNose = @"Nose";
static NSString *mhedBodyPartHeadEyes = @"Eyes";
static NSString *mhedBodyPartHeadEars = @"Ears";
static NSString *mhedBodyPartHeadMouth = @"Mouth";
static NSString *mhedBodyPartHeadThroat = @"Throat";

static NSString *mhedBodyPartLegFoot = @"Foot";
static NSString *mhedBodyPartLegAnkle = @"Ankle";
static NSString *mhedBodyPartLegShin = @"Shin";
static NSString *mhedBodyPartLegCalf = @"Calf";
static NSString *mhedBodyPartLegKnee = @"Knee";
static NSString *mhedBodyPartLegThigh = @"Thigh";
static NSString *mhedBodyPartLeg = @"Leg";


static NSString *mhedBodyPartArmFingers = @"Fingers";
static NSString *mhedBodyPartArmHand = @"Hand";
static NSString *mhedBodyPartArmWrist = @"Wrist";
static NSString *mhedBodyPartArmElbow = @"Elbow";
static NSString *mhedBodyPartArmShoulder = @"Shoulder";
static NSString *mhedBodyPartArm = @"Arm";

static NSString *mhedBodyPartBack= @"Back";
static NSString *mhedBodyPartBackLower = @"Lower Back";
static NSString *mhedBodyPartBackMid = @"Mid Back";
static NSString *mhedBodyPartBackUpper = @"Upper Back";

static NSString *mhedBodyPartButt = @"Butt";

static NSString *mhedBodyPartTorsoStomach = @"Stomach";
static NSString *mhedBodyPartTorsoChest = @"Chest";
static NSString *mhedBodyPartTorsoLungs = @"Lungs";
static NSString *mhedBodyPartTorsoHeart = @"Heart";
static NSString *mhedBodyPartGroin = @"Groin";


