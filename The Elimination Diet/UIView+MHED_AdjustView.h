//
//  UIView+MHED_AdjustView.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/20/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MHED_AdjustView)

- (void) mhedSetOrigin: (CGPoint) aPoint;
- (void) mhedSetOriginX: (CGFloat) x;
- (void) mhedSetOriginY: (CGFloat) y;

- (void) mhedSetBoundsSize: (CGSize) aSize;
- (void) mhedSetBoundsWidth: (CGFloat) width;
- (void) mhedSetBoundsHeight: (CGFloat) height;

- (void) mhedSetFrameSize: (CGSize) aSize;
- (void) mhedSetFrameWidth: (CGFloat) width;
- (void) mhedSetFrameHeight: (CGFloat) height;

CGPoint CGPointAdd(CGPoint p1, CGPoint p2);
CGPoint CGPointPlusSize(CGPoint point, CGSize size);

@end
