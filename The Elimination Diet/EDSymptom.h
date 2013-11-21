//
//  EDSymptom.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/21/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EDHadSymptom, EDTag;

@interface EDSymptom : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSSet *timesHad;
@property (nonatomic, retain) NSManagedObject *bodyPart;
@property (nonatomic, retain) NSManagedObject *symptomDescription;
@property (nonatomic, retain) EDTag *newRelationship;
@end

@interface EDSymptom (CoreDataGeneratedAccessors)

- (void)addTimesHadObject:(EDHadSymptom *)value;
- (void)removeTimesHadObject:(EDHadSymptom *)value;
- (void)addTimesHad:(NSSet *)values;
- (void)removeTimesHad:(NSSet *)values;

@end
