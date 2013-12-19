//
//  MHEDSplitCarouselTopViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDSplitViewController.h"

//#import "iCarousel.h"


@protocol MHEDSplitCarouselDataSource <NSObject>

@optional

- (NSArray *) imagesForCarousel;
- (id) imageForIndex:(NSUInteger) index;
- (void) deletePictureAtIndex:(NSInteger) pictureIndex;

@end

@protocol MHEDSplitCarouselDelegate <NSObject>

@optional

- (void) mhedUpdateViewOnResize;

@end


@interface MHEDSplitCarouselTopViewController : MHEDSplitViewController <MHEDSplitCarouselDataSource>


@property (nonatomic, strong) NSMutableArray *images;
//@property (nonatomic, strong) NSMutableArray *carouselImages;


#pragma mark - Container View Controller


- (void) updateViewForResizeInLocation:(MHEDSplitViewContainerViewLocation) location;
- (void) setupContainerViews;

#pragma mark - MHEDSplitCarouselDataSource methods

- (NSArray *) imagesForCarousel;
- (id) imageForIndex:(NSUInteger) index;
- (void) deletePictureAtIndex:(NSInteger)pictureIndex;

#pragma mark - View Layout and Adjusting

//- (void) handleShowHideButtonPress:(id)sender;

@end
