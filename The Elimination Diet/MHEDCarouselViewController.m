//
//  MHEDCarouselViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDCarouselViewController.h"

#import "MHEDCarouselAndSummaryViewController.h"

#import "EDDocumentHandler.h"

#import "NSString+MHED_EatDate.h"
#import "UIImage+MHED_fixOrientation.h"

static double mhedCarouselCellDefaultSize = 250.0;
static double mhedCarouselImageMaxHeight = 200.0;
static double mhedCarouselImageMaxWidth = 280.0;



@interface MHEDCarouselViewController ()

@end

@implementation MHEDCarouselViewController


//- (NSMutableArray *) images
//{
//    if (!_images) {
//        _images = [[NSMutableArray alloc] init];
//    }
//    return _images;
//}


//- (NSMutableArray *) carouselImages
//{
//    if (!_carouselImages) {
//        _carouselImages = [[NSMutableArray alloc] init];
//    }
//    return _carouselImages;
//}


- (iCarousel *) mhedCarousel
{
    if (!_mhedCarousel) {
        _mhedCarousel = [[iCarousel alloc] init];
        _mhedCarousel.delegate = self;
        _mhedCarousel.dataSource = self;
    }
    return _mhedCarousel;
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
    
    [self setupCarouselInView:self.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addImageToEndOfCarousel:)
                                                 name:MHEDSplitCarouselAddedPictureToModelNotification
                                               object:nil];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.mhedCarousel.frame = [self.view bounds];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    //self.mhedCarousel = nil;
}

- (void) dealloc
{
    self.mhedCarousel.delegate = nil;
    self.mhedCarousel.dataSource = nil;
    self.mhedCarousel = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MHEDSplitCarouselAddedPictureToModelNotification
                                                  object:nil];
}

- (void) setupCarouselInView:(UIView *) view
{

    if (self.mhedCarousel && view) {
        
        self.mhedCarousel.frame = [view bounds];
        [view addSubview:self.mhedCarousel];
    }
}

- (void) addImageToEndOfCarousel:(id) sender
{
//    UIImage *newImage = [self.dataSource imageForIndex:[self.carouselImages count]];
//    
//    UIImage *newCarouselImage = [self convertImageForCarousel:newImage];
//    
//    [self.carouselImages addObject:newCarouselImage];
    
    [self.mhedCarousel insertItemAtIndex:[[self.dataSource imagesForCarousel] count] - 1 animated:YES];
}

#pragma mark - EDImageButtonCellDelegate

- (void) handleDeletePictureButton:(id)sender
{
    // show alert
    
    
    // get the index of the image displayed
    NSInteger imageIndex = self.mhedCarousel.currentItemIndex;
    
    
    
    [self deletePictureAtIndex:imageIndex];
    
}

- (void) deletePictureAtIndex:(NSInteger)pictureIndex
{
    // remove image from the array,
    //        NSMutableArray *mutImages = [self.images mutableCopy];
    //        [mutImages removeObjectAtIndex:(NSUInteger)imageIndex];
    //        self.images = [mutImages copy];
    
    //[self.carouselImages removeObjectAtIndex:pictureIndex];
    [self.dataSource deletePictureAtIndex:pictureIndex];
    [self.mhedCarousel removeItemAtIndex:pictureIndex animated:YES];
}

#pragma mark - iCarousel data and delegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSLog(@"number of carousel items = %i", [[self.dataSource imagesForCarousel] count]);
    return [[self.dataSource imagesForCarousel] count];
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
    
    
//    if ([self.carouselImages count] < [[self.dataSource imagesForCarousel] count]) {
//        // use this to size the image
//        UIImage *displayImage = [self convertImageForCarousel:[self.dataSource imagesForCarousel][index]];
//        
//        [self.carouselImages addObject:displayImage];
//    }
//
    
    if (index < [[self.dataSource imagesForCarousel] count]) {
        //UIImage *displayImage = [self convertImageForCarousel:[self.dataSource imagesForCarousel][index]];
        
        UIImage *displayImage = [self convertImage:[self.dataSource imagesForCarousel][index] forCarousel:carousel];
        
        if (!view) {
            view = [[UIImageView alloc] initWithImage:displayImage];
        }
        else {
            ((UIImageView *)view).image = displayImage;
            [view sizeToFit];
        }
    }
    
    // OR this to get it if it is already made
    //UIImage *displayImage = self.carouselImages[index];
    
//    if (!view) {
//        view = [[UIImageView alloc] initWithImage:displayImage];
//    }
//    else {
//        ((UIImageView *)view).image = displayImage;
//        [view sizeToFit];
//    }
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

- (UIImage *) convertImage:(UIImage *) originalImage forCarousel:(iCarousel *) carousel
{
    UIImage *displayImage = [UIImage newImageFrom:originalImage
                                scaledToFitHeight:carousel.bounds.size.height
                                         andWidth:carousel.bounds.size.width];
    
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




@end
