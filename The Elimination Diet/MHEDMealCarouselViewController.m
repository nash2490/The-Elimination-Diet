//
//  MHEDMealCarouselViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/11/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDMealCarouselViewController.h"

#import "EDMeal+Methods.h"
#import "EDEatenMeal+Methods.h"

#import "EDMedication+Methods.h"
#import "EDTakenMedication+Methods.h"

#import "EDIngredient+Methods.h"

#import "UIImage+MHED_fixOrientation.h"

@import MobileCoreServices;


// Objects Dictionary keys - use to retrieve arrays from objectsDictionary
static NSString *mhedObjectsDictionaryMealsKey = @"Meals List Key";
static NSString *mhedObjectsDictionaryIngredientsKey = @"Ingredients List Key";
static NSString *mhedObjectsDictionaryMedicationKey = @"Medication List Key";
static NSString *mhedObjectsDictionarySymptomsKey = @"Symptom List Key";


static NSString *mhedStoryBoardViewControllerIDMealFillinSequence = @"Meal Fill-in Sequence";
static NSString *mhedStoryBoardViewControllerIDQuickCaptureSequence = @"Quick Capture Sequence";

@interface MHEDMealCarouselViewController ()

//@property (nonatomic) BOOL tableLoaded; // yes if the table was loaded

@end

@implementation MHEDMealCarouselViewController

- (NSArray *) capturedImages
{
    if (!_capturedImages) {
        _capturedImages = [[NSArray alloc] init];
    }
    return _capturedImages;
}

- (NSDictionary *) objectsDictionary
{
    if (!_objectsDictionary) {
        _objectsDictionary = @{mhedObjectsDictionaryMealsKey : @[],
                               mhedObjectsDictionaryIngredientsKey : @[],
                               mhedObjectsDictionaryMedicationKey : @[]};
    }
    return _objectsDictionary;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (!self.inputType) {
        self.inputType = MHEDMealCarouselInputTypeQuickCapture;
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
    
    if (self.inputType == MHEDMealCarouselInputTypeQuickCapture) {
        
    }
    
    else if (self.inputType == MHEDMealCarouselInputTypeFillinType) {
        [self updateContainerViewWithMealOptionsViewController];
    }
    
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
    if (self.inputType == MHEDMealCarouselInputTypeQuickCapture && ![self.images count]) {
        [self showImagePickerForCamera:self];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    self.imagePickerController = nil;
}

- (BOOL)prefersStatusBarHidden
{
    if (self.imagePickerController) {
        return YES;
    }
    
    return NO;
}


#pragma mark - Create Meal methods

- (void) handleDoneButton: (id) sender
{
    [self createMeal];
}


- (void) createMeal
{
    if ([self.mealsList count] == 1 && [self.ingredientsList count] == 0)
    {
        // also should check the restaurant
        // but anyways, this means we don't need to create a new meal
        
        
        [self.managedObjectContext performBlockAndWait:^{
            [EDEatenMeal createEatenMealWithMeal:self.mealsList[0] atTime:self.date1 forContext:self.managedObjectContext];
            
        }];
        
    }
    
    else 
    { // we need to create a new new meal first
        [self.managedObjectContext performBlockAndWait:^{
            EDMeal *newMeal = [EDMeal createMealWithName:self.objectName
                                        ingredientsAdded:[NSSet setWithArray:self.ingredientsList]
                                             mealParents:[NSSet setWithArray:self.mealsList]
                                              restaurant:self.restaurant tags:nil
                                              forContext:self.managedObjectContext];
            
            if ([self.images count]) {
                [newMeal addUIImagesToFood:[NSSet setWithArray:self.images] error:nil];
            }
            
            
            [EDEatenMeal createEatenMealWithMeal:newMeal atTime:self.date1 forContext:self.managedObjectContext];
        }];
    }
}




#pragma mark - MHEDFoodSelectionViewControllerDataSource methods -
// default method options


- (void) setNewRestaurant:(EDRestaurant *)restaurant
{
    if (restaurant) {
        self.restaurant = restaurant;
    }
}

- (NSArray *) tagsList
{
    if (!_tagsList) {
        _tagsList = [[NSArray alloc] init];
    }
    return _tagsList;
}

- (void) addToTagsList: (NSArray *) tags
{
    if (tags) {
        self.tagsList = [self.tagsList arrayByAddingObjectsFromArray:tags];
    }
}

- (void) setNewTagsList: (NSArray *) newTagsList
{
    if (newTagsList) {
        self.tagsList = newTagsList;
    }
}


- (NSArray *) mealsList
{
    //    if (!_mealsList) {
    //        _mealsList = [[NSArray alloc] init];
    //    }
    //    return _mealsList;
    
    return self.objectsDictionary[mhedObjectsDictionaryMealsKey];
    
}

- (void) setNewMealsList: (NSArray *) newMealsList
{
    //    if (newMealsList) {
    //        self.mealsList = newMealsList;
    //    }
    
    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
    [mutObjectsDictionary setObject:[newMealsList copy] forKey:mhedObjectsDictionaryMealsKey];
    
    self.objectsDictionary = [mutObjectsDictionary copy];
}

- (void) addToMealsList: (NSArray *) meals
{
    //    if (meals) {
    //        self.mealsList = [self.mealsList arrayByAddingObjectsFromArray:meals];
    //        for (EDTag *tag in [meals[0] tags]) {
    //            NSLog(@"tag name = %@", tag.name);
    //        }
    //    }
    
    
    NSArray *oldList = self.objectsDictionary[mhedObjectsDictionaryMealsKey];
    NSArray *newList = [oldList arrayByAddingObjectsFromArray:meals];
    
    [self setNewMealsList:newList];
}

- (void) removeMealsFromMealsList: (NSArray *) meals
{
    NSArray *oldList = self.objectsDictionary[mhedObjectsDictionaryMealsKey];
    NSMutableArray *mutOldList = [oldList mutableCopy];
    [mutOldList removeObjectsInArray:meals];
    
    [self setNewMealsList:mutOldList];
}


- (BOOL) doesMealsListContainMeals:(NSArray *) meals
{
    BOOL contains = YES;
    for (EDMeal *meal in meals) {
        if ([meal isKindOfClass:[EDMeal class]]) {
            contains = (contains && [[self mealsList] containsObject:meal]);
        }
        else {
            contains = NO;
        }
    }
    return contains;
}



- (NSArray *) ingredientsList
{
    //    if (!_ingredientsList) {
    //        _ingredientsList = [[NSArray alloc] init];
    //    }
    //    return _ingredientsList;
    
    return self.objectsDictionary[mhedObjectsDictionaryIngredientsKey];
}




- (void) setNewIngredientsList: (NSArray *) newIngredientsList
{
    //    if (newIngredientsList) {
    //        self.ingredientsList = newIngredientsList;
    //    }
    
    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
    [mutObjectsDictionary setObject:[newIngredientsList copy] forKey:mhedObjectsDictionaryIngredientsKey];
    
    self.objectsDictionary = [mutObjectsDictionary copy];
}




- (void) addToIngredientsList: (NSArray *) ingredients
{
    //    if (ingredients) {
    //        self.ingredientsList = [self.ingredientsList arrayByAddingObjectsFromArray:ingredients];
    //    }
    
    NSArray *oldList = [self ingredientsList];
    NSArray *newList = [oldList arrayByAddingObjectsFromArray:ingredients];
    
    [self setNewIngredientsList:newList];
}


- (void) removeIngredientsFromIngredientsList:(NSArray *)ingredients
{
    NSArray *oldList = [self ingredientsList];
    NSMutableArray *mutOldList = [oldList mutableCopy];
    [mutOldList removeObjectsInArray:ingredients];
    
    [self setNewIngredientsList:mutOldList];
}


- (BOOL) doesIngredientsListContainIngredients:(NSArray *)ingredients
{
    BOOL contains = YES;
    for (EDIngredient *ingr in ingredients) {
        if ([ingr isKindOfClass:[EDIngredient class]]) {
            contains = (contains && [[self ingredientsList] containsObject:ingr]);
        }
        else {
            contains = NO;
        }
    }
    return contains;
}



- (NSArray *) medicationsList
{
    return self.objectsDictionary[mhedObjectsDictionaryMedicationKey];
}

- (void) setNewMedicationsList: (NSArray *) newMedicationsList
{
    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
    [mutObjectsDictionary setObject:[newMedicationsList copy] forKey:mhedObjectsDictionaryMedicationKey];
    
    self.objectsDictionary = [mutObjectsDictionary copy];
}

- (void) addToMedicationsList: (NSArray *) medications
{
    NSArray *oldList = [self medicationsList];
    NSArray *newList = [oldList arrayByAddingObjectsFromArray:medications];
    
    [self setNewMedicationsList:newList];
}

- (void) removeMedicationsFromMedicationsList:(NSArray *)medications
{
    NSArray *oldList = [self medicationsList];
    NSMutableArray *mutOldList = [oldList mutableCopy];
    [mutOldList removeObjectsInArray:medications];
    
    [self setNewMedicationsList:mutOldList];
}

- (BOOL) doesMedicationsListContainMedications:(NSArray *)medications
{
    BOOL contains = YES;
    for (EDMedication *medication in medications) {
        if ([medication isKindOfClass:[EDMedication class]]) {
            contains = (contains && [[self medicationsList] containsObject:medication]);
        }
        else {
            contains = NO;
        }
    }
    return contains;
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
    }
}


#pragma mark - Segue methods

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@""]) {
        
    }
}



#pragma mark - Container View Controller

- (void) updateContainerViewWithMealOptionsViewController
{
    // get view controller
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDMealFillinSequence];
    //UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BrowseFoodViewController"];
    
    
    // display in container view
    [self displayContentController:viewController];
    
//    viewController.view.frame = self.mhedBottomContainerView.bounds;
//    
//    [viewController willMoveToParentViewController:self];
//    [self.mhedBottomContainerView addSubview:viewController.view];
//    [self addChildViewController:viewController];
//    [viewController didMoveToParentViewController:self];
    
    
}

@end
