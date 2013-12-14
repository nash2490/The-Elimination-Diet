//
//  MHEDCarouselAndSummaryViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDSplitCarouselTopViewController.h"

typedef NS_ENUM(NSInteger, MHEDCarouselAndSummaryInputType) {
    MHEDCarouselAndSummaryInputTypeQuickCapture = 1,
    MHEDCarouselAndSummaryInputTypeFillinType
};



extern NSString *const MHEDSplitCarouselAddedPictureToModelNotification;

@interface MHEDCarouselAndSummaryViewController : MHEDSplitCarouselTopViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic) MHEDCarouselAndSummaryInputType inputType;

#pragma mark - Image Capture

@property (nonatomic, weak) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) NSArray *capturedImages;

@property (nonatomic) BOOL cameraCanceled; // says if we just called cancel


#pragma mark - UIImagePickerController methods

- (void)showImagePickerForCamera:(id)sender;
- (UIImagePickerController *) imagePickerControllerForSourceType: (UIImagePickerControllerSourceType) sourceType;

@end
