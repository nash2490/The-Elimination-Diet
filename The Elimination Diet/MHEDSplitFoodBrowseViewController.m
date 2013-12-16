//
//  MHEDSplitFoodBrowseViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDSplitFoodBrowseViewController.h"

#import "MHEDMealSummaryViewController.h"
#import "MHEDBrowseFoodViewController.h"


//#import "mhed"

#import "EDMeal+Methods.h"
#import "EDEatenMeal+Methods.h"

#import "EDMedication+Methods.h"
#import "EDTakenMedication+Methods.h"

#import "EDIngredient+Methods.h"

#import "UIImage+MHED_fixOrientation.h"

@import MobileCoreServices;


// Objects Dictionary keys - use to retrieve arrays from objectsDictionary
NSString *const mhedObjectsDictionaryMealsKey = @"Meals List Key";
NSString *const mhedObjectsDictionaryIngredientsKey = @"Ingredients List Key";
NSString *const mhedObjectsDictionaryMedicationKey = @"Medication List Key";
NSString *const mhedObjectsDictionarySymptomsKey = @"Symptom List Key";


//NSString *const mhedStoryBoardViewControllerIDMealFillinSequence = @"Meal Fill-in Sequence";
//NSString *const mhedStoryBoardViewControllerIDQuickCaptureSequence = @"Quick Capture Sequence";
//
//NSString *const mhedStoryBoardViewControllerIDBottomBrowse = @"MHEDBottomBrowse";
//NSString *const mhedStoryBoardViewControllerIDMealSummary = @"MHEDMealSummary";
//
//NSString *const mhedFoodDataUpdateNotification = @"mhedFoodDataUpdateNotification";


@interface MHEDSplitFoodBrowseViewController ()

@property (nonatomic, weak) MHEDMealSummaryViewController *mhedMealSummaryVC;


@end

@implementation MHEDSplitFoodBrowseViewController


//- (NSDictionary *) objectsDictionary
//{
//    if (!_objectsDictionary) {
//        _objectsDictionary = @{mhedObjectsDictionaryMealsKey : @[],
//                               mhedObjectsDictionaryIngredientsKey : @[],
//                               mhedObjectsDictionaryMedicationKey : @[]};
//    }
//    return _objectsDictionary;
//}


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
    
    [self updateContainerViewWithMealOptionsViewController];
    
    if (self.navigationController) {
        
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(addMealDetails:)]];
        
       // [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDoneButton:)]];
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

    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
}

//- (BOOL)prefersStatusBarHidden
//{
//    if (self.imagePickerController) {
//        return YES;
//    }
//    
//    return NO;
//}



#pragma mark - Segue methods

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@""]) {
        
    }
}

- (void) addMealDetails:(id) sender
{
    // segue to meal options etc.
    
    
}


#pragma mark - Create Meal methods

- (void) handleDoneButton: (id) sender
{
    [self createMeal];
}




#pragma mark - Container View Controller

- (void) updateContainerViewWithMealOptionsViewController
{
    // get view controllers
    MHEDMealSummaryViewController *topViewController = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDMealSummary];
    
    UINavigationController *bottomViewController = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDBottomBrowseSequence];
    
    MHEDBrowseFoodViewController *browseViewController = [bottomViewController viewControllers][0];
    browseViewController.delegate = self;
    topViewController.delegate = self;
    
    // display in container view
    [self view:self.mhedBottomView displayContentController:bottomViewController];
    [self view:self.mhedTopView displayContentController:topViewController];
    
    self.mhedMealSummaryVC = topViewController;
    
}

#pragma mark - 

- (void) updateMealSummaryTable
{
    if (self.mhedMealSummaryVC) {
        [[NSNotificationCenter defaultCenter] postNotificationName:mhedFoodDataUpdateNotification
                                                            object:nil];
    }
}

@end
