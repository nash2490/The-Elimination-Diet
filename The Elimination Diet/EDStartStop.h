//
//  EDStartStop.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/29/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EDFood;

@interface EDStartStop : NSManagedObject

@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSDate * stop;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) EDFood *eliminatedFood;

@end
