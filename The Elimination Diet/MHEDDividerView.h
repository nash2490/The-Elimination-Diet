//
//  MHEDDividerView.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/18/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MHEDDividerView;

@protocol MHEDDividerViewDelegate <NSObject>

-(void)dividerViewWillStartTrackingTouches: (MHEDDividerView *) dividerView;
-(void)dividerView: (MHEDDividerView *) dividerView    moveByOffset:(CGFloat) offset;
-(void)dividerViewDidEndTrackingTouches: (MHEDDividerView *) dividerView;

@end


@interface MHEDDividerView : UIView

@property (nonatomic, weak) id<MHEDDividerViewDelegate> delegate;
@property (nonatomic) BOOL gripVisible;



@end
