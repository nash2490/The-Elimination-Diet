//
//  EDEliminatedIngredient.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/28/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EDStartStop.h"

@class EDIngredient;

@interface EDEliminatedIngredient : EDStartStop

@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) EDIngredient *ingredient;

@end
