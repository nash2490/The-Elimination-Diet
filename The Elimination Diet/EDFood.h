//
//  EDFood.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EDEliminatedFood, EDImage, EDTag;

@interface EDFood : NSManagedObject

@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) NSSet *whenEliminated;
@property (nonatomic, retain) NSSet *images;
@end

@interface EDFood (CoreDataGeneratedAccessors)

- (void)addTagsObject:(EDTag *)value;
- (void)removeTagsObject:(EDTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

- (void)addWhenEliminatedObject:(EDEliminatedFood *)value;
- (void)removeWhenEliminatedObject:(EDEliminatedFood *)value;
- (void)addWhenEliminated:(NSSet *)values;
- (void)removeWhenEliminated:(NSSet *)values;

- (void)addImagesObject:(EDImage *)value;
- (void)removeImagesObject:(EDImage *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
