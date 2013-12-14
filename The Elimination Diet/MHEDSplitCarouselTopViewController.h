//
//  MHEDSplitCarouselTopViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDSplitViewController.h"

#import "iCarousel.h"


@protocol MHEDSplitCarouselDataSource <NSObject>

@optional

- (NSArray *) imagesForCarousel;
- (void) deletePictureAtIndex:(NSInteger) pictureIndex;

@end


@interface MHEDSplitCarouselTopViewController : MHEDSplitViewController <MHEDSplitCarouselDataSource>


@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *carouselImages;



#pragma mark - MHEDSplitCarouselDataSource methods

- (NSArray *) imagesForCarousel;

#pragma mark - View Layout and Adjusting

- (void) handleShowHideButtonPress:(id)sender;

@end
