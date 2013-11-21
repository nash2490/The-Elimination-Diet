//
//  EDSymptom.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/6/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EDHadSymptom;

@interface EDSymptom : NSManagedObject

@property (nonatomic, retain) NSString * bodyPart;
@property (nonatomic, retain) NSString * symptomDescription;
@property (nonatomic, retain) NSSet *timesHad;
@end

@interface EDSymptom (CoreDataGeneratedAccessors)

- (void)addTimesHadObject:(EDHadSymptom *)value;
- (void)removeTimesHadObject:(EDHadSymptom *)value;
- (void)addTimesHad:(NSSet *)values;
- (void)removeTimesHad:(NSSet *)values;

@end
