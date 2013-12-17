//
//  MHEDCarouselViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iCarousel.h"

#import "MHEDSplitCarouselTopViewController.h"

@interface MHEDCarouselViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, weak) id <MHEDSplitCarouselDataSource> dataSource;

//@property (nonatomic, strong) NSMutableArray *images;
////@property (nonatomic, strong) iCarousel *mhedCarousel;
//@property (nonatomic, strong) NSMutableArray *carouselImages;
@property (nonatomic, strong) iCarousel *mhedCarousel;

- (UIImage *) convertImageForCarousel:(UIImage *) originalImage;
- (void) deletePictureAtIndex:(NSInteger)pictureIndex;

@end
