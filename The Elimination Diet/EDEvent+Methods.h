//
//  EDEvent+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/6/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEvent.h"

@interface EDEvent (Methods)


#pragma mark - Fetch Requests -
/*!
 @returns A fetch request that will fetch all event objects, and subclasses, sorted by most recent
 */
+ (NSFetchRequest *) fetchAllEvents;

/*! Create a fetch request that retreives events of a certain class between specified dates
 @param eventEntityClass the name of the subclass of EDEvent to fetch entities of
 @returns 
*/
// fetch those between dates given
+ (NSFetchRequest *) fetchEvents:(NSString *) eventEntityClass
                    BetweenStart:(NSDate *) start
                         andStop:(NSDate *) stop;

/// fetch for last week
+ (NSFetchRequest *) fetchEventsForLastWeek:(NSString *) eventType;


/// fetch for last 24 hrs
+ (NSFetchRequest *) fetchEventsForYesterdayAndToday:(NSString *) eventType;

/// fetch for current day
+ (NSFetchRequest *) fetchEventsForToday:(NSString *) eventType;

/// fetch from date
+ (NSFetchRequest *) fetchEvents:(NSString *) eventType
                        FromDate:(NSDate *) date;


#pragma mark - Section Sorting

/// just returns the day of the event as a string
- (NSString *) eventDayString;



#pragma mark - Helper Methods -
/// date that's at 00:00 in morning of same day
+ (NSDate *) beginningOfDay:(NSDate *)date;

/// date that's at 23:59 for hour of same day
+ (NSDate *) endOfDay:(NSDate *)date;




#pragma mark - Validation

- (BOOL) validateConsistency:(NSError **) error;


@end
