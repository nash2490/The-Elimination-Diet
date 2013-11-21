//
//  EDEliminatedType.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/28/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EDStartStop.h"

@class EDType;

@interface EDEliminatedType : EDStartStop

@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) EDType *type;

@end
