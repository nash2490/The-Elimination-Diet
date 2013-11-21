//
//  EDStartStop+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/26/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDStartStop.h"

@interface EDStartStop (Methods)

// returns whether today lies between start and stop
- (BOOL) isCurrent;

// gets the interval between self.start and self.stop
- (NSTimeInterval) getTimeInterval;

// determines if the time interval of the receiver overlaps with that of the input
- (BOOL) overlapWithStartStop:(EDStartStop *) startStop;

- (BOOL) overlapWithStart:(NSDate *)start stop:(NSDate *)stop;


@end
