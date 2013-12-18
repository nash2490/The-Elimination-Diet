//
//  MHEDDividerGestureRecognizer.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/18/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MHEDDividerGestureRecognizer : UIGestureRecognizer

@property (nonatomic) NSUInteger mhedMaximumNumberOfTouches;
@property (nonatomic) NSUInteger mhedMinimumNumberOfTouches;

- (instancetype) initMHEDDividerGestureWithTarget:(id)target action:(SEL)action;

@end
