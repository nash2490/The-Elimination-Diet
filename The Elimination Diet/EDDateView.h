//
//  EDDateView.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/4/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EDDateProtocol <NSObject>

- (NSDate *) getDateForDisplay;

@optional

- (void) handleTomorrowButtonPress;
- (void) handleYesterdayButtonPress;
- (void) handleTodayButtonPress;

@end

@interface EDDateView : UIView

@property id <EDDateProtocol> delegate;

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *weekdayLabel;
@property (nonatomic, strong) UILabel *monthLabel;

- (void) drawViewInFrame;


@end
