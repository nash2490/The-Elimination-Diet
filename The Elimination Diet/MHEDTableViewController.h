//
//  MHEDTableViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/7/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//


/// process to use this class
/*
 
 Sections of Table 
 --------------------
 The sections of the table are dictated in self.dataArray
    - each section is determined by a dictionary
            - EDTableComponents outlines the keys that can be used in the dictionary
    
    - tableView: cellForRowAtIndexPath: determines the cell based on the section etc.
 
 
 
 
 Subclass Notes
 -------------------
 
    Deallocation
    -----------------
        override mhed_Dealloc calling [super mhed_Dealloc] and add anything new
 
 */





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




//static double mhedPickerAnimationDuration = 0.40;  // duration for the animation to slide the date picker into view
//static double mhedDatePickerTag = 99;    // view tag identifiying the date picker view



// Cell IDs and Section IDs (sometimes we don't need if a section is just the cell)

static NSString *mhedTableSectionIDDateSection = @"Date Section";
static NSString *mhedTableCellIDDateCell = @"DateCell";     // the cells with the start or end date
static NSString *mhedTableCellIDDatePickerCell = @"DatePicker"; // the cell containing the date picker

static NSString *mhedTableCellIDValueCell = @"ValueCell";
static NSString *mhedTableCellIDValuePickerCell = @"ValuePickerCell";

static NSString *mhedTableCellIDTagCell = @"TagCell";
static NSString *mhedTableCellIDImageAndNameCell = @"ImageAndNameCell";
static NSString *mhedTableCellIDRestaurantCell = @"RestaurantCell";

static NSString *mhedTableSectionIDLargeImageSection = @"Large Image Section";
static NSString *mhedTableCellIDLargeImageCell = @"LargeImageCell";
static NSString *mhedTableCellIDImageButtonCell = @"ImageButtonCell";
static NSString *mhedTableCellIDShowHideCell = @"ShowHideCell";

static NSString *mhedTableSectionIDObjectsSection = @"Objects Section";

static NSString *mhedTableCellIDAddMealsAndIngredientsCell = @"AddMealsAndIngredientsCell";
static NSString *mhedTableCellIDDetailMealsAndIngredientsCell = @"DetailMealsAndIngredientsCell";

static NSString *mhedTableCellIDAddMedsAndIngredientsCell = @"AddMedsAndIngredientsCell";
static NSString *mhedTableCellIDDetailMedsAndIngredientsCell = @"DetailMedsAndIngredientsCell";

static NSString *mhedTableCellIDMealAndMedicationSegmentedControlCell = @"MealAndMedicationSegmentedControlCell";
static NSString *mhedTableCellIDDetailMealMedCell = @"DetailMealMedCell";

static NSString *mhedTableCellIDReminderCell = @"ReminderCell";

static NSString *mhedTableCellIDDefaultDetailCell = @"Default Detail Cell";


// Objects Dictionary keys - use to retrieve arrays from objectsDictionary
static NSString *mhedObjectsDictionaryMealsKey = @"Meals List Key";
static NSString *mhedObjectsDictionaryIngredientsKey = @"Ingredients List Key";
static NSString *mhedObjectsDictionaryMedicationKey = @"Medication List Key";
static NSString *mhedObjectsDictionarySymptomsKey = @"Symptom List Key";

//typedef NS_OPTIONS(NSUInteger, mhedObjectsDictionaryItemType) {
//    mhedObjectsDictionaryItemTypeMeals = 1 << 0,
//    mhedObjectsDictionaryItemTypeIngredients = 1 << 1,
//    mhedObjectsDictionaryItemTypeMedications = 1 << 2,
//    mhedObjectsDictionaryItemTypeSymptoms = 1 << 3,
//};

@class EDRestaurant;



@interface MHEDTableViewController : UITableViewController <EDImageAndNameDelegate, EDTagCellDataSource, EDTagCellDelegate, EDSelectTagsDelegate, EDMealAndMedicationSegmentedControlDelegate, UINavigationControllerDelegate>



// Core Data
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


//@property (nonatomic, weak) id <EDCreationDelegate> delegate;


@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic) BOOL keyboardVisible;


// Name
@property (nonatomic, strong) NSString *objectName;
@property (nonatomic) BOOL defaultName;
@property (weak, nonatomic) UITextView *objectNameTextView;


// Tags
@property (nonatomic, strong) NSArray *tagsList;
@property (nonatomic, weak) UITextView *tagTextView;
@property (nonatomic) BOOL favorite;

// Meal Medication Segmented Control
@property (nonatomic, weak) UISegmentedControl *mealMedicationSegmentedControl;
@property (nonatomic) BOOL medication;

// Restaurant
@property (nonatomic, strong) EDRestaurant *restaurant;

// Objects - Food, medication, symptoms, etc.
@property (nonatomic, strong) NSDictionary *objectsDictionary;

// Date
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *date1;

// keep track which indexPath points to the cell with UIDatePicker, if nil then it is NOT visible,
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (assign) NSInteger pickerCellRowHeight;

#pragma mark - Objects Dictionary Methods
- (NSArray *) mealsList;
- (void) setNewMealsList: (NSArray *) newMealsList;
- (void) addToMealsList: (NSArray *) meals;

- (NSArray *) ingredientsList;
- (void) setNewIngredientsList: (NSArray *) newIngredientsList;
- (void) addToIngredientsList: (NSArray *) ingredients;

- (NSArray *) medicationsList;
- (void) setNewMedicationsList: (NSArray *) newMedicationsList;
- (void) addToMedicationsList: (NSArray *) medications;

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

- (UIImage *) thumbnailForImage:(UIImage *) image;

#pragma mark - EDSelectTagsDelegate methods

- (void) addTagsToList: (NSSet *) tags;

#pragma mark - EDMealAndMedicationSegmentedControlDelegate

- (void) handleMealAndMedicationSegmentedControl: (id) sender;

#pragma mark - Date Picker Methods

- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath;
- (void)updateDatePicker;
- (BOOL)hasInlineDatePicker;
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath;
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath;
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath;







#pragma mark - Table Cell setup


- (UITableViewCell *) tableView:(UITableView *) tableView
                 datePickerCell:(UITableViewCell *)currentCell
                  forDictionary:(NSDictionary *) itemDictionary;

- (UITableViewCell *) tableView:(UITableView *)tableView
                dateDisplayCell:(UITableViewCell *) currentCell
                  forDictionary:(NSDictionary *) itemDictionary;

- (UITableViewCell *) tableView:(UITableView *)tableView
           imageIconAndNameCell:(UITableViewCell *) currentCell
                  forDictionary:(NSDictionary *) itemDictionary;

- (UITableViewCell *) tableView:(UITableView *)tableView
                 restaurantCell:(UITableViewCell *) currentCell
                  forDictionary:(NSDictionary *) itemDictionary;

- (UITableViewCell *) tableView:(UITableView *)tableView
     addMealsAndIngredientsCell:(UITableViewCell *) currentCell
                  forDictionary:(NSDictionary *) itemDictionary;

- (UITableViewCell *) tableView:(UITableView *)tableView
addMedicationAndIngredientsCell:(UITableViewCell *) currentCell
                  forDictionary:(NSDictionary *) itemDictionary;

- (UITableViewCell *) tableView:(UITableView *)tableView
            favoriteAndTagsCell:(UITableViewCell *) currentCell
                  forDictionary:(NSDictionary *) itemDictionary;


- (UITableViewCell *) tableView:(UITableView *)tableView
mealAndMedicationSegmentedControlCell:(UITableViewCell *) currentCell
                  forDictionary:(NSDictionary *) itemDictionary;

#pragma mark - Default Cell Dictionaries

- (NSMutableDictionary *) dateSectionDictionary:(NSDate *) date;
- (NSMutableDictionary *) imageAndNameSectionDictionary;
- (NSMutableDictionary *) mealAndIngredientSectionDictionary;
- (NSMutableDictionary *) restaurantSectionDictionary;

- (NSMutableDictionary *) tagSectionDictionary;

- (NSMutableDictionary *) mealAndMedicationSegmentedControllSectionDictionary;

- (NSMutableDictionary *) objectsSectionDictionaryWithMainHeader: (NSString *) mainHeader
                                  withObjectsDictionaryItemTypes: (NSArray *) itemTypes
                                                  withSubHeaders:(NSArray *) subHeaders;

- (NSMutableDictionary *) reminderSectionDictionary;
- (NSMutableDictionary *) detailMealMedicationSectionDictionary;

- (NSMutableDictionary *) sectionDictionaryWithSectionID: (NSString *) sectionID
                                                  cellID:(NSString *)cellID
                                             headerTitle:(NSString *)headerTitle
                                            detailString:(NSString *)detailString
                                                    date:(NSDate *)date;

//- (NSMutableDictionary *) sectionDictionaryWithCellID:(NSString *) cellID
//                                       headerTitle:(NSString *) headerTitle
//                                      detailString:(NSString *) detailString
//                                              date:(NSDate *) date;
//


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


#pragma mark - Subclass methods to Override

- (void) mhed_Dealloc;

// override numberOfRows, and most other table delegate and data source methods

- (NSArray *) defaultDataArray;
- (void) nameTextViewEditable: (UITextView *) textView;

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


/// called before table is reloaded in VWA,
- (void) setUpBeforeTableLoad;
//

// called in tableView: cellForRowAtIndexPath:, loads the cells from their corresponeding methods
// override if you want to
        // - add a new type of cell
        // - change some functionality of methods that cannot be changed from overriding their custom method
- (UITableViewCell *) mhedTableView:(UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath;


#pragma mark - Default Meal Methods
//---------------------------
- (void) handleMealDoneButton;
- (NSString *) mealNameAsDefault;
- (NSString *) mealNameForDisplay;
- (void) mealNameTextViewEditable: (UITextView *) textView;


#pragma mark - Default Medication Methods
// ---------------------------------------
- (void) handleMedicationDoneButton;
- (NSString *) medicationNameAsDefault;
- (NSString *) medicationNameForDisplay;

- (void) medicationNameTextViewEditable: (UITextView *) textView;


//- (NSMutableDictionary *) medAndIngredientCellDictionary;


@end
