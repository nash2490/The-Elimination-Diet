//
//  EDCameraViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/8/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDCameraViewController.h"

#import "EDBasicPhotoCreateViewController.h"

@import MobileCoreServices;

@interface EDCameraViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) UIImagePickerController *imagePickerController;

//@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic, strong) NSArray *capturedImages;

@end

@implementation EDCameraViewController

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
    
    self.capturedImages = [[NSArray alloc] init];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.imagePickerController) {
        [self showImagePickerForCamera:self];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark - Image Picker methods

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;

    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;

    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        
        imagePickerController.sourceType = sourceType;
    }
    
    else {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    for (NSString *mediaType in mediaTypes) {
        if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
            == kCFCompareEqualTo) {
            imagePickerController.mediaTypes = @[mediaType];
        }
    }
    
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}



#pragma mark - UINavigationController delegate methods




#pragma mark - UIImagePickerController delegate methods

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
        
        self.capturedImages = [self.capturedImages arrayByAddingObject:image];
    }
   
    
    //UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);

    
    [self finishAndUpdate];

}






// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self dismissViewControllerAnimated:NO completion:^{
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }];
}

- (void)finishAndUpdate
{
    if (self.imagePickerController) {
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.capturedImages count] > 0)
            {
                [self performSegueWithIdentifier:@"CameraSegue" sender:self];
            }
        }];
    }
    
    
    
}



#pragma mark - Segue methods

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CameraSegue"]) {
        EDBasicPhotoCreateViewController *destinationVC = segue.destinationViewController;
        
// for now i just reset the images, will need delegate to keep images and other info
        destinationVC.images = [self.capturedImages copy];
        
        // To be ready to start again, clear the captured images array.
        //[self.capturedImages removeAllObjects];
    }
}


@end
