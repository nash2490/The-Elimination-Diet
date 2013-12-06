//
//  NSString+MHED_EatDate.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 5/28/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MHED_EatDate)

+ (NSString *) createUniqueID;

- (NSDate *) convertToEatDate;
+ (NSString *) convertEatDateToString: (NSDate *) date;

+ (NSString *) convertEatDateToHoursAndMin: (NSDate *) date;

- (void) addDateToArray: (NSMutableArray *) mutDates;

@end
