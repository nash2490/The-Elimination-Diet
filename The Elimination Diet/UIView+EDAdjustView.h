//
//  UIView+EDAdjustView.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/20/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EDAdjustView)

- (void) edSetOrigin: (CGPoint) aPoint;
- (void) edSetOriginX: (CGFloat) x;
- (void) edSetOriginY: (CGFloat) y;

- (void) edSetBoundsSize: (CGSize) aSize;
- (void) edSetBoundsWidth: (CGFloat) width;
- (void) edSetBoundsHeight: (CGFloat) height;

- (void) edSetFrameSize: (CGSize) aSize;
- (void) edSetFrameWidth: (CGFloat) width;
- (void) edSetFrameHeight: (CGFloat) height;

CGPoint CGPointAdd(CGPoint p1, CGPoint p2);
CGPoint CGPointPlusSize(CGPoint point, CGSize size);

@end
