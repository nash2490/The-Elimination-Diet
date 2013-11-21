//
//  EDSymptomDescription.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/21/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EDSymptom;

@interface EDSymptomDescription : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSSet *relatedSymptoms;
@end

@interface EDSymptomDescription (CoreDataGeneratedAccessors)

- (void)addRelatedSymptomsObject:(EDSymptom *)value;
- (void)removeRelatedSymptomsObject:(EDSymptom *)value;
- (void)addRelatedSymptoms:(NSSet *)values;
- (void)removeRelatedSymptoms:(NSSet *)values;

@end
