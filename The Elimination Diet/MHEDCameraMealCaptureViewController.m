//
//  MHEDCameraMealCaptureViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/7/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDCameraMealCaptureViewController.h"


#import "EDTagCell.h"
#import "EDMealAndMedicationSegmentedControlCell.h"
#import "EDImageAndNameCell.h"

#import "EDTag+Methods.h"
#import "EDRestaurant+Methods.h"
#import "EDMeal+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDEatenMeal+Methods.h"

#import "EDDocumentHandler.h"

#import "NSString+MHED_EatDate.h"

#import "EDTableComponents.h"

#import "UIImage+MHED_fixOrientation.h"

@import MobileCoreServices;

@interface MHEDCameraMealCaptureViewController ()

@property (nonatomic) BOOL tableLoaded; // yes if the table was loaded

@end



@implementation MHEDCameraMealCaptureViewController


- (NSArray *) capturedImages
{
    if (!_capturedImages) {
        _capturedImages = [[NSArray alloc] init];
    }
    return _capturedImages;
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
    
    // Date Setup
    // --------------------------------------
    [self setupDateAndDatePickerCell];
    
    
    self.imagePickerController = [self imagePickerControllerForSourceType:UIImagePickerControllerSourceTypeCamera];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self mhed_Dealloc];
}

- (void) mhed_Dealloc
{
    [super mhed_Dealloc];
    
    self.imagePickerController = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // the first time we add an image we
    if (!self.tableLoaded && !self.imagePickerController) {
        self.tableLoaded = YES;
        [self.tableView reloadData];
    }
    
    //self.imagePickerController.tabBarController.tabBar.hidden = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // the first time we add an image we
    if (!self.tableLoaded && !self.imagePickerController) {
        self.tableLoaded = YES;
        [self.tableView reloadData];
    }
    
    if (![self.images count] && !self.cameraCanceled) {
        [self showImagePickerForCamera:self];
        //[super showImagePickerForCamera:self];
    }
    
    else if (self.cameraCanceled) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (BOOL)prefersStatusBarHidden
{
    if (self.imagePickerController) {
        return YES;
    }
    
    return NO;
}


#pragma mark - Table view data source and Delegate

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (!self.tableLoaded) {
        return 0;
        //return [super numberOfSectionsInTableView:tableView];
        
    }
    
    else {
        return [super numberOfSectionsInTableView:tableView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [super tableView:tableView heightForHeaderInSection:section];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
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





- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
}

#pragma mark - Storyboard Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    [super prepareForSegue:segue sender:sender];
    
}


#pragma mark - UIImagePickerController methods

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    // clear any existing imagePicker
    //    if (self.imagePickerController) {
    //        self.imagePickerController = nil;
    //    }
    
    
    // initialize
    if (!self.imagePickerController) {
        UIImagePickerController *IPC = [self imagePickerControllerForSourceType:sourceType];
        self.imagePickerController = IPC;
        [self presentViewController:IPC animated:YES completion:NULL];
    }
    
    else {
        [self presentViewController:self.imagePickerController animated:YES completion:NULL];
        
    }
    
    //[self presentViewController:imagePickerController animated:YES completion:nil];
}

- (UIImagePickerController *) imagePickerControllerForSourceType: (UIImagePickerControllerSourceType) sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    // set sourceType
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        
        imagePickerController.sourceType = sourceType;
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    else { // if no source is available that we want then don't present
        
        // present an error alert to user
        
        return nil;
    }
    
    
    // set the media types
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePickerController.sourceType];
    NSString *desiredType = (NSString *) kUTTypeImage;
    
    if ([mediaTypes containsObject:desiredType]) {
        imagePickerController.mediaTypes = @[desiredType];
    }
    
    else {
        return nil;
    }
    
    // set mhediting
    imagePickerController.editing = NO;
    
    // set delegate
    imagePickerController.delegate = self;
    
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    //self.imagePickerController.tabBarController.tabBar.hidden = YES;
    
    return imagePickerController;
}



- (void)showImagePickerForCamera:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}


- (void)showImagePickerForPhotoPicker:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}



// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        
        
        UIImage *smallerImage = [UIImage newImageFrom:image scaledToFitHeight:960.0 andWidth:960.0];
        
        self.capturedImages = @[smallerImage];
    }
    
    //UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
    
    
    [self finishAndUpdate];
    
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.imagePickerController == viewController ||
        self.imagePickerController == navigationController) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}



// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    self.mhedCarousel = nil;
    
    if (![self.images count]) {
        self.cameraCanceled = YES;
        [self dismissViewControllerAnimated:YES completion:NULL];
        //[self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
    else
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
    
}

- (void)finishAndUpdate
{
    //    if (self.imagePickerController) {
    //
    //
    //    }
    self.imagePickerController = nil;
    [self dismissViewControllerAnimated:YES completion:^{
        //self.imagePickerController = nil;
    }];
    
    if ([self.capturedImages count] > 0)
    {
        [self.images addObjectsFromArray:self.capturedImages];
        
        for (UIImage *newImage in self.capturedImages) {
            [self.carouselImages addObject:[self convertImageForCarousel:newImage]];
        }
        
        //[self.tableView reloadData];
        //[self performSegueWithIdentifier:@"CameraSegue" sender:self];
        
        self.capturedImages = nil;
        
        [self.mhedCarousel insertItemAtIndex:[self.carouselImages count] - 1 animated:YES];
    }
    
}





//NSData *pngData = UIImagePNGRepresentation(image);
//
//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
//NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
//[pngData writeToFile:filePath atomically:YES]; //Write the file
//
//NSData *pngData = [NSData dataWithContentsOfFile:filePath];
//UIImage *image = [UIImage imageWithData:pngData];


#pragma mark - EDImageButtonCell delegate
- (void) handleTakeAnotherPictureButton: (id) sender
{
    [self showImagePickerForCamera:self];
}

- (void) handleDeletePictureButton:(id)sender
{
    [super handleDeletePictureButton:sender];
}



#pragma mark - EDImageAndNameDelegate and Name Helpers-

- (NSString *) defaultTextForNameTextView
{
    self.objectName = [self objectNameAsDefault];
    self.defaultName = YES;
    return [self objectNameForDisplay];
}

- (BOOL) textViewShouldClear
{
    if (self.defaultName) {
        return YES;
    }
    return NO;
}


- (void) setNameAs: (NSString *) newName
{
    if (newName) {
        self.objectName = newName;
        self.defaultName = NO;
    }
}


- (BOOL) textViewShouldBeginEditing
{
    return [super textViewShouldBeginEditing];
}

- (void) textEnter:(UITextView *)textView
{
    [super textEnter:textView];
    
    
}

- (NSString *) eatDateAsString:(NSDate *) date
{
    return [super eatDateAsString:date];
}

- (NSString *) objectNameAsDefault
{
    return [self mealNameAsDefault];
}

- (NSString *) objectNameForDisplay
{
    return [self mealNameForDisplay];
}

#pragma mark - EDSelectTagsDelegate methods

- (void) addTagsToList: (NSSet *) tags
{
    [super addTagsToList:tags];
}



#pragma mark - EDCreateNewMealDelegate methods




#pragma mark - Setup Methods to call in subclass (optional override)

- (void) setupDateAndDatePickerCell
{
    [super setupDateAndDatePickerCell];
}

- (void) setupObjectName
{
    [super setupObjectName];
}


#pragma mark - Subclass methods to Override

// override numberOfRows, and most other table delegate and data source methods

- (NSArray *) defaultDataArray
{
    self.date1 = [NSDate date];
    
    
    //NSMutableDictionary *largeImageDict = [super largeImageCellDictionary];
    
    //NSMutableDictionary *imageButtonsDict = [super imageButtonCellDictionary];
    
    NSMutableDictionary *mealOrMedDict = [super mealAndMedicationSegmentedControllSectionDictionary];
    
    NSMutableDictionary *reminderDict = [super reminderSectionDictionary];
    
    NSMutableDictionary *detailMealOrMedDict = [super detailMealMedicationSectionDictionary];
    
    
    NSMutableDictionary *dateDict = [super dateSectionDictionary:self.date1];
    
    
    NSMutableDictionary *restaurantDict = [super restaurantSectionDictionary];
    
    NSMutableDictionary *tagsDict = [super tagSectionDictionary];
    
    NSMutableDictionary *showHideDict = [super showHideCellDictionary];
    
    return @[showHideDict, mealOrMedDict, dateDict, restaurantDict, reminderDict, tagsDict, detailMealOrMedDict];
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

- (void) nameTextViewEditable: (UITextView *) textView
{
    [super mealNameTextViewEditable:textView];
    
}


@end
