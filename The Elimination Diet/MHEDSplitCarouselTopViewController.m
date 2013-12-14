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
    
    MHEDCarouselViewController *carouselVC = [[MHEDCarouselViewController alloc] init];
    carouselVC.dataSource = self;
    
    [super displayContentController:carouselVC
                inContainerLocation:MHEDSplitViewContainerViewLocationTop];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - MHEDSplitCarouselDataSource methods

- (NSArray *) imagesForCarousel
{
    return [self.carouselImages copy];
}



#pragma mark - View Layout and Adjusting

- (void) handleShowHideButtonPress:(id)sender
{
    [super handleShowHideButtonPress:sender];
}

#pragma mark - EDImageButtonCellDelegate

- (void) deletePictureAtIndex:(NSInteger)pictureIndex
{
    if ([self.images count]) {
        // show alert
        
        
        
        [self.images removeObjectAtIndex:(NSUInteger)pictureIndex];
        [self.carouselImages removeObjectAtIndex:(NSUInteger) pictureIndex];
        //
    }
    
}




@end
