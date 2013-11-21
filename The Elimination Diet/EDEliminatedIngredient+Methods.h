//
//  EDEliminatedIngredient+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedIngredient.h"
#import "EDStartStop+Methods.h"
#import "EDIngredient+Methods.h"

#define ELIMINATED_INGREDIENT_ENTITY_NAME @"EDEliminatedIngredient"

@interface EDEliminatedIngredient (Methods)

+ (EDEliminatedIngredient *) createWithIngredient:(EDIngredient *) ingredient
                                        startTime:(NSDate *) start
                                         stopTime:(NSDate *) stop
                                       forContext:(NSManagedObjectContext *) context;


@end
