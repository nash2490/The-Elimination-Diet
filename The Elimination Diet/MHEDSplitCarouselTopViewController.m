//
//  MHEDSplitCarouselTopViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDSplitCarouselTopViewController.h"

#import "MHEDCarouselViewController.h"


@interface MHEDSplitCarouselTopViewController ()

@end

@implementation MHEDSplitCarouselTopViewController

- (NSMutableArray *) images
{
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - MHEDSplitCarouselDataSource methods

- (NSArray *) imagesForCarousel
{
    return [self.images copy];
}

- (id) imageForIndex:(NSUInteger)index
{
    if (index < [self.images count]) {
        return self.images[index];
    }
    return nil;
}



#pragma mark - Container View Controller


- (void) updateViewForResizeInLocation:(MHEDSplitViewContainerViewLocation) location
{
    if (location == MHEDSplitViewContainerViewLocationTop) {
        
    }
}



- (void) setupContainerViews
{
    [self displayCarouselViewControllerInTopContainerView];
}

- (void) displayCarouselViewControllerInTopContainerView
{
    MHEDCarouselViewController *carouselVC = [[MHEDCarouselViewController alloc] initWithNibName:nil bundle:nil];
    
    carouselVC.dataSource = self;
    
    [super displayContentController:carouselVC
                inContainerLocation:MHEDSplitViewContainerViewLocationTop];
    
}




#pragma mark - EDImageButtonCellDelegate

- (void) deletePictureAtIndex:(NSInteger)pictureIndex
{
    if ([self.images count]) {
        [self.images removeObjectAtIndex:(NSUInteger)pictureIndex];
    }
    
}




@end
