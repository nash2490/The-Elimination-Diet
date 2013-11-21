//
//  EDTag.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/4/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EDFood;

@interface EDTag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSSet *foodWithTag;
@end

@interface EDTag (CoreDataGeneratedAccessors)

- (void)addFoodWithTagObject:(EDFood *)value;
- (void)removeFoodWithTagObject:(EDFood *)value;
- (void)addFoodWithTag:(NSSet *)values;
- (void)removeFoodWithTag:(NSSet *)values;

@end
