//
//  EDDateView.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/4/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDDateView.h"

@implementation EDDateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self drawViewInFrame:rect];
    
}
*/

- (void) drawViewInFrame;
{
    CGRect frame = self.frame;
    
    NSDate *displayDate = [self.delegate getDateForDisplay];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit fromDate:displayDate];

    NSInteger intDay = [components day];
    NSInteger intWeekday = [components weekday];
    NSInteger intMonth = [components month];
    
    NSString *day = @"";
    NSString *weekday = @"";
    NSString *month = @"";
    
    // day string
    if (intDay < 10) {
        day = @"0";
    }
    day = [day stringByAppendingFormat:@"%i", intDay];
    
    // weekday string
    switch (intWeekday) {
        case 1:
            weekday = @"Sun";
            break;
        case 2:
            weekday = @"Mon";
            break;
        case 3:
            weekday = @"Tues";
            break;
        case 4:
            weekday = @"Wed";
            break;
        case 5:
            weekday = @"Thur";
            break;
        case 6:
            weekday = @"Fri";
            break;
        case 7:
            weekday = @"Sat";
            break;
        default:
            break;
    }
    
    // Month string
    switch (intMonth) {
        case 1:
            month = @"Jan";
            break;
        case 2:
            month = @"Feb";
            break;
        case 3:
            month = @"Mar";
            break;
        case 4:
            month = @"Apr";
            break;
        case 5:
            month = @"May";
            break;
        case 6:
            month = @"June";
            break;
        case 7:
            month = @"July";
            break;
        case 8:
            month = @"Aug";
            break;
        case 9:
            month = @"Sept";
            break;
        case 10:
            month = @"Oct";
            break;
        case 11:
            month = @"Nov";
            break;
        case 12:
            month = @"Dec";
            break;

        default:
            break;
    }
    
    // start is 40 left of midpoint - width of 30
    CGRect dayRect = CGRectMake(CGRectGetMidX(frame) - 40.0, CGRectGetMinY(frame), 40.0, CGRectGetHeight(frame));
    //NSLog(@"%f", dayRect.origin.x);
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayRect];
    dayLabel.text = day;
    dayLabel.font = [UIFont systemFontOfSize:32.0];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel = dayLabel;
    [self addSubview:self.dayLabel];
    
    // start is 10 left of midpoint - width is 50, height is half
    CGRect weekdayRect = CGRectMake(CGRectGetMidX(frame) + 5.0, CGRectGetMinY(frame), 35.0, 0.5 * CGRectGetHeight(frame));
    UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayRect];
    weekdayLabel.text = weekday;
    weekdayLabel.font = [UIFont systemFontOfSize:14.0];
    weekdayLabel.textAlignment = NSTextAlignmentCenter;
    self.weekdayLabel = weekdayLabel;
    [self addSubview:self.weekdayLabel];
    
    // start is 10 left of midpoint, halfway down from top - width is 50, height is half
    CGRect monthRect = CGRectMake(CGRectGetMidX(frame) + 5.0, CGRectGetMidY(frame), 35.0, 0.5 * CGRectGetHeight(frame));
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:monthRect];
    monthLabel.text = month;
    monthLabel.font = [UIFont systemFontOfSize:14.0];
    monthLabel.textAlignment = NSTextAlignmentCenter;
    self.monthLabel = monthLabel;
    [self addSubview:self.monthLabel];
    
}

@end
