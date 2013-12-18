//
//  MHEDDividerView.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/18/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDDividerView.h"

#define OVAL_WIDTH 8
#define OVAL_HEIGHT 44

@interface MHEDDividerGripView : UIView
@property (assign) BOOL gripVisible;
@end




@interface MHEDDividerView ()

@property (nonatomic, weak) MHEDDividerGripView *gripView;

@end


@implementation MHEDDividerView



- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
        MHEDDividerGripView *gripView = [[MHEDDividerGripView alloc] initWithFrame:CGRectMake(fabs(frame.size.width/2), 2, OVAL_WIDTH, OVAL_HEIGHT)];
        gripView.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.gripView = gripView;
        gripView.gripVisible = YES;
        [self addSubview:gripView];
        gripView.center = CGPointMake(fabsf(self.bounds.size.width/2), fabsf(self.bounds.size.height/2));
        gripView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect gframe = self.gripView.frame;
    CGRect frame = self.frame;
    if (frame.size.width > frame.size.height) {
        //portrait
        gframe.size.width = OVAL_HEIGHT;
        gframe.size.height = OVAL_WIDTH;
    } else {
        gframe.size.width = OVAL_WIDTH;
        gframe.size.height = OVAL_HEIGHT;
    }
    self.gripView.frame = gframe;
    self.gripView.center = CGPointMake(fabsf(self.bounds.size.width/2), fabsf(self.bounds.size.height/2));
    [self.gripView setNeedsDisplay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(dividerViewWillStartTrackingTouches:)])
        [self.delegate dividerViewWillStartTrackingTouches:self];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL isLand = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    CGPoint pt = [touches.anyObject locationInView:self.superview];
    CGFloat ptVal = isLand ? pt.x : pt.y;
    CGFloat startVal = isLand ? self.frame.origin.x : self.frame.origin.y;
    CGFloat offset = (startVal - ptVal) * -1;
    [self.delegate dividerView:self moveByOffset:offset];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(dividerViewDidEndTrackingTouches:)])
        [self.delegate dividerViewDidEndTrackingTouches:self];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(dividerViewDidEndTrackingTouches:)])
        [self.delegate dividerViewDidEndTrackingTouches:self];
}

-(BOOL)gripVisible
{
    return self.gripView.gripVisible;
}

-(void)setGripVisible:(BOOL)gripVisible
{
    self.gripView.gripVisible = gripVisible;
}

@end

@implementation MHEDDividerGripView

-(void)drawRect:(CGRect)rect
{
    if (!self.gripVisible)
        return;
    CGRect frame = self.frame;
    CGRect sframe = self.superview.frame;
    BOOL portrait = sframe.size.width > sframe.size.height;
    CGRect ovalRect = CGRectMake(fabs((frame.size.width - OVAL_WIDTH)/2) - OVAL_WIDTH, fabs((frame.size.height - OVAL_HEIGHT)/2), OVAL_WIDTH, OVAL_HEIGHT);
    if (ovalRect.origin.x < 0) ovalRect.origin.x = 0;
    if (portrait)
        ovalRect = CGRectMake(0, 0, ovalRect.size.height, ovalRect.size.width);
    UIColor *ovalColor = [[UIColor alloc] initWithRed:203.0 green:203.0 blue:203.0 alpha:1.0];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:ovalRect cornerRadius:12];
    [ovalColor setFill];
    [path fill];
}

@end
