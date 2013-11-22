//
//  EDBodyPart.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/22/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EDBodyLocation, EDSymptom;

@interface EDBodyPart : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSSet *relatedSymptoms;
@property (nonatomic, retain) EDBodyLocation *bodyLocation;
@end

@interface EDBodyPart (CoreDataGeneratedAccessors)

- (void)addRelatedSymptomsObject:(EDSymptom *)value;
- (void)removeRelatedSymptomsObject:(EDSymptom *)value;
- (void)addRelatedSymptoms:(NSSet *)values;
- (void)removeRelatedSymptoms:(NSSet *)values;

@end
