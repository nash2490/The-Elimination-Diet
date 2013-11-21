//
//  EDEliminatedIngredient+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedIngredient+Methods.h"
#import "EDIngredient+Methods.h"

@implementation EDEliminatedIngredient (Methods)

+ (EDEliminatedIngredient *) createWithIngredient:(EDIngredient *)ingredient
                                        startTime:(NSDate *)start
                                         stopTime:(NSDate *)stop
                                       forContext:(NSManagedObjectContext *)context
{
    // Check if an existing EDEliminatedIngredient exists for this ingredient and has overlaping time
    //      - if one exists then we don't create a new one
    
    BOOL overlap = FALSE;
    for (EDEliminatedIngredient *elim in ingredient.whenEliminated) {
        if ([elim overlapWithStart:start stop:stop]) {
            // ERROR
            overlap = TRUE;
        }
    }
    
    
    
    // if there is no overlap from before
    if (!overlap) {
        
        EDEliminatedIngredient *temp = [NSEntityDescription insertNewObjectForEntityForName:ELIMINATED_INGREDIENT_ENTITY_NAME
                                                                     inManagedObjectContext:context];
        
        // set object properties to obvious or empty;
        temp.uniqueID = [[NSDate date] description];
        temp.ingredient = ingredient;
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
