//
//  MHEDCarouselTopTableBottomViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/11/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDCarouselTopTableBottomViewController.h"

#import "EDDocumentHandler.h"

#import "NSString+MHED_EatDate.h"
#import "UIImage+MHED_fixOrientation.h"

static double mhedCarouselCellDefaultSize = 250.0;
static double mhedCarouselImageMaxHeight = 200.0;
static double mhedCarouselImageMaxWidth = 280.0;



@interface MHEDCarouselTopTableBottomViewController ()

@end

@implementation MHEDCarouselTopTableBottomViewController


//- (iCarousel *) mhedCarousel
//{
//    if (!_mhedCarousel) {
//        _mhedCarousel = [[iCarousel alloc] init];
//        _mhedCarousel.delegate = self;
//        _mhedCarousel.dataSource = self;
//    }
//    return _mhedCarousel;
//}

- (NSMutableArray *) images
{
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}


- (NSMutableArray *) carouselImages
{
    if (!_carouselImages) {
        _carouselImages = [[NSMutableArray alloc] init];
    }
    return _carouselImages;
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
    
    self.mhedCarousel = nil;
}

- (void) dealloc
{
    self.mhedCarousel = nil;
    
    self.mhedCarousel.delegate = nil;
    self.mhedCarousel.dataSource = nil;
}




#pragma mark - EDImageButtonCellDelegate

- (void) handleDeletePictureButton:(id)sender
{
    if ([self.images count]) {
        // show alert
        
        // get the index of the image displayed
        NSInteger imageIndex = self.mhedCarousel.currentItemIndex;
        
        // remove image from the array,
        //        NSMutableArray *mutImages = [self.images mutableCopy];
        //        [mutImages removeObjectAtIndex:(NSUInteger)imageIndex];
        //        self.images = [mutImages copy];
        
        
        [self.mhedCarousel removeItemAtIndex:imageIndex animated:YES];
        
        [self.images removeObjectAtIndex:(NSUInteger)imageIndex];
        [self.carouselImages removeObjectAtIndex:(NSUInteger) imageIndex];
        //
    }
    
}

#pragma mark - iCarousel data and delegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSLog(@"number of carousel items = %i", [self.carouselImages count]);
    return [self.carouselImages count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //    //create a numbered view
    //    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
    //    view.backgroundColor = [UIColor lightGrayColor];
    //    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    //    label.text = [NSString stringWithFormat:@"%i", index];
    //    label.backgroundColor = [UIColor clearColor];
    //    label.textAlignment = NSTextAlignmentCenter;
    //    label.font = [label.font fontWithSize:50];
    //    [view addSubview:label];
    //    return view;
    
    //view = [[UIImageView alloc] initWithImage:self.images[index]];
    
    //UIImage *displayImage = [UIImage alloc] initwith
    
    
    // use this to size the image
    //UIImage *displayImage = [self convertImageForCarousel:self.images[index]];
    // OR this to get it if it is already made
    UIImage *displayImage = self.carouselImages[index];
    
    view = [[UIImageView alloc] initWithImage:displayImage];
    return view;
}


- (UIImage *) convertImageForCarousel:(UIImage *) originalImage
{
    UIImage *displayImage;
    
    //[originalImage fixOrientation];
    
    if (originalImage.imageOrientation == UIImageOrientationUp ||
        originalImage.imageOrientation == UIImageOrientationDown) {
        //imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130.0 * SCREEN_RATIO, 130.0f)];
        //displayImage = [UIImage newImageFrom:originalImage toFitHeight: LARGE_IMAGE_CELL_DEFAULT_SIZE];
        displayImage = [UIImage newImageFrom:originalImage scaledToFitHeight:mhedCarouselImageMaxHeight andWidth:mhedCarouselImageMaxWidth];
        
    }
    else if (originalImage.imageOrientation == UIImageOrientationRight ||
             originalImage.imageOrientation == UIImageOrientationLeft){
        //imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130.0 / SCREEN_RATIO, 130.0f)];
        //displayImage = [UIImage newImageFrom:originalImage toFitHeight: LARGE_IMAGE_CELL_DEFAULT_SIZE];
        displayImage = [UIImage newImageFrom:originalImage scaledToFitHeight:mhedCarouselImageMaxHeight andWidth:mhedCarouselImageMaxWidth];
        
    }
    
    return displayImage;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return NO;
        }
            
        case iCarouselOptionSpacing:
        {
            return 0.5;
        }
            
        default:
        {
            return value;
        }
    }
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
	NSLog(@"Carousel will begin dragging");
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
	NSLog(@"Carousel did end dragging and %@ decelerate", decelerate? @"will": @"won't");
}

- (void)carouselWillBeginDecelerating:(iCarousel *)carousel
{
	NSLog(@"Carousel will begin decelerating");
}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
	NSLog(@"Carousel did end decelerating");
}

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel
{
	NSLog(@"Carousel will begin scrolling");
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
	NSLog(@"Carousel did end scrolling");
}


#pragma mark - View Layout and Adjusting


- (void) handleShowHideButtonPress:(id)sender
{
    if (self.carouselIsHidden) {
        self.carouselIsHidden = NO;
        
        // animate Open
    }
    
    else {
        self.carouselIsHidden = YES;
        
        // animate close;
    }
    
}

- (void) displayContentController: (UIViewController*) content
{
//    [self addChildViewController:content];                 // 1
//    content.view.frame = [self frameForContentController]; // 2
//    [self.view addSubview:self.currentClientView];
//    [content didMoveToParentViewController:self];          // 3
    
    [content willMoveToParentViewController:self];
    
    [self addChildViewController:content];
    
    content.view.frame = [self.mhedBottomContainerView bounds];

    [self.mhedBottomContainerView addSubview:content.view];

    [content didMoveToParentViewController:self];
    
    
//    content.view.frame = self.mhedBottomContainerView.bounds;
//
//    [content willMoveToParentViewController:self];
//    [self.mhedBottomContainerView addSubview:content.view];
//    [self addChildViewController:content];
//    [content didMoveToParentViewController:self];
}


@end
