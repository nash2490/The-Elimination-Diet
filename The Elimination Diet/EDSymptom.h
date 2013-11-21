//
//  EDSymptom.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/21/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EDBodyPart, EDHadSymptom, EDSymptomDescription, EDTag;

@interface EDSymptom : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSSet *timesHad;
@property (nonatomic, retain) EDBodyPart *bodyPart;
@property (nonatomic, retain) EDSymptomDescription *symptomDescription;
@property (nonatomic, retain) NSSet *tags;
@end

@interface EDSymptom (CoreDataGeneratedAccessors)

- (void)addTimesHadObject:(EDHadSymptom *)value;
- (void)removeTimesHadObject:(EDHadSymptom *)value;
- (void)addTimesHad:(NSSet *)values;
- (void)removeTimesHad:(NSSet *)values;

- (void)addTagsObject:(EDTag *)value;
- (void)removeTagsObject:(EDTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
