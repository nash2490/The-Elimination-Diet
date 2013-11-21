//
//  EDEatenMeal.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/11/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EDEvent.h"

@class EDMeal;

@interface EDEatenMeal : EDEvent

@property (nonatomic, retain) EDMeal *meal;

@end
