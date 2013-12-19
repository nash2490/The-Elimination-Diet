//
//  MHEDSplitViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MHEDFoodSelectionViewController.h"

#import "MHEDObjectsDictionary.h"

#import "MHEDDividerView.h"


extern NSString *const mhedStoryBoardViewControllerIDBottomBrowseSequence;
extern NSString *const mhedStoryBoardViewControllerIDMealSummary;
extern NSString *const mhedStoryBoardViewControllerIDMealOptions;

extern NSString *const mhedStoryBoardViewControllerIDMealFillinSequence;
extern NSString *const mhedStoryBoardViewControllerIDQuickCaptureSequence;

typedef NS_ENUM(NSInteger, MHEDSplitViewContainerViewLocation) {
    MHEDSplitViewContainerViewLocationTop = 1,
    MHEDSplitViewContainerViewLocationBottom,
};


@class EDRestaurant, MHEDSplitViewController;


@protocol MHEDSplitViewControllerDividerDelegate <NSObject>

@optional

- (void) willMoveDivider: (MHEDSplitViewController*) controller;
- (void) didMoveDivider: (MHEDSplitViewController*) controller;

@end


@interface MHEDSplitViewController : UIViewController <MHEDObjectsDictionaryProtocol, MHEDDividerViewDelegate>




@property (nonatomic, weak) id <MHEDSplitViewControllerDividerDelegate> delegate;


//the midpoint of the divider view (x/y depending on orientation)
@property (nonatomic) CGFloat dividerPosition;

//the minimum size (width used when landscape, height used when portrait) for the first view. default is 100, 0
@property (nonatomic) CGSize mhedMinimumViewSize_topView;

//the minimum size (width used when landscape, height used when portrait) for the second view. default is 100, 100
@property (nonatomic) CGSize mhedMinimumViewSize_bottomView;

//@property (weak, nonatomic) IBOutlet UIImageView *mhedDividerImageView;

/// divider position uses the y of showHide view and x of mhedDividerImageView (x of showHide, y of divider if portrait)
- (void) setDividerPosition:(CGFloat)dividerPosition animated:(BOOL)animated;






@property (nonatomic, strong) MHEDObjectsDictionary *objectsDictionary;



@property (nonatomic) BOOL isTopViewHidden;

@property (weak, nonatomic) IBOutlet UIView *mhedTopView;
@property (weak, nonatomic) IBOutlet UIView *mhedBottomView;
@property (weak, nonatomic) IBOutlet MHEDDividerView *mhedDividerView;


- (void) mhedShowHideButtonPress:(id)sender;


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) BOOL keyboardVisible;


// Name
//@property (nonatomic, strong) NSString *objectName;
@property (nonatomic) BOOL defaultName;

// Tags
//@property (nonatomic, strong) NSArray *tagsList;
@property (nonatomic) BOOL favorite;

// Meal Medication Segmented Control
@property (nonatomic) BOOL medication;

// Restaurant
//@property (nonatomic, strong) EDRestaurant *restaurant;

// Objects - Food, medication, symptoms, etc.
//@property (nonatomic, strong) NSDictionary *objectsDictionary;

// Date
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
//@property (nonatomic, strong) NSDate *date1;

//// keep track which indexPath points to the cell with UIDatePicker, if nil then it is NOT visible,
//@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
//@property (nonatomic) NSInteger pickerCellRowHeight;




- (void) popToHomePage;



#pragma mark - Container View Controller Methods

/// override this method in subclasses
- (void) setupContainerViews;

//- (void) handleShowHideButtonPress:(id)sender;

//- (void) displayContentController: (UIViewController*) content;

- (void) view:(UIView *) view displayContentController:(UIViewController *)content;

- (void) displayContentController:(UIViewController *) content inContainerLocation: (MHEDSplitViewContainerViewLocation) location;

- (void) displayMealFillinViewControllerInContainerLocation: (MHEDSplitViewContainerViewLocation) location;

- (void) displayMealSummaryViewControllerInContainerLocation:(MHEDSplitViewContainerViewLocation) location;

- (void) displayBottomBrowseViewControllerInContainerLocation:(MHEDSplitViewContainerViewLocation) location;

- (void) displayQuickCaptureSequenceInContainerLocation:(MHEDSplitViewContainerViewLocation) location;


#pragma mark - MHEDFoodSelectionViewControllerDataSource methods

//- (NSArray *) mealsList;
//- (void) setNewMealsList: (NSArray *) newMealsList;
//- (void) addToMealsList: (NSArray *) meals;
//- (void) removeMealsFromMealsList: (NSArray *) meals;
//- (BOOL) doesMealsListContainMeals:(NSArray *) meals;
//
//- (NSArray *) ingredientsList;
//- (void) setNewIngredientsList: (NSArray *) newIngredientsList;
//- (void) addToIngredientsList: (NSArray *) ingredients;
//- (void) removeIngredientsFromIngredientsList: (NSArray *) ingredients;
//- (BOOL) doesIngredientsListContainIngredients:(NSArray *) ingredients;
//
//- (NSArray *) medicationsList;
//- (void) setNewMedicationsList: (NSArray *) newMedicationsList;
//- (void) addToMedicationsList: (NSArray *) medications;
//- (void) removeMedicationsFromMedicationsList: (NSArray *) medications;
//- (BOOL) doesMedicationsListContainMedications:(NSArray *) medications;


#pragma mark - MHEDObjectsDictionaryProtocol and helper methods

- (MHEDObjectsDictionary *) objectsDictionary;

- (NSArray *) mealsList;
- (NSArray *) ingredientsList;
- (NSArray *) medicationsList;
- (NSArray *) tagsList;
- (EDRestaurant *) restaurant;
- (NSArray *) imagesList;
- (NSDate *) date;
- (NSString *) objectName;



#pragma mark - Create Meal Methods

- (void) handleDoneButton: (id) sender;

- (void) createMeal;


#pragma mark -


@end
