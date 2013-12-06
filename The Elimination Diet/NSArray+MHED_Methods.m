//
//  NSArray+MHED_Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/4/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "NSArray+MHED_Methods.h"

@implementation NSArray (MHED_Methods)

- (NSAttributedString *) attributedComponentsJoinedByAttributedString:(NSAttributedString *)joinString
{
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] init];
    
    // add all but the last att string
    for (int i = 0; i < [self count] - 1;  i++) {
        
        NSAttributedString *temp = self[i];
        if (![self[i] isKindOfClass:[NSAttributedString class]]) { // if the object not an attributed string then we try to get a string otherwise we dont' add
            
            if ([self[i] isKindOfClass:[NSString class]]) { // if it is a string then we just make an att string from it
                temp = [[NSAttributedString alloc] initWithString:self[i]];
            }
            
            else { // otherwise we can't get anything
                temp = nil;
            }
        }
        
        [mutAttString appendAttributedString:temp];
        [mutAttString appendAttributedString:joinString];
    }
    
    // add the last one
    NSAttributedString *last = [self lastObject];
    if (![[self lastObject] isKindOfClass:[NSAttributedString class]]) { // if the object not an attributed string then we try to get a string otherwise we dont' add
        
        if ([[self lastObject] isKindOfClass:[NSString class]]) { // if it is a string then we just make an att string from it
            last = [[NSAttributedString alloc] initWithString:[self lastObject]];
        }
        
        else { // otherwise we can't get anything
            last = nil;
        }
    }
    
    [mutAttString appendAttributedString:last];
    
    return [mutAttString copy];
}

@end
