//
//  EDBodyLocation.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/22/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EDBodyPart;

@interface EDBodyLocation : NSManagedObject

@property (nonatomic, retain) NSNumber * appendage;
@property (nonatomic, retain) NSNumber * location;
@property (nonatomic, retain) NSNumber * leftRight;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSSet *relatedBodyParts;
@end

@interface EDBodyLocation (CoreDataGeneratedAccessors)

- (void)addRelatedBodyPartsObject:(EDBodyPart *)value;
- (void)removeRelatedBodyPartsObject:(EDBodyPart *)value;
- (void)addRelatedBodyParts:(NSSet *)values;
- (void)removeRelatedBodyParts:(NSSet *)values;

@end
