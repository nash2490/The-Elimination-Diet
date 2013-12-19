//
//  MHEDDividerView.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/18/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDDividerView.h"

#import "EDEliminatedAPI+MHEDColors.h"



static CGFloat mhedGripWidth = 30;



@interface MHEDDividerGripView : UIView
@property (assign) BOOL gripVisible;
@end




@interface MHEDDividerView ()

@property (nonatomic, weak) MHEDDividerGripView *gripView;

@end


@implementation MHEDDividerView



- (void) awakeFromNib
{
    [super awakeFromNib];
    [self dividerSetupWithFrame:self.frame];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self dividerSetupWithFrame:frame];
    }
    return self;
}




- (UIColor *) mhedDividerBackgroundColor
{
    UIColor *dividerColor = [EDEliminatedAPI mhedLightestColor];
    return dividerColor;
}

- (void) dividerSetupWithFrame: (CGRect) frame
{
    self.backgroundColor = [self mhedDividerBackgroundColor];
    
    
    MHEDDividerGripView *gripView = [[MHEDDividerGripView alloc] initWithFrame:CGRectMake(fabs(frame.size.width/2), 2, mhedGripWidth, frame.size.height)];
    gripView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.gripView = gripView;
    gripView.gripVisible = YES;
    [self addSubview:gripView];
    gripView.center = CGPointMake(fabsf(self.bounds.size.width/2), fabsf(self.bounds.size.height/2));
    gripView.backgroundColor = [UIColor clearColor];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect gframe = self.gripView.frame;
    CGRect frame = self.frame;
    CGPoint gripOrigin;
    
    if (frame.size.width > frame.size.height) {
        //portrait
//        gframe.size.width = OVAL_HEIGHT;
//        gframe.size.height = OVAL_WIDTH;

        CGFloat gripWidth = 30.0;
        
        gripOrigin = CGPointMake(self.bounds.size.width - (gripWidth + 20), 0);
        gframe.origin = gripOrigin;
        gframe.size = CGSizeMake(gripWidth, self.bounds.size.height);
    
    } else {
//        gframe.size.width = OVAL_WIDTH;
//        gframe.size.height = OVAL_HEIGHT;
    }
    self.gripView.frame = gframe;
    self.gripView.center = CGPointMake(fabsf(gripOrigin.x + (gframe.size.width/2)), fabsf(self.bounds.size.height/2));
    [self.gripView setNeedsDisplay];
    
    
    

    
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
//    CGRect frame = self.frame;
//    CGRect sframe = self.superview.frame;
//    BOOL portrait = sframe.size.width > sframe.size.height;
    
//    CGRect ovalRect = CGRectMake(fabs((frame.size.width - OVAL_WIDTH)/2) - OVAL_WIDTH, fabs((frame.size.height - OVAL_HEIGHT)/2), OVAL_WIDTH, OVAL_HEIGHT);
//    
//    if (ovalRect.origin.x < 0) ovalRect.origin.x = 0;
//    if (portrait)
//        ovalRect = CGRectMake(0, 0, ovalRect.size.height, ovalRect.size.width);
//    //UIColor *ovalColor = [[UIColor alloc] initWithRed:203.0 green:203.0 blue:203.0 alpha:1.0];
    
    
    
    
    
    [self drawGripInRect:rect];
}

- (void) drawGripInRect: (CGRect) rect
{
    UIColor *ovalColor = [EDEliminatedAPI mhedGreyColor];
    
    CGFloat ovalWidth = rect.size.width - 2;
    CGFloat ovalHeight = fabsf(rect.size.height/8);
    
    CGFloat space = rect.size.height - (3 * ovalHeight);
    CGFloat spacer = 3;
    CGFloat topSpacer = (space - (3 * spacer)) / 2;
    
    CGFloat cornerRadius = ovalWidth/2;
    
    
    
    for (int i = 0; i < 3 ; i++) {
        CGRect ovalRect = CGRectMake(rect.origin.x,
                                     rect.origin.y + topSpacer + (i * spacer) + (i * ovalHeight),
                                     rect.size.width,
                                     ovalHeight);
        
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:ovalRect cornerRadius:cornerRadius];
        [ovalColor setFill];
        [path fill];
    }
    
    
}


@end
