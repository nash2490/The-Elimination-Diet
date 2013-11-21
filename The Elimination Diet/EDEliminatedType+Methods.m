//
//  EDEliminatedType+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedType+Methods.h"
#import "EDType+Methods.h"

@implementation EDEliminatedType (Methods)

+ (EDEliminatedType *) createWithType:(EDType *) type
                            startTime:(NSDate *) start
                             stopTime:(NSDate *) stop
                           forContext:(NSManagedObjectContext *) context
{
    
    // Check if an existing EDEliminatedType exists for this type and has overlaping time
    //      - if one exists then we don't create a new one
    
    BOOL overlap = FALSE;
    for (EDEliminatedType *elim in type.whenEliminated) {
        if ([elim overlapWithStart:start stop:stop]) {
            // ERROR
            overlap = TRUE;
        }
    }
    
    
    
    // if there is no overlap from before
    if (!overlap) {
        
        EDEliminatedType *temp = [NSEntityDescription insertNewObjectForEntityForName:ELIMINATED_TYPE_ENTITY_NAME
                                                     inManagedObjectContext:context];
        
        // set object properties to obvious or empty;
        temp.uniqueID = [[NSDate date] description];
        temp.type = type;
        temp.start = start;
        
        if (!stop) {
            temp.stop = [NSDate distantFuture];
        }
        else {
            temp.stop = stop;
        }
        
        return temp;
    }
    else {
        return nil;
    }

}



@end
