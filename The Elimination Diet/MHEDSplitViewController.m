//
//  MHEDSplitViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDSplitViewController.h"

#import "MHEDDividerView.h"

#import "MHEDMealSummaryViewController.h"

#import "EDMeal+Methods.h"
#import "EDEatenMeal+Methods.h"

#import "EDMedication+Methods.h"
#import "EDTakenMedication+Methods.h"

#import "EDIngredient+Methods.h"

#import "UIImage+MHED_fixOrientation.h"

#import "UIView+MHED_AdjustView.h"

#import "EDEliminatedAPI.h"

#import "MHEDDividerGestureRecognizer.h"

@import MobileCoreServices;

static double mhedSplitViewDefaultHeightForTopView = 282.0;




NSString *const mhedStoryBoardViewControllerIDMealFillinSequence = @"Meal Fill-in Sequence";
NSString *const mhedStoryBoardViewControllerIDQuickCaptureSequence = @"Quick Capture Sequence";

NSString *const mhedStoryBoardViewControllerIDBottomBrowseSequence = @"MHEDBottomBrowse";
NSString *const mhedStoryBoardViewControllerIDMealSummary = @"MHEDMealSummary";

NSString *const mhedStoryBoardViewControllerIDMealOptions = @"MealOptionsViewController";



@interface MHEDSplitViewController ()

@property (nonatomic, weak) MHEDMealSummaryViewController *mhedMealSummaryVC;

@property (nonatomic) CGFloat mhedTopViewHeight;

@property (nonatomic) BOOL handlingMove;
@property (nonatomic) CGPoint priorPoint;


@end


@implementation MHEDSplitViewController


- (MHEDObjectsDictionary *) objectsDictionary
{
    if (!_objectsDictionary) {
        _objectsDictionary = [[MHEDObjectsDictionary alloc] initWithDefaults];
    }
    return _objectsDictionary;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self mhedInitializeSplitViewController];
    }
    return self;
}


- (void) awakeFromNib
{
    [super awakeFromNib];
    [self mhedInitializeSplitViewController];
    
}

- (void) mhedInitializeSplitViewController
{
    self.mhedMinimumViewSize_topView = CGSizeMake(100, 0);
    self.mhedMinimumViewSize_bottomView = CGSizeMake(100, 100);
}

- (void) mhedDividerViewSetup
{
    self.mhedDividerView.delegate = self;
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveDivider:)];
    
    longPressRecognizer.allowableMovement = 300.0;
    longPressRecognizer.minimumPressDuration = 0.2;
    
    [self.mhedDividerView addGestureRecognizer:longPressRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDivider:)];
    [self.mhedDividerView addGestureRecognizer:tapRecognizer];
    
    //[longPressRecognizer requireGestureRecognizerToFail:tapRecognizer];
    
    // add gesture recognizer
    
//    MHEDDividerGestureRecognizer *dividerGesture = [[MHEDDividerGestureRecognizer alloc] initWithTarget:self action:@selector(mhedMoveDivider:)];
//    [self.mhedDividerView addGestureRecognizer:dividerGesture];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self mhedDividerViewSetup];
    [self setupContainerViews];
    
    if (!self.managedObjectContext) {
        [EDEliminatedAPI performBlockWithContext:^(NSManagedObjectContext *context) {
            if (context) {
                self.managedObjectContext = context;
            }
        }];
    }
    
    if (self.navigationController) {
        
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDoneButton:)]];
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(popToHomePage)];
        
        leftBarButton.tintColor = [UIColor redColor];
        [self.navigationItem setLeftBarButtonItem:leftBarButton animated:NO];
    }
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    // setup divider
    
    // find divider location
    // divider position uses the y of showHide view and x of mhedDividerImageView (x of showHide, y of divider if portrait)

    
    

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Layout and Adjusting

- (IBAction)mhedShowHideButtonPress:(id)sender {
    if (self.mhedTopView.frame.size.height < 50.0) {
        //self.isTopViewHidden = NO;
        
        // animate Open
        
        self.mhedTopViewHeight = MAX(self.mhedTopViewHeight, 100.0);
        
        CGFloat duration = (self.mhedTopViewHeight * 0.002);
        
        [UIView animateWithDuration:duration
                              delay: 0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             [self.mhedTopView mhedSetFrameHeight: self.mhedTopViewHeight];
                             [self.mhedDividerView mhedSetOriginY: CGRectGetMaxY(self.mhedTopView.frame)];
                             [self.mhedBottomView mhedSetOriginY: CGRectGetMaxY(self.mhedDividerView.frame)];
                             
                             //[self.mhedBottomView mhedSetFrameHeight:CGRectGetHeight(self.mhedBottomView.frame) + mhedSplitViewDefaultHeightForTopView];
                         }
                         completion:^(BOOL finished){
                             
                             [UIView animateWithDuration:0.0
                                                   delay: 0.0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  
                                                  [self.mhedBottomView mhedSetFrameHeight:CGRectGetHeight(self.mhedBottomView.frame) - self.mhedTopViewHeight];
                                              }
                                              completion: ^(BOOL finished){
                                                  
                                                  
                                              }];
                         }];
        
    }
    
    else if (self.mhedTopView.frame.size.height >= 50) {
        
        //self.isTopViewHidden = YES;
        
        // animate close;
        // ---------
        // self.mhedTopView.frame.height = 0.0
        // self.mhedShowHideView.frame.y = 0.0
        // self.mhedBottomView.frame.y = self.mhedShowHideView.frame.height
        // self.mhedBottomView.frame.height = self.mhedBottomView.frame.height + mhedSplitViewDefaultHeightForTopView
        
        // Do I also need to change the autolayout things?
        //      - think i would only need to do that if viewWillLayoutSubviews gets called again, does it ?
        
        
//        [UIView animateWithDuration:0.5
//                              delay: 0.0
//                            options: UIViewAnimationOptionCurveEaseIn
//                         animations:^{
//                             
//                             self.mhedTopView.alpha = 0.0;
//                             
//                         }
//                         completion:^(BOOL finished){
//                             // Wait one second and then fade in the view
//                             
//                         }];
        
//        [UIView animateWithDuration:5.0
//                              delay: 0.5
//                            options:UIViewAnimationOptionCurveEaseOut
//                         animations:^{
//                             
//                             [self.mhedTopView mhedSetFrameHeight: 0.0];
//                             [self.mhedShowHideView mhedSetOriginY: CGRectGetMaxY(self.mhedTopView.frame)];
//                             [self.mhedBottomView mhedSetOriginY: CGRectGetMaxY(self.mhedShowHideView.frame)];
//                             //[self.mhedBottomView mhedSetFrameHeight:CGRectGetHeight(self.mhedBottomView.frame) + mhedSplitViewDefaultHeightForTopView];
//                         }
//                         completion:nil];
        
        self.mhedTopViewHeight = MAX( self.mhedTopView.frame.size.height, 100.0);
        
        [UIView animateWithDuration:0.0
                              delay: 0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                        
                             [self.mhedBottomView mhedSetFrameHeight:CGRectGetHeight(self.mhedBottomView.frame) + CGRectGetHeight(self.mhedTopView.frame)];
                         }
                         completion: ^(BOOL finished){
                             
                             CGFloat duration = (self.mhedTopView.frame.size.height * 0.002);
                             
                             [UIView animateWithDuration:duration
                                                   delay: 0.1
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  
                                                  [self.mhedTopView mhedSetFrameHeight: 0.0];
                                                  [self.mhedDividerView mhedSetOriginY: CGRectGetMaxY(self.mhedTopView.frame)];
                                                  [self.mhedBottomView mhedSetOriginY: CGRectGetMaxY(self.mhedDividerView.frame)];
                                                  //[self.mhedBottomView mhedSetFrameHeight:CGRectGetHeight(self.mhedBottomView.frame) + mhedSplitViewDefaultHeightForTopView];
                                              }
                                              completion:nil];
                         }];
        
    }
}



#pragma mark - Divider Delegate and related


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)moveDivider:(UILongPressGestureRecognizer *)sender {
    UIView *view = sender.view;
    CGPoint point = [sender locationInView:view.superview];
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint center = view.center;
        
        
        //center.x += point.x - self.priorPoint.x;
        center.y += point.y - self.priorPoint.y;
        //view.center = center;
        
        if (center.y >= [self.topLayoutGuide length] + [self dividerLength] / 2) {
            //NSLog(@"new center will be %f", center.y);
            [self setDividerPosition:center.y];
            
        }
        
    }
    self.priorPoint = point;
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
#warning change this to look nicer
        // change background color
        [sender.view setBackgroundColor:[UIColor blueColor]];
    }
    else if (sender.state == UIGestureRecognizerStateEnded ||
             sender.state == UIGestureRecognizerStateFailed ||
             sender.state == UIGestureRecognizerStateCancelled) {
        
        [sender.view setBackgroundColor:[UIColor whiteColor]];
    }
    
//    NSLog(@"prior point.y = %f", point.y);
//    NSLog(@"long press state = %i", sender.state);
}

- (void) tapDivider:(UITapGestureRecognizer *) sender
{
    [self mhedShowHideButtonPress:sender];
}


-(void)dividerView:(MHEDDividerView*) dividerView moveByOffset:(CGFloat)offset
{
    
    NSLog(@"offset = %f", offset);

    
    BOOL isLand = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
    CGRect dividerRect = dividerView.frame;
    
    //validate the offset is in the acceptable range
    CGFloat curLoc = isLand ? self.mhedDividerView.frame.origin.x : self.mhedDividerView.frame.origin.y;
    CGFloat newLoc = curLoc + offset;
    CGFloat minOffset = isLand ? self.mhedMinimumViewSize_topView.width : self.mhedMinimumViewSize_topView.height;
    CGFloat maxOffset = isLand ? self.view.bounds.size.width : self.view.bounds.size.height;
    maxOffset -= isLand ? self.mhedMinimumViewSize_bottomView.width : self.mhedMinimumViewSize_bottomView.height;
    if (newLoc < minOffset)
        offset = 0;
    if (newLoc > maxOffset)
        offset = maxOffset - curLoc;
    if (offset == 0)
        return;
    
    CGRect r1 = self.mhedTopView.frame;
    CGRect r2 = self.mhedBottomView.frame;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        dividerRect.origin.x = dividerRect.origin.x + offset;
        r1.size.width += offset;
        r2.origin.x += offset;
        r2.size.width = self.view.bounds.size.width - r2.origin.x;
    } else {
        dividerRect.origin.y = dividerRect.origin.y + offset;
        r1.size.height += offset;
        r2.origin.y += offset;
        r2.size.height = self.view.bounds.size.height - r2.origin.y;
    }
    dividerView.frame = dividerRect;
    self.mhedTopView.frame = r1;
    self.mhedTopViewHeight = self.mhedTopView.frame.size.height;
    self.mhedBottomView.frame = r2;
    
    [self.view setNeedsDisplay];
}


- (CGFloat) dividerLength
{
    if ((UIInterfaceOrientationIsLandscape(self.interfaceOrientation))) {
        return self.mhedDividerView.frame.size.width;
    }
    
    return self.mhedDividerView.frame.size.height;
}

-(CGFloat)dividerPosition
{
    if ((UIInterfaceOrientationIsLandscape(self.interfaceOrientation))) {
        return self.mhedDividerView.frame.origin.x + floorf([self dividerLength] / 2);
    }
    
    return self.mhedDividerView.frame.origin.y + floorf([self dividerLength] / 2);
}

-(void)setDividerPosition:(CGFloat)dividerPosition
{
    [self setDividerPosition:dividerPosition animated:NO];
}

-(void)setDividerPosition:(CGFloat)dividerPosition animated:(BOOL)animated
{
    CGFloat offset = dividerPosition;
    
    if ((UIInterfaceOrientationIsLandscape(self.interfaceOrientation))) {
        offset -= self.mhedDividerView.frame.origin.x;
    }
    else {
        offset -= self.mhedDividerView.frame.origin.y;
    }
    
    [self dividerView:self.mhedDividerView moveByOffset:offset - floorf([self dividerLength] / 2)];
}



#pragma mark - Container View Controller


- (void) setupContainerViews
{
    
    //[self updateContainerViewWithMealOptionsViewController];
}

- (void) updateContainerViewWithMealOptionsViewController
{
    // get view controller
    UIViewController *bottomViewController = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDBottomBrowseSequence];
    
    MHEDMealSummaryViewController *topViewController = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDMealSummary];
    
    
    
    // display in container view
    [self view:self.mhedBottomView displayContentController:bottomViewController];
    [self view:self.mhedTopView displayContentController:topViewController];
    
    self.mhedMealSummaryVC = topViewController;
    
}



- (void) view:(UIView *)view displayContentController:(UIViewController *)content
{
    [content willMoveToParentViewController:self];
    
    [self addChildViewController:content];
    
    content.view.frame = [view bounds];
    
    [view addSubview:content.view];
    
    [content didMoveToParentViewController:self];
}


- (void) displayContentController:(UIViewController *)content inContainerLocation:(MHEDSplitViewContainerViewLocation)location
{
    if (MHEDSplitViewContainerViewLocationTop == location) {
        [self view:self.mhedTopView displayContentController:content];
    }
    
    else if (MHEDSplitViewContainerViewLocationBottom == location) {
        [self view:self.mhedBottomView displayContentController:content];
    }
}


- (void) displayMealFillinViewControllerInContainerLocation: (MHEDSplitViewContainerViewLocation) location
{
    UINavigationController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDMealFillinSequence];
    
    MHEDMealSummaryViewController *summaryVC = [contentVC viewControllers][0];
    summaryVC.delegate = self;
    
    [self displayContentController:contentVC inContainerLocation:location];
}

- (void) displayMealSummaryViewControllerInContainerLocation:(MHEDSplitViewContainerViewLocation) location
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDMealSummary];
    
    [self displayContentController:vc inContainerLocation: location];
}

- (void) displayBottomBrowseViewControllerInContainerLocation:(MHEDSplitViewContainerViewLocation) location
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDBottomBrowseSequence];
    
    [self displayContentController:vc inContainerLocation: location];
}

- (void) displayQuickCaptureSequenceInContainerLocation:(MHEDSplitViewContainerViewLocation) location
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:mhedStoryBoardViewControllerIDQuickCaptureSequence];
    
    [self displayContentController:vc inContainerLocation: location];
}

#pragma mark - Create Meal methods

- (void) handleDoneButton: (id) sender
{
    [self createMeal];
    [self popToHomePage];
}


- (void) createMeal
{
    [self.objectsDictionary createMealInContext:self.managedObjectContext];
}



#pragma mark - MHEDFoodSelectionViewControllerDataSource methods -
// default method options


//- (void) setNewRestaurant:(EDRestaurant *)restaurant
//{
//    if (restaurant) {
//        self.restaurant = restaurant;
//    }
//}
//
//- (NSArray *) tagsList
//{
//    if (!_tagsList) {
//        _tagsList = [[NSArray alloc] init];
//    }
//    return _tagsList;
//}
//
//- (void) addToTagsList: (NSArray *) tags
//{
//    if (tags) {
//        self.tagsList = [self.tagsList arrayByAddingObjectsFromArray:tags];
//    }
//}
//
//- (void) setNewTagsList: (NSArray *) newTagsList
//{
//    if (newTagsList) {
//        self.tagsList = newTagsList;
//    }
//}
//
//
//- (NSArray *) mealsList
//{
//    //    if (!_mealsList) {
//    //        _mealsList = [[NSArray alloc] init];
//    //    }
//    //    return _mealsList;
//    
//    return self.objectsDictionary[mhedObjectsDictionaryMealsKey];
//    
//}
//
//- (void) setNewMealsList: (NSArray *) newMealsList
//{
//    //    if (newMealsList) {
//    //        self.mealsList = newMealsList;
//    //    }
//    
//    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
//    [mutObjectsDictionary setObject:[newMealsList copy] forKey:mhedObjectsDictionaryMealsKey];
//    
//    self.objectsDictionary = [mutObjectsDictionary copy];
//    [self updateMealSummaryTable];
//}
//
//- (void) addToMealsList: (NSArray *) meals
//{
//    //    if (meals) {
//    //        self.mealsList = [self.mealsList arrayByAddingObjectsFromArray:meals];
//    //        for (EDTag *tag in [meals[0] tags]) {
//    //            NSLog(@"tag name = %@", tag.name);
//    //        }
//    //    }
//    
//    
//    NSArray *oldList = self.objectsDictionary[mhedObjectsDictionaryMealsKey];
//    NSArray *newList = [oldList arrayByAddingObjectsFromArray:meals];
//    
//    [self setNewMealsList:newList];
//}
//
//- (void) removeMealsFromMealsList: (NSArray *) meals
//{
//    NSArray *oldList = self.objectsDictionary[mhedObjectsDictionaryMealsKey];
//    NSMutableArray *mutOldList = [oldList mutableCopy];
//    [mutOldList removeObjectsInArray:meals];
//    
//    [self setNewMealsList:mutOldList];
//}
//
//
//- (BOOL) doesMealsListContainMeals:(NSArray *) meals
//{
//    BOOL contains = YES;
//    for (EDMeal *meal in meals) {
//        if ([meal isKindOfClass:[EDMeal class]]) {
//            contains = (contains && [[self mealsList] containsObject:meal]);
//        }
//        else {
//            contains = NO;
//        }
//    }
//    return contains;
//}
//
//
//
//- (NSArray *) ingredientsList
//{
//    //    if (!_ingredientsList) {
//    //        _ingredientsList = [[NSArray alloc] init];
//    //    }
//    //    return _ingredientsList;
//    
//    return self.objectsDictionary[mhedObjectsDictionaryIngredientsKey];
//}
//
//
//
//
//- (void) setNewIngredientsList: (NSArray *) newIngredientsList
//{
//    //    if (newIngredientsList) {
//    //        self.ingredientsList = newIngredientsList;
//    //    }
//    
//    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
//    [mutObjectsDictionary setObject:[newIngredientsList copy] forKey:mhedObjectsDictionaryIngredientsKey];
//    
//    self.objectsDictionary = [mutObjectsDictionary copy];
//    [self updateMealSummaryTable];
//}
//
//
//
//
//- (void) addToIngredientsList: (NSArray *) ingredients
//{
//    //    if (ingredients) {
//    //        self.ingredientsList = [self.ingredientsList arrayByAddingObjectsFromArray:ingredients];
//    //    }
//    
//    NSArray *oldList = [self ingredientsList];
//    NSArray *newList = [oldList arrayByAddingObjectsFromArray:ingredients];
//    
//    [self setNewIngredientsList:newList];
//}
//
//
//- (void) removeIngredientsFromIngredientsList:(NSArray *)ingredients
//{
//    NSArray *oldList = [self ingredientsList];
//    NSMutableArray *mutOldList = [oldList mutableCopy];
//    [mutOldList removeObjectsInArray:ingredients];
//    
//    [self setNewIngredientsList:mutOldList];
//}
//
//
//- (BOOL) doesIngredientsListContainIngredients:(NSArray *)ingredients
//{
//    BOOL contains = YES;
//    for (EDIngredient *ingr in ingredients) {
//        if ([ingr isKindOfClass:[EDIngredient class]]) {
//            contains = (contains && [[self ingredientsList] containsObject:ingr]);
//        }
//        else {
//            contains = NO;
//        }
//    }
//    return contains;
//}
//
//
//
//- (NSArray *) medicationsList
//{
//    return self.objectsDictionary[mhedObjectsDictionaryMedicationKey];
//}
//
//- (void) setNewMedicationsList: (NSArray *) newMedicationsList
//{
//    NSMutableDictionary *mutObjectsDictionary = [self.objectsDictionary mutableCopy];
//    [mutObjectsDictionary setObject:[newMedicationsList copy] forKey:mhedObjectsDictionaryMedicationKey];
//    
//    self.objectsDictionary = [mutObjectsDictionary copy];
//    [self updateMealSummaryTable];
//    
//}
//
//- (void) addToMedicationsList: (NSArray *) medications
//{
//    NSArray *oldList = [self medicationsList];
//    NSArray *newList = [oldList arrayByAddingObjectsFromArray:medications];
//    
//    [self setNewMedicationsList:newList];
//}
//
//- (void) removeMedicationsFromMedicationsList:(NSArray *)medications
//{
//    NSArray *oldList = [self medicationsList];
//    NSMutableArray *mutOldList = [oldList mutableCopy];
//    [mutOldList removeObjectsInArray:medications];
//    
//    [self setNewMedicationsList:mutOldList];
//}
//
//- (BOOL) doesMedicationsListContainMedications:(NSArray *)medications
//{
//    BOOL contains = YES;
//    for (EDMedication *medication in medications) {
//        if ([medication isKindOfClass:[EDMedication class]]) {
//            contains = (contains && [[self medicationsList] containsObject:medication]);
//        }
//        else {
//            contains = NO;
//        }
//    }
//    return contains;
//}



#pragma mark - MHEDObjectsDictionaryProtocol and helper methods
// default method options

- (NSArray *) mealsList
{
    return [self.objectsDictionary mealsList];
}

- (NSArray *) ingredientsList
{
    return [self.objectsDictionary ingredientsList];
}

- (NSArray *) medicationsList {
    return [self.objectsDictionary medicationsList];
}

- (NSArray *) tagsList
{
    return [self.objectsDictionary tagsList];
}

- (EDRestaurant *) restaurant
{
    return [self.objectsDictionary restaurant];
}

- (NSArray *) imagesList
{
    return [self.objectsDictionary imagesArray];
}

- (NSDate *) date
{
    return [self.objectsDictionary date];
}

- (NSString *) objectName
{
    return [self.objectsDictionary objectName];
}








#pragma mark - Segue methods

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@""]) {
        
    }
}

- (void) popToHomePage
{
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
