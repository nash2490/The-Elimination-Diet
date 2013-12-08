//
//  UIView+MHED_AdjustView.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/20/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "UIView+MHED_AdjustView.h"

@implementation UIView (MHED_AdjustView)

- (void) mhedSetOrigin:(CGPoint)aPoint
{
    CGRect newFrame = self.frame;
    newFrame.origin = aPoint;
    self.frame = newFrame;
}

- (void) mhedSetOriginX:(CGFloat)x
{
    CGRect newFrame = self.frame;
    newFrame.origin.x = x;
    self.frame = newFrame;
}

- (void) mhedSetOriginY:(CGFloat)y
{
    CGRect newFrame = self.frame;
    newFrame.origin.y = y;
    self.frame = newFrame;
}

- (void) mhedSetBoundsSize:(CGSize)aSize
{
    CGRect newBounds = self.bounds;
    newBounds.size = aSize;
    self.bounds = newBounds;
}

- (void) mhedSetBoundsWidth:(CGFloat)width
{
    CGRect newFrame = self.bounds;
    newFrame.size.width = width;
    self.bounds = newFrame;
}

- (void) mhedSetBoundsHeight:(CGFloat)height
{
    CGRect newFrame = self.bounds;
    newFrame.size.height = height;
    self.bounds = newFrame;
}

- (void) mhedSetFrameSize:(CGSize)aSize
{
    CGRect newFrame = self.frame;
    newFrame.size = aSize;
    self.frame = newFrame;
}

- (void) mhedSetFrameWidth:(CGFloat)width
{
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
}

- (void) mhedSetFrameHeight:(CGFloat)height
{
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
}


CGPoint CGPointAdd(CGPoint p1, CGPoint p2)
{
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

CGPoint CGPointPlusSize(CGPoint point, CGSize size)
{
    return CGPointMake(point.x + size.width, point.y + size.height);
}

@end
