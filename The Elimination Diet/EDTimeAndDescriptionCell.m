//
//  EDTimeAndDescriptionCell.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/5/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDTimeAndDescriptionCell.h"

@implementation EDTimeAndDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setUpTimeLabel];
    }
    return self;
}

- (void) setUpTimeLabel
{
    // create label from string
    //      - rect is far left -- (0, 0, 40, cell height)
    CGRect timeRect = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), 40.0, CGRectGetHeight(self.frame));
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:timeRect];
    timeLabel.font = [UIFont systemFontOfSize:12.0];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel = timeLabel;
    [self addSubview:self.timeLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
- (void) createAndSetTimeLabel: (NSDate *) date
{
    // convert date to time string
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
    
    NSInteger hour = [components hour];
    NSInteger min = [components minute];
    
    NSString *timeString = @"";
    
    if (hour > 1 && hour < 13) {
        timeString = [timeString stringByAppendingFormat:@"%i", hour];
    }
    else if (hour == 0) {
        timeString = [timeString stringByAppendingFormat:@"12"];
    }
    else if (hour < 24 && hour > 12) {
        timeString = [timeString stringByAppendingFormat:@"%i", hour - 12];
    }
    
    timeString = [timeString stringByAppendingFormat:@" : %i", min];
    
    
    // create label from string
    //      - rect is far left -- (0, 0, 40, cell height)
    CGRect timeRect = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), 40.0, CGRectGetHeight(self.frame));
    NSLog(@"%f", timeRect.origin.x);
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:timeRect];
    timeLabel.text = timeString;
    timeLabel.font = [UIFont systemFontOfSize:22.0];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel = timeLabel;
    [self addSubview:self.timeLabel];
    
}



- (NSString *) convertDateToTime: (NSDate *) date
{
    // convert date to time string
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
    
    NSInteger hour = [components hour];
    NSInteger min = [components minute];
    
    NSString *timeString = @"";
    
    if (hour > 1 && hour < 13) {
        timeString = [timeString stringByAppendingFormat:@"%i", hour];
    }
    else if (hour == 0) {
        timeString = [timeString stringByAppendingFormat:@"12"];
    }
    else if (hour < 24 && hour > 12) {
        timeString = [timeString stringByAppendingFormat:@"%i", hour - 12];
    }
    
    timeString = [timeString stringByAppendingFormat:@" : %i", min];
    
    return timeString;
}
*/


@end
