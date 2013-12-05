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


static NSString *edBodyPartGeneral = @"General";

static NSString *edBodyPartHead = @"Head";

static NSString *edBodyPartHeadNeck = @"Neck";
static NSString *edBodyPartHeadNose = @"Nose";
static NSString *edBodyPartHeadEyes = @"Eyes";
static NSString *edBodyPartHeadEars = @"Ears";
static NSString *edBodyPartHeadMouth = @"Mouth";
static NSString *edBodyPartHeadThroat = @"Throat";

static NSString *edBodyPartLegFoot = @"Foot";
static NSString *edBodyPartLegAnkle = @"Ankle";
static NSString *edBodyPartLegShin = @"Shin";
static NSString *edBodyPartLegCalf = @"Calf";
static NSString *edBodyPartLegKnee = @"Knee";
static NSString *edBodyPartLegThigh = @"Thigh";
static NSString *edBodyPartLeg = @"Leg";


static NSString *edBodyPartArmFingers = @"Fingers";
static NSString *edBodyPartArmHand = @"Hand";
static NSString *edBodyPartArmWrist = @"Wrist";
static NSString *edBodyPartArmElbow = @"Elbow";
static NSString *edBodyPartArmShoulder = @"Shoulder";
static NSString *edBodyPartArm = @"Arm";

static NSString *edBodyPartBack= @"Back";
static NSString *edBodyPartBackLower = @"Lower Back";
static NSString *edBodyPartBackMid = @"Mid Back";
static NSString *edBodyPartBackUpper = @"Upper Back";

static NSString *edBodyPartButt = @"Butt";

static NSString *edBodyPartTorsoStomach = @"Stomach";
static NSString *edBodyPartTorsoChest = @"Chest";
static NSString *edBodyPartTorsoLungs = @"Lungs";
static NSString *edBodyPartTorsoHeart = @"Heart";
static NSString *edBodyPartGroin = @"Groin";


