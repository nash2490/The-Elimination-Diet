//
//  MHEDTableViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/7/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDTableViewController.h"

#import "EDSearchToEatViewController.h"

#import "EDTableComponents.h"

// custom cells
#import "EDTagCell.h"
#import "EDMealAndMedicationSegmentedControlCell.h"
#import "EDImageAndNameCell.h"
#import "EDShowHideCell.h"

#import "EDTag+Methods.h"
#import "EDRestaurant+Methods.h"
#import "EDFood+Methods.h"
#import "EDMeal+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDEatenMeal+Methods.h"
#import "EDMedication+Methods.h"
#import "EDTakenMedication+Methods.h"
#import "EDImage+Methods.h"

#import "EDDocumentHandler.h"
#import "NSString+MHED_EatDate.h"
#import "UIImage+MHED_fixOrientation.h"

//#import "MHEDObjectsDictionary.h"

#import "EDEliminatedAPI.h"


// Cell IDs and Section IDs (sometimes we don't need if a section is just the cell)

NSString *const mhedTableSectionIDDateSection = @"Date Section";
NSString *const mhedTableCellIDDateCell = @"DateCell";     // the cells with the start or end date
NSString *const mhedTableCellIDDatePickerCell = @"DatePicker"; // the cell containing the date picker

NSString *const mhedTableCellIDValueCell = @"ValueCell";
NSString *const mhedTableCellIDValuePickerCell = @"ValuePickerCell";

NSString *const mhedTableCellIDTagCell = @"TagCell";
NSString *const mhedTableCellIDImageAndNameCell = @"ImageAndNameCell";
NSString *const mhedTableCellIDRestaurantCell = @"RestaurantCell";

NSString *const mhedTableSectionIDLargeImageSection = @"Large Image Section";
NSString *const mhedTableCellIDLargeImageCell = @"LargeImageCell";
NSString *const mhedTableCellIDImageButtonCell = @"ImageButtonCell";
NSString *const mhedTableCellIDShowHideCell = @"ShowHideCell";

NSString *const mhedTableSectionIDObjectsSection = @"Objects Section";

NSString *const mhedTableCellIDAddMealsAndIngredientsCell = @"AddMealsAndIngredientsCell";
NSString *const mhedTableCellIDDetailMealsAndIngredientsCell = @"DetailMealsAndIngredientsCell";

NSString *const mhedTableCellIDAddMedsAndIngredientsCell = @"AddMedsAndIngredientsCell";
NSString *const mhedTableCellIDDetailMedsAndIngredientsCell = @"DetailMedsAndIngredientsCell";

NSString *const mhedTableCellIDMealAndMedicationSegmentedControlCell = @"MealAndMedicationSegmentedControlCell";
NSString *const mhedTableCellIDDetailMealMedCell = @"DetailMealMedCell";

NSString *const mhedTableCellIDReminderCell = @"ReminderCell";

NSString *const mhedTableCellIDDefaultDetailCell = @"Default Detail Cell";

NSString *const mhedTableCellIDBrowseOptionsCell = @"Browse Options Cell";
NSString *const mhedTableSectionIDBrowseSection = @"Browse Section";

NSString *const mhedTableSectionIDLinkToRecentSection = @"link to recent section";
NSString *const mhedTableCellIDLinkToRecentCell = @"Link To Recent Cell";

//// Objects Dictionary keys - use to retrieve arrays from objectsDictionary
//NSString *const mhedObjectsDictionaryMealsKey = @"Meals List Key";
//NSString *const mhedObjectsDictionaryIngredientsKey = @"Ingredients List Key";
//NSString *const mhedObjectsDictionaryMedicationKey = @"Medication List Key";
//NSString *const mhedObjectsDictionarySymptomsKey = @"Symptom List Key";
//






@import MobileCoreServices;


@interface MHEDTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)doneButtonPress:(id)sender;


@end

@implementation MHEDTableViewController


- (MHEDObjectsDictionary *) objectsDictionary
{
    // if we don't have an objectsDictioanry but have a data source that is not ourself
    if (!_objectsDictionary && _dataSource && ![_dataSource isEqual:self]) {
        _objectsDictionary = [_dataSource objectsDictionary];
    }
    
    else if (!_objectsDictionary) { // otherwise if we don't have an ojbectsDictionary but don't have a dataSource that is not us
        _objectsDictionary = [[MHEDObjectsDictionary alloc] initWithDefaults];
    }
    
    return _objectsDictionary;
}

- (id) dataSource
{
    if (!_dataSource) {
        _dataSource = self;
    }
    return _dataSource;
}

- (NSDateFormatter *) dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"h:mm a - M/d/yy"];
    }
    return _dateFormatter;
}




- (NSInteger) pickerCellRowHeight
{
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    if (!_pickerCellRowHeight) {
        UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:mhedTableCellIDDatePickerCell];
        _pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
    }
    return _pickerCellRowHeight;
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.defaultName = YES;
    self.keyboardVisible = NO;
    
    // set the section data (self.dataArray)
    // --------------------------------------
    
    self.cellArray = [self defaultDataArray];
    
    
    
    // Notifications
    // ---------------------------------------
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (NSArray *) defaultDataArray
// override method, don't call super
{
    [[self.dataSource objectsDictionary]  setDate:[NSDate date]];
    
    NSMutableDictionary *dateDict = [@{ mhedTableComponentTitleKey: @"Date",
                                        mhedTableComponentDateKey : self.date,
                                        mhedTableComponentCellIDKey : mhedTableCellIDDateCell} mutableCopy];
    
    
    
    NSMutableDictionary *nameDict = [@{ mhedTableComponentTitleKey : @"Name and Image",
                                        mhedTableComponentCellIDKey : mhedTableCellIDImageAndNameCell} mutableCopy];
    
    NSMutableDictionary *mealsAndIngredientsDict = [@{ mhedTableComponentTitleKey : @"Meals and Ingredients",
                                                       mhedTableComponentCellIDKey : mhedTableCellIDAddMealsAndIngredientsCell} mutableCopy];
    
    NSMutableDictionary *restaurantDict = [@{ mhedTableComponentTitleKey : @"Restaurant",
                                              mhedTableComponentCellIDKey : mhedTableCellIDRestaurantCell} mutableCopy];
    
    //NSMutableDictionary *tagsDict = [@{ mhedTitleKey : @"Tags",
    //                                    mhedCellIDKey : mhedTagCellID} mutableCopy];
    
    
    return @[dateDict, mealsAndIngredientsDict, nameDict, restaurantDict ];
    
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self mhed_Dealloc];
}

- (void) mhed_Dealloc
{
    
    self.objectsDictionary = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}



- (void)keyboardDidShow: (NSNotification *) notif
{
    self.keyboardVisible = YES;
}

- (void)keyboardDidHide: (NSNotification *) notif
{
    self.keyboardVisible = NO;
}

#pragma mark - Keyboard -
// launches when a keyboard shows on screen,
// - this is to adjust the screen to view the table
- (void) handleKeyboardWillShow: (NSNotification *) paramNotification {
    
    
    /*
     NSDictionary *userInfo = [paramNotification userInfo];
     
     NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
     NSValue *animationDurationObject = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
     NSValue *keyboardEndRectObject = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
     
     NSUInteger animationCurve = 0;
     double animationDuration = 0.0f;
     CGRect keyboardEndRect = CGRectMake(0, 0, 0, 0);
     
     [animationCurveObject getValue:&animationCurve];
     [animationDurationObject getValue:&animationDuration];
     [keyboardEndRectObject getValue:&keyboardEndRect];
     
     [UIView beginAnimations:@"changeTableViewContentInset" context:NULL];
     [UIView setAnimationDuration:animationDuration];
     [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
     
     CGRect intersectionOfTopViewAndKeyboardRect = CGRectIntersection(self.tableView.frame, keyboardEndRect);
     
     
     CGFloat navBarHeight = 0.0f;
     if (self.navigationController) {
     navBarHeight = self.navigationController.navigationBar.frame.size.height;
     }
     
     CGFloat statusBarHeight = 0.0f;
     if (![UIApplication sharedApplication].statusBarHidden) {
     statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
     }
     CGFloat tableInset = intersectionOfTopViewAndKeyboardRect.size.height + navBarHeight + statusBarHeight;
     
     
     self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, tableInset, 0.0f);
     */
    
    
    //NSIndexPath *indexPathOfOwnerCell = nil;
    
    // Also, make sure the selected text field is visible on the screen
    //NSInteger numberOfCells = [self.stTableView.dataSource tableView:self.stTableView numberOfRowsInSection:0];
    
    /* So let's go through all the cells and find their accessory text fields. Once we have the reference to those text fields, we can see which one of them is the first responder (has the keyboard) and we will make a call
     to the table view to make sure that, after the keyboard is displayed, that specific cell is NOT obstructed by the keyboard */
    /*
     for (NSInteger counter = 0; counter < numberOfCells; counter++){
     
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:counter inSection:0];
     UITableViewCell *cell = [self.stTableView cellForRowAtIndexPath:indexPath];
     UITextField *textField = (UITextField *)cell.accessoryView;
     if ([textField isKindOfClass:[UITextField class]] == NO){
     continue;
     }
     if ([textField isFirstResponder]){ indexPathOfOwnerCell = indexPath;
     break;
     }
     }
     */
    
    
    [UIView commitAnimations];
    /*
     if (indexPathOfOwnerCell != nil){
     [self.stTableView scrollToRowAtIndexPath:indexPathOfOwnerCell
     atScrollPosition:UITableViewScrollPositionMiddle
     animated:YES];
     }
     */
}

- (void) handleKeyboardWillHide:(NSNotification *)paramNotification
{
    /*
     if (UIEdgeInsetsEqualToEdgeInsets(self.tableView.contentInset, UIEdgeInsetsZero)){
     // Our table view's content inset is intact so no need to reset it
     return; }
     NSDictionary *userInfo = [paramNotification userInfo]; NSValue *animationCurveObject =
     [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey]; NSValue *animationDurationObject =
     [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey]; NSValue *keyboardEndRectObject =
     [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey]; NSUInteger animationCurve = 0;
     
     double animationDuration = 0.0f;
     CGRect keyboardEndRect = CGRectMake(0, 0, 0, 0);
     [animationCurveObject getValue:&animationCurve]; [animationDurationObject getValue:&animationDuration]; [keyboardEndRectObject getValue:&keyboardEndRect]; [UIView beginAnimations:@"changeTableViewContentInset"
     context:NULL];
     [UIView setAnimationDuration:animationDuration];
     [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve]; self.tableView.contentInset = UIEdgeInsetsZero;
     */
    
    [UIView commitAnimations];
}





- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController) {
        
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(popToHomePage)];
        
        leftBarButton.tintColor = [UIColor redColor];
        [self.navigationItem setLeftBarButtonItem:leftBarButton animated:NO];
        
    }
    
//    // if the first time we get info directly from previous and not from delegate
//    // but then we want to set self as delegate for future
//    if (!self.dataSource) {
//        self.dataSource = self;
//    }
//    
    
    if (!self.managedObjectContext) {
        [[EDDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            
            //[self setManagedObjectContext:document.managedObjectContext];
            self.managedObjectContext = document.managedObjectContext;
        }
         ];
    }
    
    
    // Set up name
    [self setupObjectName];
    
    [self setUpBeforeTableLoad];
    
    //[self.tableView reloadData];
}



- (void) setUpBeforeTableLoad
{
    
}


#pragma mark - Locale

/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self.tableView reloadData];
}










#pragma mark - MHEDObjectsDictionaryProtocol and helper methods
// default method options

- (NSArray *) mealsList
{
    return [[self.dataSource objectsDictionary]  mealsList];
}

- (NSArray *) ingredientsList
{
    return [[self.dataSource objectsDictionary]  ingredientsList];
}

- (NSArray *) medicationsList {
    return [[self.dataSource objectsDictionary]  medicationsList];
}

- (NSArray *) tagsList
{
    return [[self.dataSource objectsDictionary]  tagsList];
}

- (EDRestaurant *) restaurant
{
    return [[self.dataSource objectsDictionary]  restaurant];
}

- (NSArray *) imagesList
{
    return [[self.dataSource objectsDictionary]  imagesArray];
}

- (NSDate *) date
{
    return [[self.dataSource objectsDictionary]  date];
}

- (NSString *) objectName
{
    return [[self.dataSource objectsDictionary]  objectName];
}

#pragma mark - Date Picker View

//- (void) setupDateFormatter
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"h:mm a - M/d/yy"];
//    self.dateFormatter = dateFormatter;
//}

//- (void) setupDatePickerCell
//{
//    
//}

//- (void) setupDateAndDatePickerCell
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"h:mm a - M/d/yy"];
//    self.dateFormatter = dateFormatter;
//    
//    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
//    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:mhedTableCellIDDatePickerCell];
//    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
//}

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;

    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:indexPath.section]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:mhedDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
    if (self.datePickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:mhedDatePickerTag];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            //    by getting item data for the date display cell
            
            [targetedDatePicker setDate:self.date animated:NO];
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker]
            && self.datePickerIndexPath.row == indexPath.row
            && self.datePickerIndexPath.section == indexPath.section);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    NSInteger modelSection = indexPath.section;
    NSDictionary *itemData = self.cellArray[modelSection];
    
    
    if ([itemData[mhedTableComponentCellIDKey] isEqualToString:mhedTableCellIDDateCell]
        && indexPath.row == 0) // only if the row is also the first
    {
        hasDate = YES;
    }
    
    return hasDate;
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDatePicker])
    {
        before = self.datePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker])
    {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:indexPath.section]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
        
        // enable scrolling again
        self.tableView.scrollEnabled = YES;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:indexPath.section];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:indexPath.section];
        
        // disable scrolling
        self.tableView.scrollEnabled = NO;
        if (self.keyboardVisible) {
            [self textEnter:self.objectNameTextView];
            self.keyboardVisible = NO;
        }
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}


/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

#pragma mark - Actions

- (void) popToHomePage
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)doneButtonPress:(id)sender {
    
    
    if (self.keyboardVisible) {
        [self textEnter:self.objectNameTextView];
        self.keyboardVisible = NO;
    }
    
    [self handleDoneButton];
    
}

- (void) handleDoneButton
{
    //[self handleMealDoneButton];
}





/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */

- (void) dateActionForDatePicker:(UIDatePicker *)datePicker
{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:self.datePickerIndexPath.section];
    }
    else
    {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    
    // update our data model
    NSMutableDictionary *itemData = self.cellArray[targetedCellIndexPath.row];
    
    [[self.dataSource objectsDictionary]  setDate:datePicker.date];
    [itemData setValue:self.date forKey:mhedTableComponentDateKey];
    
    // update the cell's date string
    cell.detailTextLabel.text = [self eatDateAsString:self.date];
    
    // update name if its the default
    if (self.defaultName) {
        [[self.dataSource objectsDictionary]  setObjectName:[self objectNameAsDefault]];
        self.objectNameTextView.text = [self objectNameForDisplay];
    }
}


//- (IBAction)dateAction:(id)sender
//{
//    NSIndexPath *targetedCellIndexPath = nil;
//    
//    if ([self hasInlineDatePicker])
//    {
//        // inline date picker: update the cell's date "above" the date picker cell
//        //
//        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:self.datePickerIndexPath.section];
//    }
//    else
//    {
//        // external date picker: update the current "selected" cell's date
//        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
//    }
//    
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
//    UIDatePicker *targetedDatePicker = sender;
//    
//    // update our data model
//    NSMutableDictionary *itemData = self.dataArray[targetedCellIndexPath.row];
//    
//    self.date1 = targetedDatePicker.date;
//    [itemData setValue:self.date1 forKey:mhedTableComponentDateKey];
//    
//    // update the cell's date string
//    cell.detailTextLabel.text = [self eatDateAsString:self.date1];
//    
//    // update name if its the default
//    if (self.defaultName) {
//        self.objectName = [self objectNameAsDefault];
//        self.objectNameTextView.text = [self objectNameForDisplay];
//    }
//}
//


#pragma mark - Table view data source and Delegate

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemData = self.cellArray[indexPath.section];
    NSString *sectionID = itemData[mhedTableComponentSectionKey];
    
    if ([sectionID isEqualToString:mhedTableSectionIDObjectsSection]){
        
        if (indexPath.row == 0) {
            return 0;
        }
        
        NSArray *itemTypes = itemData[mhedTableComponentObjectsDictionaryItemTypesKey];
        
        NSArray *headerLocations = @[@1];
        
        for (int i = 0; i < [itemTypes count]; i++) {
            // get string for item type
            NSString *itemKey = itemTypes[i];
            
            // get array of objects using key
            NSArray *objectsOfType = [[self.dataSource objectsDictionary]  objectForKey:itemKey];
            
            // the next header location is count + 1, which would correspond to the subHeader i + 1
            headerLocations = [headerLocations arrayByAddingObject:@([objectsOfType count] + 1)];
        }
        
        // if the row is a header then...
        if ([headerLocations containsObject:@(indexPath.row)]) {
            return 1;
        }
        
        else { // row is object row
            return 2;
        }
    }
    
//    if ([itemData[mhedTableComponentCellIDKey] isEqualToString:mhedTableCellIDAddMealsAndIngredientsCell]) {
//        
//        if (indexPath.row == 1) { // always a food separator row
//            return 1;
//            
//        }
//        
//        else if (indexPath.row >1) {
//            NSInteger foodIndex = indexPath.row - 2;
//            
//            if ([self respondsToSelector:@selector(mealsList)]) {
//                
//                if (foodIndex && foodIndex == [self.mealsList count]){ // the ingredient section seperator row
//                    return 1;
//                }
//                else {
//                    return 2;
//                }
//            }
//        }
//    }
    return 1;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.cellArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *itemData = self.cellArray[section];
    
    if (section == self.datePickerIndexPath.section && [self hasInlineDatePicker]) {
        return 2;
    }
    
    else if ([itemData[mhedTableComponentSectionKey] isEqualToString:mhedTableSectionIDObjectsSection]) {
        // rows are = add row + sum(objects in arrays of objectDictionary)
        
        NSUInteger rowCount = 1;
        
        // for every array we sum the number of objects
        for (NSString *objectType in [[self.dataSource objectsDictionary]  allKeys]) {
            rowCount += [[[self.dataSource objectsDictionary]  objectForKey:objectType] count];
            rowCount++; // this adds a row for the sub header
        }
        return rowCount;
    }
    
    else if ([itemData[mhedTableComponentSectionKey] isEqualToString:mhedTableSectionIDBrowseSection]) {
        
        return [itemData[mhedTableComponentBrowseOptionsKey] count];
    }
    
//    else if ([itemData[mhedTableComponentCellIDKey] isEqualToString:mhedTableCellIDAddMealsAndIngredientsCell]) {
//        // rows are the meals + ingredients + add row
//        
//        if ([self respondsToSelector:@selector(ingredientsList)] &&
//            [self respondsToSelector:@selector(mealsList)]) {
//            
//            NSUInteger rowCount = [self.mealsList count] + [self.ingredientsList count] + 1;
//            if ([self.mealsList count]) {
//                rowCount++;
//            }
//            if ([self.ingredientsList count]) {
//                rowCount++;
//            }
//            return rowCount;
//        }
//        
//        return 0;
//    }
    
//    else if ([itemData[mhedCellIDKey] isEqualToString:mhedTableCellIDAddMedsAndIngredientsCell]) {
//        // rows are the meds + ingredients + add row
//        
//        if ([self respondsToSelector:@selector(ingredientsList)] &&
//            [self respondsToSelector:@selector(parentMedicationsList)]) {
//            
//            NSUInteger rowCount = [self.parentMedicationsList count] + [self.ingredientsList count] + 1;
//            if ([self.parentMedicationsList count]) {
//                rowCount++;
//            }
//            if ([self.ingredientsList count]) {
//                rowCount++;
//            }
//            return rowCount;
//        }
//        
//        return 0;
//    }
    
    else if ([itemData[mhedTableComponentCellIDKey] isEqualToString:mhedTableCellIDShowHideCell]) {
        
        BOOL hidden = [itemData[mhedTableComponentHideShowBooleanKey] boolValue];
        
        // if the row is hidden then we only have 1
        if (hidden) {
            return 1;
        }
        
        // else then both
        else if(!hidden){
            return 2;
        }
        
        
    }
    
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    
    NSDictionary *itemData = self.cellArray[section];
    
    
    if ([itemData[mhedTableComponentCellIDKey] isEqualToString:mhedTableCellIDDateCell]) {
        return 0.1;
    }
    
    else if ([itemData[mhedTableComponentNoHeaderBooleanKey]  isEqual: @NO])
    {
        return 0.1;
    }
    
    else if ([itemData[mhedTableComponentMainHeaderKey] isEqualToString:@""])
    {
        return 0.1;
    }
    
    else if ([itemData[mhedTableComponentTitleKey] isEqualToString:@""]){
        NSLog(@"header should be nothing");
        return 0.1;
    }
    
    return 20;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *itemData = self.cellArray[indexPath.section];
    //NSString *cellID = itemData[mhedTableComponentCellIDKey];
    NSString *sectionID = itemData[mhedTableComponentSectionKey];
    
    if ([sectionID isEqualToString:mhedTableSectionIDDateSection]) {
        if ([self indexPathHasPicker:indexPath]) {
            return self.pickerCellRowHeight;
        }
    }
    
    else if ([sectionID isEqualToString:mhedTableCellIDImageAndNameCell]) {
        return 79;
    }
    
    
    else if ([sectionID isEqualToString:mhedTableCellIDTagCell]) {
        return 47;
    }
    
    
    
    else if ([sectionID isEqualToString:mhedTableSectionIDObjectsSection]){
        
        if (indexPath.row == 0) {
            return tableView.rowHeight;
        }
        
        NSArray *itemTypes = itemData[mhedTableComponentObjectsDictionaryItemTypesKey];
        
        NSArray *headerLocations = @[@1];
        
        for (int i = 0; i < [itemTypes count]; i++) {
            // get string for item type
            NSString *itemKey = itemTypes[i];
            
            // get array of objects using key
            NSArray *objectsOfType = [[self.dataSource objectsDictionary]  objectForKey: itemKey];
            
            // the next header location is count + 1, which would correspond to the subHeader i + 1
            headerLocations = [headerLocations arrayByAddingObject:@([objectsOfType count] + 1)];
        }
        
        // if the row is a header then...
        if ([headerLocations containsObject:@(indexPath.row)]) {
            return 20;
        }
        
        else { // row is object row
            return tableView.rowHeight;
        }
    }
    
//    else if (sectionID isEqualToString:mhedTableCellIDAddMealsAndIngredientsCell]) {
//        
//        if (indexPath.row == 1) { // always a food separator row
//            return 20;
//            
//        }
//        
//        else if (indexPath.row >1) {
//            NSInteger foodIndex = indexPath.row - 2;
//            
//            if ([self respondsToSelector:@selector(mealsList)]) {
////                if (foodIndex && foodIndex == [self.mealsList count]){ // the ingredient section seperator row
////                    return 20;
////                }
//            }
//            
//        }
//    }
    
    return tableView.rowHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *itemData = self.cellArray[section];
    if ([itemData[mhedTableComponentCellIDKey] isEqualToString:mhedTableCellIDDateCell]) {
        return nil;
    }
    else {
        return itemData[mhedTableComponentMainHeaderKey];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self mhedTableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Default"];
    }
    
    return cell;
}

- (UITableViewCell *) mhedTableView:(UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    // if we have a date picker open whose cell is above the cell we want to update, Or we are at the datePicker
    // then the data we want corresponds to self.dataArray[row - 1]
    
//    NSInteger modelRow = indexPath.row;
//    NSInteger modelSection = indexPath.section;
//    
    
    NSMutableDictionary *sectionData = self.cellArray[indexPath.section];
    
    //NSString *cellID = itemData[mhedTableComponentCellIDKey];
    NSString *sectionID = sectionData[mhedTableComponentSectionKey];
    
    UITableViewCell *cell = nil;
    
//    if ([self indexPathHasPicker:indexPath])
//    {
//        // the indexPath is the one containing the inline date picker the current/opened date picker cell
//        // used because we don't define the datePicker in self.dataArray
//        cellID = mhedTableCellIDDatePickerCell;
//    }
    
//    if (cellID) {
//        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    }
//    
//    if (!cell) {
//        
//        UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
//        
//        if (itemData[mhedTableComponentCellStyleKey]) {
//            cellStyle = [itemData[mhedTableComponentCellStyleKey] integerValue];
//        }
//        
//        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellID];
//    }
    
    
    // Based On Sections
    // -----------
    if ([sectionID isEqualToString:mhedTableSectionIDDateSection]) {
        
        
        
        if (indexPath.row == 0) {
            cell = [self tableView:tableView dateDisplayCell:cell forDictionary:sectionData];
        }
        else if ([self indexPathHasPicker:indexPath]) {
            cell = [self tableView:tableView datePickerCell:cell forDictionary:sectionData];
        }
//        else if (indexPath.row == 1) {
//            cell = [self tableView:tableView datePickerCell:cell forDictionary:sectionData];
//        }
    }
    
    else if ([sectionID isEqualToString:mhedTableSectionIDObjectsSection]) {
        
        if (indexPath.row == 0) { // then we use the add meals cell
            cell.detailTextLabel.text = @"Add";
        }
        
        else {
            // determine if row is object or sub header
            
            //
            NSArray *itemTypes = sectionData[mhedTableComponentObjectsDictionaryItemTypesKey];
            
            NSArray *headerLocations = @[@1];
            
            for (int i = 0; i < [itemTypes count]; i++) {
                // get string for item type
                NSString *itemKey = itemTypes[i];
                
                // get array of objects using key
                NSArray *objectsOfType = [[self.dataSource objectsDictionary]  objectForKey: itemKey];
                
                // the next header location is count + 1, which would correspond to the subHeader i + 1
                headerLocations = [headerLocations arrayByAddingObject:@([objectsOfType count] + 1)];
            }
            
            // if the row is a header then...
            if ([headerLocations containsObject:@(indexPath.row)]) {
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"FoodSeperatorCell"];

                NSUInteger headerIndex = [headerLocations indexOfObject:@(indexPath.row)];
                NSArray *headers = sectionData[mhedTableComponentSubHeadersKey];
                cell.textLabel.text = headers[headerIndex];
            }
            
            // otherwise it is an object row
            else {
                
                // determine the sub section the row belongs to
                NSUInteger subSectionIndex = 0;
                
                // add row to header locations
                NSArray *tempArray = [headerLocations arrayByAddingObject:@(indexPath.row)];
                
                // sort the temp array
                NSArray *sortedArray = [tempArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                    
                    if ([obj1 integerValue] > [obj2 integerValue]) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    
                    if ([obj1 integerValue] < [obj2 integerValue]) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    return (NSComparisonResult)NSOrderedSame;
                }];
                
                // find location of row, which is also the subsection
                subSectionIndex = [sortedArray indexOfObject:@(indexPath.row)];
                NSString *subSectionType = itemTypes[subSectionIndex];
                
                // Now we get the object
                
                NSNumber *headerIndex = headerLocations[subSectionIndex -1];
                
                NSUInteger objectTrueIndex = indexPath.row - ([headerIndex unsignedIntegerValue] + 1);
                
                NSArray *objectsArray = [[self.dataSource objectsDictionary]  objectForKey: subSectionType];

                id rowObject = objectsArray[objectTrueIndex];
                
                // Now we deal with the cell
                
                cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellIDDetailMealsAndIngredientsCell];
                
                if ([rowObject respondsToSelector:@selector(name)]) {
                    cell.textLabel.text = [rowObject name];
                }
                
            }
            
        }
    
    }
    
    else if ([sectionID isEqualToString:mhedTableSectionIDBrowseSection]) {
        cell = [self tableView:tableView browseOptionsCell:cell forIndexPath:indexPath andDictionary:sectionData];
    }
    
    
    else if ([sectionID isEqualToString:mhedTableCellIDTagCell]) {
        
        cell = [self tableView:tableView favoriteAndTagsCell:cell forDictionary:sectionData];
    }
    
    
    
    
    else if ([sectionID isEqualToString:mhedTableCellIDImageAndNameCell]) {
        
        cell = [self tableView:tableView imageIconAndNameCell:cell forDictionary:sectionData];
        
    }
    
    else if ([sectionID isEqualToString:mhedTableCellIDRestaurantCell]) {
        cell = [self tableView:tableView restaurantCell:cell forDictionary:sectionData];
    }
    
    
    
    
    
    else if ([sectionID isEqualToString:mhedTableCellIDMealAndMedicationSegmentedControlCell]) {
        
        cell = [self tableView:tableView mealAndMedicationSegmentedControlCell:cell forDictionary:sectionData];
    }
    
    else if ([sectionID isEqualToString:mhedTableCellIDReminderCell]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:sectionID];
        
        
    }
    
    
    
    else if ([sectionID isEqualToString:mhedTableCellIDDetailMealMedCell]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:sectionID];
        
    }
    
    
    else if ([sectionID isEqualToString:mhedTableCellIDLinkToRecentCell]) {
        
        cell = [self tableView:tableView linkToRecentCell:cell forDictionary:sectionData];
    }
    
    
    
    if (!cell) {
        NSLog(@"SectionID is nil with cellID = %@", sectionID);
    }
    
    return cell;
}

- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.selectionStyle == UITableViewCellSelectionStyleNone){
        return nil;
    }
    return indexPath;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self mhedTableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void) mhedTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == mhedTableCellIDDateCell)
    {
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
        
    }
    else
    {
        NSMutableDictionary *sectionData = self.cellArray[indexPath.section];
        NSString *cellID = sectionData[mhedTableComponentCellIDKey];
        
        if ([cellID isEqualToString:mhedTableCellIDRestaurantCell]) {
            UITableViewCell *cellAtIndexPath = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            cellAtIndexPath.highlighted = YES;
            // perform segue to restaurant vc and pass on the restaurant, mealsList, ingredientsList, and whether this is medication or meal
        }
        
        else if ([cellID isEqualToString:mhedTableCellIDAddMealsAndIngredientsCell]) {
            if (indexPath.row == 0) { // then we use the add meals cell
                [self performSegueWithIdentifier:@"AddMoreFoodSegue" sender:self];
            }
            
            
            /* For use with removal later
             
             else if (indexPath.row >=1) { // then we use the detail meals cell
             cell = [tableView dequeueReusableCellWithIdentifier:mhedDetailMealsAndIngredientsCellID];
             NSInteger foodIndex = indexPath.row - 1;
             
             
             
             if (foodIndex < [self.mealsList count]) {
             EDMeal *mealForIndex = self.mealsList[foodIndex];
             cell.textLabel.text = mealForIndex.name;
             }
             
             else {
             foodIndex -= [self.mealsList count];
             EDIngredient *ingredientForIndex = self.ingredientsList[foodIndex];
             cell.textLabel.text = ingredientForIndex.name;
             }
             }
             */
        }
        
        else if ([cellID isEqualToString:mhedTableCellIDTagCell]) {
            if (indexPath.row == 0) {
                // add tag
            }
        }
        
        else if ([cellID isEqualToString:mhedTableCellIDShowHideCell]) {
            
        }
        
        else if ([cellID isEqualToString:mhedTableCellIDBrowseOptionsCell]) {
            // needs to be implemented in subclass
        }
        
        else if ([cellID isEqualToString:mhedTableCellIDLinkToRecentCell]) {
#warning push to recent view
        }
        
    }
}




/*
 // Override to support conditional mhediting of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be mheditable.
 return YES;
 }
 */

/*
 // Override to support mhediting the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)mheditingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (mheditingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (mheditingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */


#pragma mark - Storyboard Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"AddTagSegue"]) {
        EDSelectTagsViewController *destinationVC = segue.destinationViewController;
        destinationVC.tagsList = [NSSet setWithArray:self.tagsList];
        destinationVC.delegate = self;
    }
}



#pragma mark - Tag cell Delegate and DataSource methods
- (void) textView:(UITextView *) textView didSelectRange: (NSRange) range
{
    NSRange wordRange = [EDTag rangeForWordInString:textView.text forRange:range];
    
    if (NSEqualRanges(wordRange, textView.selectedRange) == FALSE &&
        wordRange.location + wordRange.length > 0) {
        textView.selectedRange = wordRange;
        
    }
    
}

- (NSAttributedString *) tagsString
{
    return [EDTag convertIntoAttributedString:self.tagsList];
}


#pragma mark - EDImageAndNameDelegate and Name Helpers-


/// controls the selectability of the given textView
- (void) nameTextViewEditable: (UITextView *) textView
{
    if (textView) {
        textView.editable = YES;
    }
}

- (NSString *) defaultTextForNameTextView
{
    [[self.dataSource objectsDictionary]  setObjectName:[self objectNameAsDefault]];
    self.defaultName = YES;
    return [self objectNameForDisplay];
}

- (BOOL) textViewShouldClear
{
    if (self.defaultName) {
        return YES;
    }
    return NO;
}


- (void) setNameAs: (NSString *) newName
{
    if (newName) {
        [[self.dataSource objectsDictionary]  setObjectName:newName];
        self.defaultName = NO;
    }
}


- (BOOL) textViewShouldBeginEditing
{
    // if the date picker is visible we need to dismiss
    if (self.datePickerIndexPath) {
        [self displayInlineDatePickerForRowAtIndexPath:[NSIndexPath indexPathForRow:self.datePickerIndexPath.row -1 inSection:self.datePickerIndexPath.section]];
    }
    
    return YES;
}

- (void) textEnter:(UITextView *)textView
{
    [textView resignFirstResponder];
    
    if (self.objectNameTextView.text && ![self.objectNameTextView.text isEqualToString:@""]) {
        [self setNameAs:self.objectNameTextView.text];
    }
    
    else if ([self.objectNameTextView.text isEqualToString:@""]) {
        self.objectNameTextView.text = [self defaultTextForNameTextView]; // also sets the name automatically
        self.objectNameTextView.textColor = [UIColor grayColor];
    }
    
    
}

- (NSString *) eatDateAsString: (NSDate *) date
{
    if (!self.dateFormatter) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm a - M/d/yy"];
        self.dateFormatter = dateFormatter;
    }
    
    return [self.dateFormatter stringFromDate:date];
}

- (void) setupObjectName
{
    if (self.defaultName || !self.objectName || [self.objectName isEqualToString:@""]) {
        self.defaultName = YES;
        [[self.dataSource objectsDictionary]  setObjectName:[self objectNameAsDefault]];

    }
}

- (NSString *) objectNameAsDefault
{
    return [self mealNameAsDefault];
}

- (NSString *) objectNameForDisplay
{
    return [self mealNameForDisplay];
}

- (UIImage *) thumbnailForImage:(UIImage *) image
{
    if (image) {
        return image;
        //return self.images[0];
    }
    
    else {
        EDMeal *meal = [[[self.dataSource objectsDictionary]  mealsList] lastObject];
        
        if ([meal.images count]) {
            EDImage *mhedImg = [meal.images anyObject];
            UIImage *img = [mhedImg getImageFile];
            return img;
        }
    }
    
    return nil;
}


#pragma mark - EDSelectTagsDelegate methods

//- (void) addTagsToList: (NSSet *) tags
//{
//    self.tagsList = [tags allObjects];
//}


#pragma mark - EDMealAndMedicationSegmentedControlDelegate

- (void) handleMealAndMedicationSegmentedControl: (id) sender
{
//    if ([sender isKindOfClass:[UISegmentedControl class]]) {
//        NSInteger selectedSegment = [(UISegmentedControl *)sender selectedSegmentIndex];
//        self.medication = selectedSegment;
//        NSLog(@" Creation is now Medication = %i", self.medication);
//    }
}


#pragma mark - Table Cell setup

- (UITableViewCell *) tableView: (UITableView *) tableView browseOptionsCell:(UITableViewCell *)currentCell forIndexPath:(NSIndexPath *) indexPath andDictionary:(NSDictionary *) itemDictionary
{
    UITableViewCell *cell = currentCell;

    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellIDBrowseOptionsCell];
    }
    
    if (cell) {
        
        cell.textLabel.text = nil;

        if (itemDictionary) {
            NSArray *browseOptions = itemDictionary[mhedTableComponentBrowseOptionsKey];
            cell.textLabel.text = browseOptions[indexPath.row];
        }
    }
    
    return cell;
}


- (UITableViewCell *) tableView: (UITableView *) tableView datePickerCell:(UITableViewCell *)currentCell forDictionary:(NSDictionary *) itemDictionary
{
    UITableViewCell *cell = currentCell;
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellIDDatePickerCell];
    }
    
    if (cell) {
        cell.textLabel.text = nil;
        
        ((MHEDDatePickerCell *)cell).delegate = self;
        UIDatePicker *checkDatePicker = ((MHEDDatePickerCell *) cell).mhedDatePicker;
        
        [checkDatePicker setMaximumDate: [EDEvent endOfDay:[NSDate date]]];
        [checkDatePicker setDate:itemDictionary[mhedTableComponentDateKey] animated:YES];
    }
    
    return cell;
}

- (UITableViewCell *) tableView:(UITableView *)tableView dateDisplayCell: (UITableViewCell *) currentCell forDictionary:(NSDictionary *) itemDictionary
{
    UITableViewCell *cell = currentCell;
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellIDDateCell];
    }
    
    if (cell) {
        // we have either start or end date cells, populate their date field
        //
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[itemDictionary valueForKey:mhedTableComponentDateKey]];
    }
    
    return cell;
}

- (UITableViewCell *) tableView:(UITableView *)tableView imageIconAndNameCell: (UITableViewCell *) currentCell forDictionary:(NSDictionary *) itemDictionary
{
    UITableViewCell *cell = currentCell;
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellIDImageAndNameCell];
    }
    
    if (cell) {
        //((EDImageAndNameCell *) cell).imageView.image = self.objectImage;
        
        self.objectNameTextView = ((EDImageAndNameCell *) cell).nameTextView;
        ((EDImageAndNameCell *) cell).delegate = self;
        self.objectNameTextView.text = [self objectNameForDisplay];
        
        if (self.objectNameTextView) {
            
            [self nameTextViewEditable:self.objectNameTextView];
            
            if (self.defaultName) {
                self.objectNameTextView.textColor = [UIColor grayColor];
            }
            else {
                self.objectNameTextView.textColor = [UIColor blackColor];
            }
            
            
        }
        
        [(EDImageAndNameCell *)cell loadImageView];
    }
    
    return cell;
}

- (UITableViewCell *) tableView:(UITableView *)tableView restaurantCell: (UITableViewCell *) currentCell forDictionary:(NSDictionary *) itemDictionary
{
    UITableViewCell *cell = currentCell;
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellIDRestaurantCell];
    }
    
    if (cell) {
        cell.textLabel.text = self.restaurant.name;

    }
    
    return cell;
}

- (UITableViewCell *) tableView:(UITableView *)tableView addMealsAndIngredientsCell: (UITableViewCell *) currentCell forDictionary:(NSDictionary *) itemDictionary
{
    UITableViewCell *cell = currentCell;
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellIDAddMealsAndIngredientsCell];
    }
    
    if (cell) {
        
    }
    
    return cell;
}

- (UITableViewCell *) tableView:(UITableView *)tableView addMedicationAndIngredientsCell: (UITableViewCell *) currentCell forDictionary:(NSDictionary *) itemDictionary
{
    UITableViewCell *cell = currentCell;
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellIDAddMedsAndIngredientsCell];
    }
    
    if (cell) {
        
    }
    
    return cell;
}

- (UITableViewCell *) tableView:(UITableView *)tableView favoriteAndTagsCell: (UITableViewCell *) currentCell forDictionary:(NSDictionary *) itemDictionary
{
    UITableViewCell *cell = currentCell;
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellIDTagCell];
    }
    
    if (cell) {
        UITextView *tagTextView = ((EDTagCell *)cell).tagsTextView;
        ((EDTagCell *)cell).delegate = self;
        if (tagTextView) {
            self.tagTextView = tagTextView;
        }
        if ([self.tagsList count] && self.tagTextView) {
            NSAttributedString *attTagsString = [self tagsString];
            
            tagTextView.attributedText = attTagsString;
        }
    }
    
    return cell;
}


- (UITableViewCell *) tableView:(UITableView *)tableView mealAndMedicationSegmentedControlCell: (UITableViewCell *) currentCell forDictionary:(NSDictionary *) itemDictionary
{
    UITableViewCell *cell = currentCell;
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellIDMealAndMedicationSegmentedControlCell];
    }
    
    if (cell) {
        UISegmentedControl *control = [(EDMealAndMedicationSegmentedControlCell *)cell segControl];
        
        control.selectedSegmentIndex = [itemDictionary[mhedTableComponentSegmentedControlIndexKey] integerValue];
        [(EDMealAndMedicationSegmentedControlCell *)cell setDelegate:self];
    }
    
    return cell;
}


- (UITableViewCell *) tableView:(UITableView *)tableView linkToRecentCell:(UITableViewCell *)currentCell forDictionary:(NSDictionary *)itemDictionary
{
    UITableViewCell *cell = currentCell;
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellIDLinkToRecentCell];
    }
    
    if (cell) {
        cell.textLabel.text = itemDictionary[mhedTableComponentTitleKey];
    }
    
    return cell;
}


#pragma mark - Default Cell Dictionaries


- (NSMutableDictionary *) browseSectionDictionaryWithHeader: (NSString *) header andRowNames:(NSArray *) rowNames
{

    
    NSMutableDictionary *dict = [@{ mhedTableComponentSectionKey : mhedTableSectionIDBrowseSection,
                                    mhedTableComponentNoHeaderBooleanKey : @(header != nil),
                                    mhedTableComponentMainHeaderKey : header,
                                    mhedTableComponentBrowseOptionsKey : rowNames,
                                    mhedTableComponentCellIDKey : mhedTableCellIDBrowseOptionsCell} mutableCopy];
    return dict;
}

- (NSMutableDictionary *) linkMealToRecentSectionDictionary
{
    NSMutableDictionary *dict = [@{ mhedTableComponentSectionKey : mhedTableSectionIDLinkToRecentSection,
                                    mhedTableComponentNoHeaderBooleanKey : @(NO),
                                    mhedTableComponentTitleKey : @"Link picture to recent",
                                    mhedTableComponentCellIDKey : mhedTableCellIDLinkToRecentCell} mutableCopy];
    
    return dict;
}

- (NSMutableDictionary *) dateSectionDictionary:(NSDate *)date
{
    NSMutableDictionary *dateDict = [@{ mhedTableComponentSectionKey : mhedTableSectionIDDateSection,
                                        mhedTableComponentNoHeaderBooleanKey : @NO,
                                        mhedTableComponentTitleKey : @"Date",
                                        mhedTableComponentDateKey : date,
                                        mhedTableComponentCellIDKey : mhedTableCellIDDateCell} mutableCopy];
    return dateDict;
}


- (NSMutableDictionary *) imageAndNameSectionDictionary
{
    NSMutableDictionary *nameDict = [@{ mhedTableComponentSectionKey : mhedTableCellIDImageAndNameCell,
                                        mhedTableComponentMainHeaderKey : @"Name and Image",
                                        mhedTableComponentCellIDKey : mhedTableCellIDImageAndNameCell} mutableCopy];
    
    return nameDict;
}


- (NSMutableDictionary *) objectsSectionDictionaryWithMainHeader: (NSString *) mainHeader
                                  withObjectsDictionaryItemTypes: (NSArray *) itemTypes
                                                  withSubHeaders:(NSArray *) subHeaders
{
    // components
    /*
     section header
     add object row
     sections for each of the types of objects
            - sub headers
            - row for each object
     
     */
    
    NSMutableDictionary *cellDict = [@{ mhedTableComponentSectionKey : mhedTableSectionIDObjectsSection,
                                        mhedTableComponentMainHeaderKey : mainHeader,
                                        mhedTableComponentObjectsDictionaryItemTypesKey : itemTypes,
                                        mhedTableComponentSubHeadersKey : subHeaders,
                                        mhedTableComponentCellIDKey : mhedTableCellIDDefaultDetailCell
                                       } mutableCopy];
    
    //NSMutableDictionary *cellDict = [@{ mhedTableComponentTitleKey : @"Meals and Ingredients",
    //                                    mhedTableComponentCellIDKey : mhedTableCellIDAddMealsAndIngredientsCell} mutableCopy];
    return cellDict;
}

- (NSMutableDictionary *) mealAndIngredientSectionDictionary
{
    //NSMutableDictionary *cellDict = [@{ mhedTableComponentTitleKey : @"Meals and Ingredients",
    //                                    mhedTableComponentCellIDKey : mhedTableCellIDAddMealsAndIngredientsCell} mutableCopy];
    
    NSMutableDictionary *cellDict = [self objectsSectionDictionaryWithMainHeader:@"Meals and Ingredients"
                                                  withObjectsDictionaryItemTypes:@[mhedObjectsDictionaryMealsKey, mhedObjectsDictionaryIngredientsKey]
                                                                  withSubHeaders:@[@"Meals", @"Ingredients"]];
    
    return cellDict;
}

- (NSMutableDictionary *) detailMealMedicationSectionDictionary
{
    //NSMutableDictionary *cellDict = [@{mhedTableComponentCellIDKey : mhedTableCellIDDetailMealMedCell ,
    //                                   mhedTableComponentTitleKey : @"Add Ingredients to Meal"} mutableCopy];
    
    NSMutableDictionary *cellDict = [self objectsSectionDictionaryWithMainHeader:@"Medication"
                                                  withObjectsDictionaryItemTypes:@[mhedObjectsDictionaryMedicationKey, mhedObjectsDictionaryIngredientsKey]
                                                                  withSubHeaders:@[@"Medication", @"Ingredients"]];
    
    return cellDict;
}


- (NSMutableDictionary *) restaurantSectionDictionary
{
    NSMutableDictionary *restaurantDict = [@{ mhedTableComponentSectionKey : mhedTableCellIDRestaurantCell,
                                              mhedTableComponentMainHeaderKey : @"Restaurant",
                                              mhedTableComponentTitleKey : @"Restaurant",
                                              mhedTableComponentCellIDKey : mhedTableCellIDRestaurantCell} mutableCopy];
    return restaurantDict;
}


- (NSMutableDictionary *) tagSectionDictionary
{
    NSMutableDictionary *cellDict = [@{ mhedTableComponentSectionKey : mhedTableCellIDTagCell,
                                        mhedTableComponentCellIDKey : mhedTableCellIDTagCell ,
                                        mhedTableComponentMainHeaderKey : @"Favorite and Tags"} mutableCopy];
    return cellDict;
}



- (NSMutableDictionary *) mealAndMedicationSegmentedControllSectionDictionary
{
    NSMutableDictionary *cellDict = [@{mhedTableComponentSectionKey : mhedTableCellIDMealAndMedicationSegmentedControlCell ,
                                       mhedTableComponentCellIDKey : mhedTableCellIDMealAndMedicationSegmentedControlCell ,
                                       mhedTableComponentNoHeaderBooleanKey : @NO ,
                                       mhedTableComponentHideShowBooleanKey : @NO,
                                       mhedTableComponentSegmentedControlIndexKey : @0} mutableCopy];
    return cellDict;
}


- (NSMutableDictionary *) reminderSectionDictionary
{
    NSMutableDictionary *cellDict = [@{mhedTableComponentSectionKey : mhedTableCellIDReminderCell ,
                                       mhedTableComponentCellIDKey : mhedTableCellIDReminderCell ,
                                       mhedTableComponentMainHeaderKey : @"Symptom Reminder"} mutableCopy];
    return cellDict;
}



- (NSMutableDictionary *) sectionDictionaryWithSectionID: (NSString *) sectionID
                                                  cellID:(NSString *)cellID
                                             headerTitle:(NSString *)headerTitle
                                            detailString:(NSString *)detailString
                                                    date:(NSDate *)date
{
    NSMutableDictionary *cellDict = [@{mhedTableComponentSectionKey : sectionID,
                                       mhedTableComponentCellIDKey : cellID ,
                                       mhedTableComponentMainHeaderKey: headerTitle,
                                       mhedTableComponentDetailKey : detailString,
                                       mhedTableComponentDateKey : date} mutableCopy];
    return cellDict;
}

//- (NSMutableDictionary *) sectionDictionaryWithCellID:(NSString *)cellID
//                                       headerTitle:(NSString *)headerTitle
//                                      detailString:(NSString *)detailString
//                                              date:(NSDate *)date
//{
//    NSMutableDictionary *cellDict = [@{mhedTableComponentCellIDKey : cellID ,
//                                       mhedTableComponentTitleKey : headerTitle,
//                                       mhedTableComponentDetailKey : detailString,
//                                       mhedTableComponentDateKey : date} mutableCopy];
//    return cellDict;
//}


#pragma mark - Default Meal Methods
//---------------------------
- (void) handleMealDoneButton
{
    
    [[self.dataSource objectsDictionary]  createMealInContext:self.managedObjectContext];
    
//    if ([self respondsToSelector:@selector(mealsList)] &&
//        [self respondsToSelector:@selector(ingredientsList)]) {
//        
//        if ([self.mealsList count] == 1 && [self.ingredientsList count] == 0)
//        {
//            // also should check the restaurant
//            // but anyways, this means we don't need to create a new meal
//            
//            
//            [self.managedObjectContext performBlockAndWait:^{
//                [EDEatenMeal createEatenMealWithMeal:self.mealsList[0] atTime:self.date1 forContext:self.managedObjectContext];
//                
//            }];
//            
//        }
//        
//        else if ([self.mealsList count] == 0 && [self.ingredientsList count] == 1)
//        { // then we only ate the 1 ingredient so we want the name to be just a meal with the ingredient
//            [self.managedObjectContext performBlockAndWait:^{
//                EDMeal *newMeal = [EDMeal createMealWithName:[NSString stringWithFormat:@"Meal with %@", [self.ingredientsList[0] name]]
//                                            ingredientsAdded:[NSSet setWithArray:self.ingredientsList]
//                                                 mealParents:[NSSet setWithArray:self.mealsList]
//                                                  restaurant:self.restaurant tags:nil
//                                                  forContext:self.managedObjectContext];
//                
////                if ([self.images count]) {
////                    [newMeal addUIImagesToFood:[NSSet setWithArray:self.images] error:nil];
////                }
//                
//                [EDEatenMeal createEatenMealWithMeal:newMeal atTime:self.date1 forContext:self.managedObjectContext];
//            }];
//        }
//        
//        else
//        { // we need to create a new new meal first
//            [self.managedObjectContext performBlockAndWait:^{
//                EDMeal *newMeal = [EDMeal createMealWithName:self.objectName
//                                            ingredientsAdded:[NSSet setWithArray:self.ingredientsList]
//                                                 mealParents:[NSSet setWithArray:self.mealsList]
//                                                  restaurant:self.restaurant tags:nil
//                                                  forContext:self.managedObjectContext];
//                
////                if ([self.images count]) {
////                    [newMeal addUIImagesToFood:[NSSet setWithArray:self.images] error:nil];
////                }
//                
//                
//                [EDEatenMeal createEatenMealWithMeal:newMeal atTime:self.date1 forContext:self.managedObjectContext];
//            }];
//        }
//        
//    }
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void) mealNameTextViewEditable: (UITextView *) textView
{
    if (textView) {
        if ([self respondsToSelector:@selector(mealsList)] &&
            [self respondsToSelector:@selector(ingredientsList)]) {
            
            if ([self.mealsList count] == 1 && [self.ingredientsList count] == 0) {
                textView.editable = NO;
            }
            else {
                textView.editable = YES;
            }
        }
        else {
            textView.editable = YES;
        }
    }
}


- (NSString *) mealNameAsDefault
{
    if ([self respondsToSelector:@selector(mealsList)] &&
        [self respondsToSelector:@selector(ingredientsList)]) {
        
        if ([self.mealsList count] == 1 && [self.ingredientsList count] == 0) {
            EDMeal *meal = self.mealsList[0];
            return meal.name;
        }
        
        else if ([self.mealsList count] == 0 && [self.ingredientsList count] == 1) {
            EDIngredient *ingr = self.ingredientsList[0];
            return [NSString stringWithFormat:@"Meal with %@", ingr.name];
        }
    }
    
    
    
    return [NSString stringWithFormat:@"Meal at %@", [self eatDateAsString:self.date]];
}


- (NSString *) mealNameForDisplay
{
    if ([self respondsToSelector:@selector(mealsList)] &&
        [self respondsToSelector:@selector(ingredientsList)]) {
        
        if ([self.mealsList count] == 1 && [self.ingredientsList count] == 0) {
            return [NSString stringWithFormat:@"(Add another meal or ingredient) %@", [self mealNameAsDefault]];
        }
        else if ([self.mealsList count] == 0 && [self.ingredientsList count] == 1) {
            return [NSString stringWithFormat:@"(Add another meal or ingredient) %@", [self mealNameAsDefault]];
        }
    }
    
    if (self.defaultName) {
        return [NSString stringWithFormat:@"(Default) %@", self.objectName];
    }
    
    else if ([self.objectName isEqualToString:@""]) {
        [[self.dataSource objectsDictionary]  setObjectName:[self mealNameAsDefault]];

        return [NSString stringWithFormat:@"(Default) %@", self.objectName];
    }
    else {
        return self.objectName;
    }
}

#pragma mark - Default Medication Methods
// ---------------------------------------



- (void) handleMedicationDoneButton
{
    
    if ([self.medicationsList count] == 1 && [self.ingredientsList count] == 0)
    {
        // also should check the restaurant
        // but anyways, this means we don't need to create a new meal
        
        
        [self.managedObjectContext performBlockAndWait:^{
            
            [EDTakenMedication createWithMedication:self.medicationsList[0] onDate:self.date inContext:self.managedObjectContext];
        }];
        
    }
    
    else if ([self.medicationsList count] > 0 || [self.ingredientsList count] > 0)
    { // we need to create a new med first
        [self.managedObjectContext performBlockAndWait:^{
            
            EDMedication *newMed = [EDMedication createMedicationWithName:self.objectName ingredientsAdded:[NSSet setWithArray:self.ingredientsList] medicationParents:[NSSet setWithArray:self.medicationsList] company:self.restaurant tags:nil forContext:self.managedObjectContext];
            
            //                if ([self.images count]) {
            //                    [newMed addUIImagesToFood:[NSSet setWithArray:self.images] error:nil];
            //                }
            
            [EDTakenMedication createWithMedication:newMed onDate:self.date inContext:self.managedObjectContext];
        }];
    }
    
    
//    if ([self respondsToSelector:@selector(parentMedicationsList)] &&
//        [self respondsToSelector:@selector(ingredientsList)]) {
//        
//        if ([self.medicationsList count] == 1 && [self.ingredientsList count] == 0)
//        {
//            // also should check the restaurant
//            // but anyways, this means we don't need to create a new meal
//            
//            
//            [self.managedObjectContext performBlockAndWait:^{
//                
//                [EDTakenMedication createWithMedication:self.medicationsList[0] onDate:self.date1 inContext:self.managedObjectContext];
//            }];
//            
//        }
//        
//        else if ([self.medicationsList count] > 0 || [self.ingredientsList count] > 0)
//        { // we need to create a new med first
//            [self.managedObjectContext performBlockAndWait:^{
//                
//                EDMedication *newMed = [EDMedication createMedicationWithName:self.objectName ingredientsAdded:[NSSet setWithArray:self.ingredientsList] medicationParents:[NSSet setWithArray:self.medicationsList] company:self.restaurant tags:nil forContext:self.managedObjectContext];
//                
////                if ([self.images count]) {
////                    [newMed addUIImagesToFood:[NSSet setWithArray:self.images] error:nil];
////                }
//                
//                [EDTakenMedication createWithMedication:newMed onDate:self.date1 inContext:self.managedObjectContext];
//            }];
//        }
//    }
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void) medicationNameTextViewEditable: (UITextView *) textView
{
    if (textView) {
        
        textView.editable = YES;
    }
}

- (NSString *) medicationNameAsDefault
{
    return [NSString stringWithFormat:@"Medication at %@", [self eatDateAsString:self.date]];
    
}
- (NSString *) medicationNameForDisplay
{
    if (self.defaultName) {
        return [NSString stringWithFormat:@"(Default) %@", self.objectName];
    }
    
    else if ([self.objectName isEqualToString:@""]) {
        [[self.dataSource objectsDictionary]  setObjectName:[self mealNameAsDefault]];

        return [NSString stringWithFormat:@"(Default) %@", self.objectName];
    }
    else {
        return self.objectName;
    }
}

//- (NSMutableDictionary *) medAndIngredientCellDictionary
//{
//    NSMutableDictionary *medsAndIngredientsDict = [@{ mhedTitleKey : @"Medication and Ingredients",
//                                                      mhedCellIDKey : mhedTableCellIDAddMedsAndIngredientsCell} mutableCopy];
//    return medsAndIngredientsDict;
//}




@end
