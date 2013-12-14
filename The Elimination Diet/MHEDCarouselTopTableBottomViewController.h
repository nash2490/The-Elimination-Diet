//
//  MHEDCarouselTopTableBottomViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/11/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iCarousel.h"


@interface MHEDCarouselTopTableBottomViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>


@property (nonatomic, strong) NSMutableArray *images;
//@property (nonatomic, strong) iCarousel *mhedCarousel;
@property (nonatomic, strong) NSMutableArray *carouselImages;
@property (nonatomic, weak) IBOutlet iCarousel *mhedCarousel;

- (UIImage *) convertImageForCarousel:(UIImage *) originalImage;


// Bottom View Controller's ContainerView

@property (weak, nonatomic) IBOutlet UIView *mhedBottomContainerView;



#pragma mark - View Layout and Adjusting

@property (nonatomic) BOOL carouselIsHidden;

- (void) handleShowHideButtonPress:(id)sender;

- (void) displayContentController: (UIViewController*) content;
@end
