//
//  MHEDCameraMealCaptureViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/7/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDCarouselImageTableViewController.h"
@class EDRestaurant;



@interface MHEDCameraMealCaptureViewController : MHEDCarouselImageTableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

#pragma mark - Image Capture

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) NSArray *capturedImages;

@property (nonatomic) BOOL cameraCanceled; // says if we just called cancel


#pragma mark - UIImagePickerController methods

- (void)showImagePickerForCamera:(id)sender;
- (UIImagePickerController *) imagePickerControllerForSourceType: (UIImagePickerControllerSourceType) sourceType;

#pragma mark - EDImageButtonCell delegate
- (void) handleTakeAnotherPictureButton: (id) sender;
- (void) handleDeletePictureButton:(id)sender;

#pragma mark - EDSelectTagsDelegate methods

- (void) addTagsToList: (NSSet *) tags;


#pragma mark - Setup Methods to call in subclass (optional override)

/// call in VDL to setup
//- (void) setupDateAndDatePickerCell;
- (void) setupObjectName;

- (NSString *) objectNameForDisplay;
- (NSString *) objectNameAsDefault;

#pragma mark - Subclass methods to Override

// override numberOfRows, and most other table delegate and data source methods

- (NSArray *) defaultDataArray;
- (void) handleDoneButton;

@end
