//
//  NSError+MHED_MultipleErrors.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/26/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "NSError+MHED_MultipleErrors.h"

@implementation NSError (MHED_MultipleErrors)

// generic method to combine errors
+ (NSError *)errorFromOriginalError:(NSError *)originalError error:(NSError *)secondError
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSMutableArray *errors = [NSMutableArray arrayWithObject:secondError];
    
    if ([originalError code] == NSValidationMultipleErrorsError) {
        
        [userInfo addEntriesFromDictionary:[originalError userInfo]];
        [errors addObjectsFromArray:userInfo[NSDetailedErrorsKey]];
    }
    else {
        [errors addObject:originalError];
    }
    
    userInfo[NSDetailedErrorsKey] = errors;
    
    return [NSError errorWithDomain:NSCocoaErrorDomain
                               code:NSValidationMultipleErrorsError
                           userInfo:userInfo];
}

@end
