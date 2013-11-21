//
//  NSSet+MoreSetOperations.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/19/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "NSSet+MoreSetOperations.h"

@implementation NSSet (MoreSetOperations)

// takes a set of sets and unions them, producing one set
+ (NSSet *) unionOfSets:(NSSet *) setOfSets
{
    NSSet *temp = [[NSSet alloc] init];
    for (NSSet *set in setOfSets) {
        temp = [temp setByAddingObjectsFromSet:set];
    }
    return temp;
}

@end
