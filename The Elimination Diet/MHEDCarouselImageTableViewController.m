//
//  MHEDCarouselImageTableViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/7/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDCarouselImageTableViewController.h"

#import "EDTagCell.h"
#import "EDMealAndMedicationSegmentedControlCell.h"
#import "EDImageAndNameCell.h"
#import "EDShowHideCell.h"

#import "EDTag+Methods.h"
#import "EDRestaurant+Methods.h"
#import "EDMeal+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDEatenMeal+Methods.h"

#import "EDDocumentHandler.h"

#import "NSString+MHED_EatDate.h"
#import "UIImage+MHED_fixOrientation.h"

#import "EDTableComponents.h"


static double mhedCarouselCellDefaultSize = 250.0;
static double mhedCarouselImageMaxHeight = 200.0;
static double mhedCarouselImageMaxWidth = 280.0;


@interface MHEDCarouselImageTableViewController ()

@property (nonatomic) BOOL tableLoaded; // yes if the table was loaded

@end

@implementation MHEDCarouselImageTableViewController



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
}

- (void) dealloc
{
    [self mhed_Dealloc];
}

- (void) mhed_Dealloc
{
    [super mhed_Dealloc];
    
    self.mhedCarousel.delegate = nil;
    self.mhedCarousel.dataSource = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super navigationController:navigationController willShowViewController:viewController animated:animated];
}


#pragma mark - Table view data source and Delegate

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [super numberOfSectionsInTableView:tableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary *itemData = self.cellArray[section];
    NSString *sectionID = itemData[mhedTableComponentSectionKey];
    
    BOOL hidden = [itemData[mhedTableComponentHideShowBooleanKey] boolValue];

    if ([sectionID isEqualToString:mhedTableSectionIDLargeImageSection]) {
        if (hidden) {
            return 1;
        }
        else if (!self.isHidden) {
            return 2;
        } 
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [super tableView:tableView heightForHeaderInSection:section];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat rowHeight = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    NSLog(@"rowHeight for cell (%i, %i) = %f", indexPath.section, indexPath.row ,rowHeight);

    
    if (rowHeight == tableView.rowHeight) { // then the row height is set to default so we may want to reset it
        
        
        NSMutableDictionary *itemData = self.cellArray[indexPath.section];
        NSString *sectionID = itemData[mhedTableComponentSectionKey];
        
        if ([sectionID isEqualToString:mhedTableSectionIDLargeImageSection]) {
            
            BOOL hidden = [itemData[mhedTableComponentHideShowBooleanKey] boolValue];
            
            // if the row is hidden and this is the showHide cell then it is normal size
            if (hidden) {
                
            }
            
            // else, if the row is shown and it is the showHideCell it is larger
            else if(!hidden && indexPath.row == 0){
                return mhedCarouselCellDefaultSize;
            }
        }
        
        else if ([itemData[mhedTableComponentCellIDKey] isEqualToString:mhedTableCellIDLargeImageCell]) {
            return mhedCarouselCellDefaultSize;
        }
    }
    
    
  
    
    return rowHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [super tableView:tableView titleForHeaderInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableLoaded = YES;
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *) mhedTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super mhedTableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        
        NSInteger modelSection = indexPath.section;
        
        NSMutableDictionary *itemData = self.cellArray[modelSection];
        
        NSString *sectionID = itemData[mhedTableComponentSectionKey];
        
        if ([sectionID isEqualToString:mhedTableSectionIDLargeImageSection]) {
            
            BOOL isHidden = [itemData[mhedTableComponentHideShowBooleanKey] boolValue];
            
            if (!isHidden && indexPath.row == 0) {
                cell = [self tableView:tableView largeImageCell:cell forDictionary:itemData];
            }
//            else if (!isHidden && indexPath.row == 1) {
//                cell = [self tableView:tableView imageOptionsCell:cell forDictionary:itemData];
//            }
            else {
                cell = [self tableView:tableView showHideCell:cell forDictionary:itemData];
            }
            
        }
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Storyboard Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    [super prepareForSegue:segue sender:sender];
    
}


#pragma mark - EDShowHideCell delegate
- (void) handleShowHideButtonPress:(id) sender
{
    // sender is the cell that
    
    if ([sender isKindOfClass:[EDShowHideCell class]]) {
        EDShowHideCell *cell = (EDShowHideCell *) sender;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        if (indexPath) {
            
            NSMutableDictionary *sectionData = self.cellArray[indexPath.section];
            
            self.isHidden = [sectionData[mhedTableComponentHideShowBooleanKey] boolValue];
            
            // if the row is hidden and we selected the showHideCell then we want to show it
            if (self.isHidden) {
                sectionData[mhedTableComponentHideShowBooleanKey] = @(NO);
                self.isHidden = NO;
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:@[indexPath]
                                      withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                
            }
            
            // else, if the row is shown
            else if(!self.isHidden){
                sectionData[mhedTableComponentHideShowBooleanKey] = @(YES);
                self.isHidden = YES;
                NSIndexPath *pathForLargeImageCell = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
                
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[pathForLargeImageCell] withRowAnimation:UITableViewRowAnimationBottom];
                [self.tableView endUpdates];
            }
            
        }
    }
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

#pragma mark - LargeImageCell and iCarousel data and delegate

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



#pragma mark - Large Image Cell

- (UITableViewCell *) tableView:(UITableView *)tableView largeImageCell: (UITableViewCell *) currentCell forDictionary:(NSDictionary *) itemDictionary
{
    UITableViewCell *cell = currentCell;
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellIDLargeImageCell];
        
        
    }
    
    if (cell) {
        EDLargeImageCell *imageCell = (EDLargeImageCell *)cell;
        imageCell.delegate = self;
        
        if (!self.mhedCarousel) {
            self.mhedCarousel = imageCell.mhedCarousel;
            
            self.mhedCarousel.type = iCarouselTypeCoverFlow2;
            [self.mhedCarousel scrollToItemAtIndex:0 animated:NO];
            
            self.mhedCarousel.scrollSpeed = 0.5;
            self.mhedCarousel.decelerationRate = 0.5;
            
            self.mhedCarousel.delegate = self;
            self.mhedCarousel.dataSource = self;
        }
        else {
            imageCell.mhedCarousel = self.mhedCarousel;
            
            if ([self.images count]) {
                [self.mhedCarousel scrollToItemAtIndex:[self.images count] animated:YES];
            }
        }
    }
    
    return cell;
}

- (UITableViewCell *) tableView:(UITableView *)tableView imageOptionsCell: (UITableViewCell *) currentCell forDictionary:(NSDictionary *) itemDictionary
{
    UITableViewCell *cell = currentCell;
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellIDImageButtonCell];
    }
    
    if (cell) {
        EDImageButtonCell *buttonCell = (EDImageButtonCell *)cell;
        buttonCell.delegate = self;
    }
    
    return cell;
}


- (UITableViewCell *) tableView:(UITableView *)tableView showHideCell: (UITableViewCell *) currentCell forDictionary:(NSDictionary *) itemDictionary
{
    UITableViewCell *cell = currentCell;
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellIDShowHideCell];
    }
    
    if (cell) {
        EDShowHideCell *buttonCell = (EDShowHideCell *)cell;
        
        buttonCell.cellHidden = [itemDictionary[mhedTableComponentHideShowBooleanKey] boolValue];
        buttonCell.delegate = self;
        
        [buttonCell updateShowHide];
    }
    
    return cell;
}

- (NSMutableDictionary *) largeImageSectionDictionary
{
    NSMutableDictionary *sectionDict = [@{mhedTableComponentSectionKey : mhedTableSectionIDLargeImageSection,
                                          mhedTableComponentCellIDKey : mhedTableCellIDLargeImageCell ,
                                          mhedTableComponentNoHeaderBooleanKey : @NO,
                                          mhedTableComponentHideShowBooleanKey : @NO} mutableCopy];
    return sectionDict;
}

- (NSMutableDictionary *) largeImageCellDictionary
{
    NSMutableDictionary *cellDict = [@{mhedTableComponentCellIDKey : mhedTableCellIDLargeImageCell ,
                                       mhedTableComponentNoHeaderBooleanKey : @NO} mutableCopy];
    return cellDict;
}

- (NSMutableDictionary *) imageButtonCellDictionary
{
    NSMutableDictionary *cellDict = [@{mhedTableComponentCellIDKey : mhedTableCellIDImageButtonCell ,
                                       mhedTableComponentNoHeaderBooleanKey : @NO} mutableCopy];
    return cellDict;
}

- (NSMutableDictionary *) showHideCellDictionary
{
    NSMutableDictionary *cellDict = [@{mhedTableComponentCellIDKey : mhedTableCellIDShowHideCell ,
                                       mhedTableComponentNoHeaderBooleanKey : @NO,
                                       mhedTableComponentHideShowBooleanKey : @NO} mutableCopy];
    return cellDict;
}


#pragma mark - Subclass methods to Override

// override numberOfRows, and most other table delegate and data source methods

- (NSArray *) defaultDataArray
{
    
    
    
    //self.date1 = [NSDate date];
    
    
    NSMutableDictionary *largeImageSectionDict = [self largeImageSectionDictionary];
    
    //NSMutableDictionary *imageButtonsDict = [super imageButtonCellDictionary];
    
//    NSMutableDictionary *mealOrMedDict = [super mealAndMedicationSegmentedControllCellDictionary];
//    
//    NSMutableDictionary *reminderDict = [super reminderCellDictionary];
//    
//    NSMutableDictionary *detailMealOrMedDict = [super detailMealMedCellDictionary];
//    
//    
//    NSMutableDictionary *dateDict = [super dateCellDictionary:self.date1];
//    
//    
//    NSMutableDictionary *restaurantDict = [super restaurantCellDictionary];
//    
//    NSMutableDictionary *tagsDict = [super tagCellDictionary];
    
    //NSMutableDictionary *showHideDict = [super showHideCellDictionary];
    
    return @[largeImageSectionDict];
}

- (void) handleDoneButton
{
    if (self.medication) {
        [super handleMedicationDoneButton];
    }
    else {
        [super handleMealDoneButton];
    }
}




@end
