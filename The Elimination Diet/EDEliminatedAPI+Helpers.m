//
//  EDEliminatedAPI+Helpers.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/25/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedAPI+Helpers.h"

@implementation EDEliminatedAPI (Helpers)

+(NSString *) createUniqueID
{
    NSString *id = [[NSDate date] description];
    int random = arc4random() % 10000;
    return [NSString stringWithFormat:@"%@ %i", id, random];
}


@end
