//
//  EDEliminatedFood.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/6/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EDEvent.h"

@class EDFood;

@interface EDEliminatedFood : EDEvent

@property (nonatomic, retain) NSDate * stop;
@property (nonatomic, retain) EDFood *eliminatedFood;

@end
