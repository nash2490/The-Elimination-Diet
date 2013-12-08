//
//  MHEDTableViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/7/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

// custom cells
#import "EDImageAndNameCell.h"
#import "EDTagCell.h"
#import "EDLargeImageCell.h"


// important protocols
#import "EDSelectTagsViewController.h"
#import "EDMealAndMedicationSegmentedControlCell.h"
#import "EDImageButtonCell.h"
#import "EDShowHideCell.h"

//#import "iCarousel.h"

static double mhedCarouselCellDefaultSize = 250.0;
static double mhedCarouselImageMaxHeight = 200.0;
static double mhedCarouselImageMaxWidth = 280.0;

static double mhedPickerAnimationDuration = 0.40;  // duration for the animation to slide the date picker into view
static double mhedDatePickerTag = 99;    // view tag identifiying the date picker view



//
static NSString *mhedDateCellID = @"DateCell";     // the cells with the start or end date
static NSString *mhedDatePickerID = @"DatePicker"; // the cell containing the date picker

static NSString *mhedValueCellID = @"ValueCell";
static NSString *mhedValuePickerCellID = @"ValuePickerCell";

static NSString *mhedTagCellID = @"TagCell";
static NSString *mhedImageAndNameCellID = @"ImageAndNameCell";
static NSString *mhedRestaurantCellID = @"RestaurantCell";
static NSString *mhedAddMealsAndIngredientsCellID = @"AddMealsAndIngredientsCell";
static NSString *mhedDetailMealsAndIngredientsCellID = @"DetailMealsAndIngredientsCell";

static NSString *mhedAddMedsAndIngredientsCellID = @"AddMedsAndIngredientsCell";
static NSString *mhedDetailMedsAndIngredientsCellID = @"DetailMedsAndIngredientsCell";

static NSString *mhedAddObjectsCellID = @"AddObjectsCell";
static NSString *mhedDetailObjectsCellID = @"DetailedObjectsCellID";

static NSString *mhedLargeImageCellID = @"LargeImageCell";
static NSString *mhedImageButtonCellID = @"ImageButtonCell";

static NSString *mhedShowHideCellID = @"ShowHideCell";


static NSString *mhedMealAndMedicationSegmentedControlCellID = @"MealAndMedicationSegmentedControlCell";

static NSString *mhedReminderCellID = @"ReminderCell";

static NSString *mhedDetailMealMedCellID = @"DetailMealMedCell";


@class EDRestaurant;



@interface MHEDTableViewController : UITableViewController <EDImageAndNameDelegate, EDTagCellDataSource, EDTagCellDelegate, EDSelectTagsDelegate, EDMealAndMedicationSegmentedControlDelegate, iCarouselDataSource, iCarouselDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EDImageButtonCellDelegate, EDShowHideCellDelegate>



// Core Data
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

// ????

//@property (nonatomic, weak) id <EDCreationDelegate> delegate;

@property (nonatomic) BOOL cameraCanceled; // says if we just called cancel

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic) BOOL keyboardVisible;

@property (nonatomic) BOOL medication;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) NSArray *capturedImages;

// Image cell
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UIImage *objectImage;
@property (nonatomic, weak) iCarousel *mhedCarousel;
@property (nonatomic, strong) NSMutableArray *carouselImages;


// Name Cell
@property (nonatomic, strong) NSString *objectName;
@property (nonatomic) BOOL defaultName;
@property (weak, nonatomic) UITextView *objectNameTextView;


// Tags cell
@property (nonatomic, strong) NSArray *tagsList;
@property (nonatomic, weak) UITextView *tagTextView;
@property (nonatomic) BOOL favorite;


// Restaurant Cell
@property (nonatomic, strong) EDRestaurant *restaurant;

// Meal and Ingredient Cell
//@property (nonatomic, strong) NSArray *mealsList;
//@property (nonatomic, strong) NSArray *ingredientsList;


// Date Cell
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *date1;

// keep track which indexPath points to the cell with UIDatePicker, if nil then it is NOT visible,
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (assign) NSInteger pickerCellRowHeight;


#pragma mark - Tag cell Delegate and DataSource methods
- (void) textView:(UITextView *) textView didSelectRange: (NSRange) range;

- (NSAttributedString *) tagsString;

/// returns whether it has the favorite tag
- (BOOL) favorite;



#pragma mark - EDImageAndNameDelegate methods
- (NSString *) defaultTextForNameTextView; // override in subclass
- (BOOL) textViewShouldClear;
- (void) setNameAs: (NSString *) newName;
- (BOOL) textViewShouldBeginEditing;
- (void) textEnter:(UITextView *)textView;

- (UIImage *) imageForThumbnail;

#pragma mark - EDSelectTagsDelegate methods

- (void) addTagsToList: (NSSet *) tags;

#pragma mark - EDMealAndMedicationSegmentedControlDelegate

- (void) handleMealAndMedicationSegmentedControl: (id) sender;

#pragma mark - Picker Methods

- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath;
- (void)updateDatePicker;
- (BOOL)hasInlineDatePicker;
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath;
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath;
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath;


#pragma mark - LargeImageCell and iCarousel data and delegate



#pragma mark - EDImageButtonCell delegate
- (void) handleTakeAnotherPictureButton: (id) sender;
- (void) handleDeletePictureButton:(id)sender;

#pragma mark - EDShowHideButton Cell Delegate
- (void) handleShowHideButtonPress:(id)sender;


#pragma mark - UIImagePickerController methods



- (void)showImagePickerForCamera:(id)sender;
- (UIImagePickerController *) imagePickerControllerForSourceType: (UIImagePickerControllerSourceType) sourceType;


#pragma mark - Optional Setup Methods to call in VDL etc. (optional override)



/// call in vdl
- (void) setupDateAndDatePickerCell;

- (void) setupObjectName;

/// default returns mealNameAsDefault
- (NSString *) objectNameAsDefault;
- (NSString *) objectNameForDisplay;
- (NSString *) eatDateAsString: (NSDate *) date;



- (void) popToHomePage;

/// defaults to handleMealDoneButton
- (void) handleDoneButton;


#pragma mark - Default Cell Dictionaries

- (NSMutableDictionary *) dateCellDictionary:(NSDate *) date;
- (NSMutableDictionary *) imageAndNameCellDictionary;
- (NSMutableDictionary *) mealAndIngredientCellDictionary;
- (NSMutableDictionary *) restaurantCellDictionary;

- (NSMutableDictionary *) tagCellDictionary;

- (NSMutableDictionary *) largeImageCellDictionary;
- (NSMutableDictionary *) imageButtonCellDictionary;
- (NSMutableDictionary *) showHideCellDictionary;

- (NSMutableDictionary *) mealAndMedicationSegmentedControllCellDictionary;

- (NSMutableDictionary *) reminderCellDictionary;
- (NSMutableDictionary *) detailMealMedCellDictionary;

- (NSMutableDictionary *) cellDictionaryWithCellID:(NSString *) cellID
                                       headerTitle:(NSString *) headerTitle
                                      detailString:(NSString *) detailString
                                              date:(NSDate *) date;


#pragma mark - Default Meal Methods
//---------------------------
- (void) handleMealDoneButton;
- (NSString *) mealNameAsDefault;
- (NSString *) mealNameForDisplay;
- (void) mealNameTextViewEditable: (UITextView *) textView;





#pragma mark - Default Medication Methods
// ---------------------------------------
- (void) handleMedDoneButton;
- (NSString *) medNameAsDefault;
- (NSString *) medNameForDisplay;

- (void) medNameTextViewEditable: (UITextView *) textView;


- (NSMutableDictionary *) medAndIngredientCellDictionary;


#pragma mark - Subclass methods to Override

// override numberOfRows, and most other table delegate and data source methods

- (NSArray *) defaultDataArray;
- (void) nameTextViewEditable: (UITextView *) textView;

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


/// called before table is reloaded in VWA,
- (void) setUpBeforeTableLoad;
//

@end
