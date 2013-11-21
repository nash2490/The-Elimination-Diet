//
//  EDEliminatedAPI+Sorting.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/25/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedAPI+Sorting.h"

@implementation EDEliminatedAPI (Sorting)

+ (NSSortDescriptor *) nameSortDescriptor
{
    return [NSSortDescriptor sortDescriptorWithKey:@"name"
                                         ascending:YES
                                          selector:@selector(localizedCaseInsensitiveCompare:)];
}


+ (NSSortDescriptor *) sortDescriptorForProperty: (NSString *) property
                                 caseInsensitive: (BOOL) caseInsensitive
{
    if (caseInsensitive) {
        return [NSSortDescriptor sortDescriptorWithKey:property
                                             ascending:YES
                                              selector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    return [NSSortDescriptor sortDescriptorWithKey:property ascending:YES];
}

+ (NSString *) nameFirstLetter:(NSString *) string
{
    if ([string length]) {
        return [string substringToIndex:1];
    }
    
    return @"";
    
}

@end
