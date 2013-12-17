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

@class EDImage;

@interface MHEDCarouselViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, weak) id <MHEDSplitCarouselDataSource> dataSource;

//@property (nonatomic, strong) NSMutableArray *images;
////@property (nonatomic, strong) iCarousel *mhedCarousel;
//@property (nonatomic, strong) NSMutableArray *carouselImages;
@property (nonatomic, strong) iCarousel *mhedCarousel;

- (UIImage *) convertImage:(id) imageObject forCarousel:(iCarousel *) carousel;
- (UIImage *) convertUIImageForCarousel:(UIImage *) originalImage;
- (UIImage *) convertUIImage:(UIImage *) originalImage forCarousel:(iCarousel *) carousel;
- (UIImage *) convertImageFromPath:(NSString *) imagePath forCarousel: (iCarousel *) carousel;
- (UIImage *) convertEDImage:(EDImage *) edImage forCarousel:(iCarousel *)carousel;

- (void) deletePictureAtIndex:(NSInteger)pictureIndex;

@end
