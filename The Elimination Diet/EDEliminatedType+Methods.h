//
//  EDEliminatedType+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedType.h"
#import "EDStartStop+Methods.h"

#define ELIMINATED_TYPE_ENTITY_NAME @"EDEliminatedType"

@class EDType;

@interface EDEliminatedType (Methods)

+ (EDEliminatedType *) createWithType:(EDType *) type
                            startTime:(NSDate *) start
                             stopTime:(NSDate *) stop
                           forContext:(NSManagedObjectContext *) context;

@end
