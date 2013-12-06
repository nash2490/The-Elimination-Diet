//
//  NSString+MHED_EatDate.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 5/28/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "NSString+MHED_EatDate.h"

@implementation NSString (MHED_EatDate)

+(NSString *) createUniqueID
{
    NSString *id = [[NSDate date] description];
    int random = arc4random() % 10000;
    return [NSString stringWithFormat:@"%@ %i", id, random];
}

- (NSDate *) convertToEatDate;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy - hh:mm aaa"];
    NSDate *dateFromString = [dateFormatter dateFromString:self];
    
    return dateFromString;
}

// helper function for above
// takes 1 inputs
//          - mutable array to add the nsdate to
- (void) addDateToArray: (NSMutableArray *) mutDates
{
    NSDate *eatDate = nil;
    eatDate = [self convertToEatDate];
    
    [mutDates addObject:eatDate];
}


+ (NSString *) convertEatDateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy - hh:mm aaa"];
    NSString *stringFromDate = [dateFormatter stringFromDate:date];
    
    return stringFromDate;
}

+ (NSString *) convertEatDateToHoursAndMin: (NSDate *) date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
    
    NSInteger hour = [components hour];
    NSInteger min = [components minute];
    
    NSString *timeString = @"";
    
    if (hour == 0) {
        timeString = [timeString stringByAppendingFormat:@"12"];
    }
    
    else if (hour > 0 && hour < 13) {
        timeString = [timeString stringByAppendingFormat:@"%i", hour];
    }
    else if (hour >= 13 && hour < 24) {
        timeString = [timeString stringByAppendingFormat:@"%i", hour - 12];
    }
    
    
    
    if (min == 0) {
        timeString = [timeString stringByAppendingFormat:@":00"];
    }
    else if (0 < min && min < 10) {
        timeString = [timeString stringByAppendingFormat:@":0%i", min];
    }
    else if (10 <= min && min < 60) {
        timeString = [timeString stringByAppendingFormat:@":%i", min];
    }
    
    
    
    return timeString;
}

@end
