//
//  EDStartStop+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/26/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDStartStop+Methods.h"
#import "NSError+MultipleErrors.h"

@implementation EDStartStop (Methods)


- (BOOL)isCurrent
{
    return [EDStartStop isTime:[NSDate date] betweenPast:self.start andFuture:self.stop];
}

+ (BOOL) isTime:(NSDate *)time betweenPast:(NSDate *)past andFuture:(NSDate *)future
{
    BOOL between = FALSE;
    
    NSDate *earlier = [time earlierDate:past];
    NSDate *later = [time laterDate:future];
    
    // if past is earlier than time, and future is later
    if ([earlier isEqualToDate:past] && [later isEqualToDate:future]) {
        between = TRUE;
    }
    
    return between;
}

- (NSTimeInterval) getTimeInterval
{
    return [self.start timeIntervalSinceDate:self.stop];
}

- (BOOL) overlapWithStartStop:(EDStartStop *) startStop
{
    return [self overlapWithStart:startStop.start stop:startStop.stop];
}

- (BOOL) overlapWithStart:(NSDate *)start stop:(NSDate *)stop
{
    // overlap occurs if either startStop.start or startStop.stop is between start and stop of receiver
    // thankfully we have a helpful method isTime:betweenPast:andFuture:
    BOOL startsBetween = FALSE;
    BOOL stopsBetween = FALSE;
    
    startsBetween = [EDStartStop isTime:start betweenPast:self.start andFuture:self.stop];
    stopsBetween = [EDStartStop isTime:stop betweenPast:self.start andFuture:self.stop];
    
    if (startsBetween && stopsBetween) {
        NSLog(@"Input times lie completely between receiving object");
        return FALSE;
    }
    else if (startsBetween || stopsBetween){
        NSLog(@"Input times have a partial overlap with receiving object");
        return FALSE;
    }
    else if (!startsBetween && !stopsBetween && [EDStartStop isTime:self.start betweenPast:start andFuture:stop]){
        NSLog(@"Receiving EDStartStop completely contains the start and stop times");
        return FALSE;
    }
    
    return TRUE;
}


// Validation methods
//---------------------------------------------------------------

- (BOOL)validateForInsert:(NSError **)error
{
    BOOL propertiesValid = [super validateForInsert:error];
    if (!propertiesValid) return FALSE;
    
    BOOL consistencyValid = [self validateConsistency:error];
    return (propertiesValid && consistencyValid);
}

- (BOOL)validateForUpdate:(NSError **)error
{
    BOOL propertiesValid = [super validateForUpdate:error];
    if (!propertiesValid) return FALSE;
    
    BOOL consistencyValid = [self validateConsistency:error];
    return (propertiesValid && consistencyValid);
}




// **** CENTRAL VALIDATION METHOD ****
/// -
- (BOOL)validateConsistency:(NSError **)error
{
    // only thing we check here is if start < stop
    BOOL valid = YES;
    
    if (self.stop) {
        valid = [self.start isEqualToDate:[self.start earlierDate:self.stop]];
    }
    
    if (valid && error != NULL) {
        NSString *startAfterStopString = @"The start value occurs after the stop value";
        NSMutableDictionary *startAfterStopInfo = [NSMutableDictionary dictionary];
        [startAfterStopInfo setObject:startAfterStopString forKey:NSLocalizedFailureReasonErrorKey];
        [startAfterStopInfo setObject:self forKey:NSValidationObjectErrorKey];
        
        NSError *startAfterStopError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                           code:NSManagedObjectValidationError
                                                       userInfo:startAfterStopInfo];
        
        // if there was no previous error, return the new error
        if (*error == nil) {
            *error = startAfterStopError;
        }
        // if there was a previous error, combine it with the existing one
        else {
            *error = [NSError errorFromOriginalError:*error error:startAfterStopError];
        }
    }
    
    return valid;
}

@end
