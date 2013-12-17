//
//  MHEDCarouselAndSummaryViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDCarouselAndSummaryViewController.h"

#import "MHEDMealOptionsViewController.h"

#import "MHEDMealSummaryViewController.h"

#import "UIImage+MHED_fixOrientation.h"

#import "EDEliminatedAPI.h"

#import "EDEatenMeal+Methods.h"

@import MobileCoreServices;


NSString *const MHEDSplitCarouselAddedPictureToModelNotification = @"MHEDSplitCarouselAddedPictureToModel";



@interface MHEDCarouselAndSummaryViewController ()

@end

@implementation MHEDCarouselAndSummaryViewController

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
    if (!self.inputType) {
        self.inputType = MHEDCarouselAndSummaryInputTypeQuickCapture;
        //[super displayQuickCaptureSequenceInContainerLocation:MHEDSplitViewContainerViewLocationBottom];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    if (self.inputType == MHEDCarouselAndSummaryInputTypeFillinType) {
        //[super displayMealFillinViewControllerInContainerLocation:MHEDSplitViewContainerViewLocationBottom];
        
        if (self.navigationController) {
            
            if (self.managedObjectContext) {
                NSFetchRequest *fetchRequest = [EDEatenMeal fetchEatenMealsForLastWeekWithMedication:NO];
                [fetchRequest setFetchLimit:1];

                
                
                
            }
            
            
            [EDEliminatedAPI performBlockWithContext:^(NSManagedObjectContext *context) {
                [self setManagedObjectContext:context];
                
                NSFetchRequest *fetchRequest = [EDEatenMeal fetchEatenMealsForLastWeekWithMedication:NO];
                [fetchRequest setFetchLimit:1];
                
                NSError *error;
                EDEatenMeal *mostRecentEatenMeal = [context executeFetchRequest:fetchRequest error:&error][0];
                
                self.objectsDictionary = [[MHEDObjectsDictionary alloc] initWithDataFromObject:mostRecentEatenMeal];
            }];
            
            
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(handleNextbutton:)]];
        }
    }
}


    

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // the first time we add an image we
    //    if (!self.tableLoaded && !self.imagePickerController) {
    //        self.tableLoaded = YES;
    //        [self.tableView reloadData];
    //    }
    
    //self.imagePickerController.tabBarController.tabBar.hidden = YES;
    
//    if (self.inputType == MHEDCarouselAndSummaryInputTypeQuickCapture) {
//        
//    }
//    
//    else if (self.inputType == MHEDCarouselAndSummaryInputTypeFillinType) {
//        [self updateContainerViewWithMealOptionsViewController];
//    }
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    // the first time we add an image we
    //    if (!self.tableLoaded && !self.imagePickerController) {
    //        self.tableLoaded = YES;
    //        [self.tableView reloadData];
    //    }
    //
    //    if (![self.images count] && !self.cameraCanceled) {
    //        [self showImagePickerForCamera:self];
    //        //[super showImagePickerForCamera:self];
    //    }
    //
    //    else if (self.cameraCanceled) {
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    }
    
    // if we are doing quick capture and haven't added images yet
    if (self.inputType == MHEDCarouselAndSummaryInputTypeQuickCapture && ![self.images count]) {
        [self showImagePickerForCamera:self];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) handleDoneButton:(id)sender
{
    if (self.inputType == MHEDCarouselAndSummaryInputTypeQuickCapture) {
        [self createMeal];
        [self popToHomePage];
    }
    
}

- (void) handleNextButton: (id) sender
{
    
    if (self.inputType == MHEDCarouselAndSummaryInputTypeFillinType) {
        MHEDMealOptionsViewController *mealOptionsVC = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDMealOptions];
        
        mealOptionsVC.dataSource = self;
        
        [self.navigationController pushViewController:mealOptionsVC animated:YES];
    }
    
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
        
//        for (UIImage *newImage in self.capturedImages) {
//            [self.carouselImages addObject:[self convertImageForCarousel:newImage]];
//        }
        
        //[self.tableView reloadData];
        //[self performSegueWithIdentifier:@"CameraSegue" sender:self];
        
        self.capturedImages = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MHEDSplitCarouselAddedPictureToModelNotification
                                                            object:nil];
        
//        [self.mhedCarousel insertItemAtIndex:[self.carouselImages count] - 1 animated:YES];
    }
    
}



#pragma mark - Container Views

- (void) setupContainerViews
{
 
    [super setupContainerViews];
    
    if (self.inputType == MHEDCarouselAndSummaryInputTypeFillinType) {
        // get view controller
        UINavigationController *bottomViewController = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDMealFillinSequence];
        
        MHEDMealSummaryViewController *summaryVC = [bottomViewController viewControllers][0];
        summaryVC.delegate = self;
        
        // display in container view
        [self view:self.mhedBottomView displayContentController:bottomViewController];
        
        //self.mhedMealSummaryVC = summaryVC;
        
    }
    
    else if (self.inputType == MHEDCarouselAndSummaryInputTypeQuickCapture) {
        MHEDMealOptionsViewController *optionVC = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDMealOptions];
        
//        MHEDMealOptionsViewController *optionVC = [bottomViewController viewControllers][0];
        optionVC.dataSource = self;
        
        
        // display in container view
        [self view:self.mhedBottomView displayContentController:optionVC];
        
    }
}


@end
