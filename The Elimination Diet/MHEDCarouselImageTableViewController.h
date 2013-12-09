//
//  MHEDCarouselImageTableViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/7/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDTableViewController.h"

static double mhedCarouselCellDefaultSize = 250.0;
static double mhedCarouselImageMaxHeight = 200.0;
static double mhedCarouselImageMaxWidth = 280.0;

@interface MHEDCarouselImageTableViewController : MHEDTableViewController <iCarouselDataSource, iCarouselDelegate, EDImageButtonCellDelegate, EDShowHideCellDelegate>

#pragma mark - Large Image cell

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, weak) iCarousel *mhedCarousel;
@property (nonatomic, strong) NSMutableArray *carouselImages;

- (NSMutableDictionary *) largeImageCellDictionary;
- (NSMutableDictionary *) imageButtonCellDictionary;
- (NSMutableDictionary *) showHideCellDictionary;

- (UIImage *) convertImageForCarousel:(UIImage *) originalImage;


#pragma mark - EDShowHideButton Cell Delegate
- (void) handleShowHideButtonPress:(id)sender;


#pragma mark - Subclass methods to Override

// override numberOfRows, and most other table delegate and data source methods

- (NSArray *) defaultDataArray;
- (void) handleDoneButton;

@end
