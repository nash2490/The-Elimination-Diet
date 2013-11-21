//
//  EDEvent+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/6/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEvent+Methods.h"
#import "EDFood+Methods.h"

#import "NSError+MultipleErrors.h"

#define EVENT_ENTITY_NAME @"EDEvent"

@implementation EDEvent (Methods)

#pragma mark - Fetch Requests -
// --------------------------------------------------

// order by most recent
+ (NSFetchRequest *) fetchAllEvents
{
    return [EDFood fetchObjectsForEntityName:EVENT_ENTITY_NAME];
}

// fetch those between dates given
//      - if we want all events set eventType = nil
+ (NSFetchRequest *) fetchEvents:(NSString *) eventEntityClass
                    BetweenStart:(NSDate *) start
                        andStop:(NSDate *) stop
{
    NSPredicate *startPred = [NSPredicate predicateWithFormat:@"date >= %@", start];
    NSPredicate *stopPred = [NSPredicate predicateWithFormat:@"date <= %@", stop];
    
    NSFetchRequest *fetch;
    if (eventEntityClass) {
        fetch = [NSFetchRequest fetchRequestWithEntityName:eventEntityClass];
    }
    else {
        fetch = [NSFetchRequest fetchRequestWithEntityName:EVENT_ENTITY_NAME];
    }
    
    fetch.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[startPred, stopPred]];
    
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    return fetch;
}

// fetch for last week
+ (NSFetchRequest *) fetchEventsForLastWeek:(NSString *) eventType
{
    NSTimeInterval secondsForWeek = 60 * 60 * 24 * 7 - 1; // actually we want 1 off from that
    NSDate *endOfToday = [EDEvent endOfDay:[NSDate date]];
    
    NSDate *dateSevenDaysAgo = [NSDate dateWithTimeInterval:-secondsForWeek sinceDate:endOfToday];
    
    NSDate *lastWeekStart = [EDEvent beginningOfDay:dateSevenDaysAgo];
    
    return [EDEvent fetchEvents:eventType
                   BetweenStart:lastWeekStart
                        andStop:[NSDate distantFuture]];
}

// fetch for last 24 hrs
+ (NSFetchRequest *) fetchEventsForYesterdayAndToday:(NSString *) eventType
{
    NSDate *startOfYesterday;
    
    NSTimeInterval secondsForDay = 60 * 60 * 24;
    NSTimeInterval secondsOfBuffer = 60 * 60 * 3; // used so that you can check at 3am and not just get one day
    
    NSDate *date24HoursAgo = [NSDate dateWithTimeIntervalSinceNow:-secondsForDay];
    
    NSDate *date3HoursAgo = [NSDate dateWithTimeIntervalSinceNow:-secondsOfBuffer];
    
    NSDate *day24HoursAgo = [EDEvent beginningOfDay:date24HoursAgo];
    NSDate *day3HoursAgo = [EDEvent beginningOfDay:date3HoursAgo];
    
    // if these are the same day, then we need to go further back
    if ([day24HoursAgo isEqualToDate:day3HoursAgo]) {
        NSTimeInterval timeToYesterday = secondsOfBuffer + secondsForDay;
        
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-timeToYesterday];
        
        startOfYesterday = [EDEvent beginningOfDay:yesterday];
    }
    
    else { // then it is past 3am and 24 hours ago was yesterday
        startOfYesterday = day24HoursAgo;
    }
    
    return [EDEvent fetchEvents:eventType
                   BetweenStart:startOfYesterday
                        andStop:[NSDate distantFuture]];
}

// fetch for current day
+ (NSFetchRequest *) fetchEventsForToday:(NSString *) eventType
{
    return [EDEvent fetchEvents:eventType
                       FromDate:[EDEvent beginningOfDay:[NSDate date]]];
}


// fetch from date
+ (NSFetchRequest *) fetchEvents:(NSString *) eventType
                        FromDate:(NSDate *) date
{
    return [EDEvent fetchEvents:eventType
                   BetweenStart:date
                        andStop:[NSDate distantFuture]];
}


#pragma mark - Section Sorting

// just returns the day of the event as a string
- (NSString *) eventDayString
{
    NSDate *dayDate = [EDEvent beginningOfDay:self.date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate:dayDate];
}




#pragma mark - Helper Methods -

+(NSDate *)beginningOfDay:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [cal dateFromComponents:components];
    
}

+(NSDate *)endOfDay:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(  NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
    
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    
    return [cal dateFromComponents:components];
    
}




#pragma mark - Validation Methods

- (BOOL)validateForInsert:(NSError **)error
{
    BOOL propertiesValid = [super validateForInsert:error];
    if (!propertiesValid) {
        
        NSLog(@"%@", [*error localizedDescription]);
        NSLog(@"error event");
        return FALSE;
    }
    
    BOOL consistencyValid = [self validateConsistency:error];
    return (propertiesValid && consistencyValid);
}

- (BOOL)validateForUpdate:(NSError **)error
{
    BOOL propertiesValid = [super validateForUpdate:error];
    if (!propertiesValid) {
        
        NSLog(@"%@", [*error localizedDescription]);
        return FALSE;
    }
    
    BOOL consistencyValid = [self validateConsistency:error];
    return (propertiesValid && consistencyValid);
}




// **** CENTRAL VALIDATION METHOD ****
/// - We need to check if date is nil
- (BOOL)validateConsistency:(NSError **)error
{
    BOOL valid = TRUE;
    
    if (!self.date) {
        valid = FALSE;
    }
    
    if (!valid && error != NULL) {
        // a food cannot have elimination intervals that overlap
        /// To deal with in UI
        //      - show the user the most recent occurence (past, current, future)
        //          - if the adjust the START TIME and it now overlaps
        NSString *dateErrorString = @"Date is not set";
        NSMutableDictionary *edEventInfo = [NSMutableDictionary dictionary];
        edEventInfo[NSLocalizedFailureReasonErrorKey] = dateErrorString;
        edEventInfo[NSValidationObjectErrorKey] = self;
        
        NSError *eliminationOverlapError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                               code:NSManagedObjectValidationError
                                                           userInfo:edEventInfo];
        
        // if there was no previous error, return the new error
        if (*error == nil) {
            *error = eliminationOverlapError;
        }
        // if there was a previous error, combine it with the existing one
        else {
            *error = [NSError errorFromOriginalError:*error error:eliminationOverlapError];
        }
        
        NSLog(@" uuu %@", dateErrorString);

    }
    
    if (!valid) {
        NSLog(@"%@", [*error localizedDescription]);
    }
    return valid;
}

@end
