//
//  MHEDDividerGestureRecognizer.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/18/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDDividerGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>


@implementation MHEDDividerGestureRecognizer

- (instancetype) initMHEDDividerGestureWithTarget:(id)target action:(SEL)action
{
    self = [self initWithTarget:target action:action];
    if (self) {
        self.mhedMaximumNumberOfTouches = 2;
        self.mhedMinimumNumberOfTouches = 1;
    }
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    
//    if ([self.delegate respondsToSelector:@selector(dividerViewWillStartTrackingTouches:)])
//        [self.delegate dividerViewWillStartTrackingTouches:self];
//}
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    BOOL isLand = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
//    CGPoint pt = [touches.anyObject locationInView:self.superview];
//    CGFloat ptVal = isLand ? pt.x : pt.y;
//    CGFloat startVal = isLand ? self.frame.origin.x : self.frame.origin.y;
//    CGFloat offset = (startVal - ptVal) * -1;
//    [self.delegate dividerView:self moveByOffset:offset];
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if ([self.delegate respondsToSelector:@selector(dividerViewDidEndTrackingTouches:)])
//        [self.delegate dividerViewDidEndTrackingTouches:self];
//}
//
//-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if ([self.delegate respondsToSelector:@selector(dividerViewDidEndTrackingTouches:)])
//        [self.delegate dividerViewDidEndTrackingTouches:self];
//}
//
//
//- (void) reset
//{
//    
//}

@end
