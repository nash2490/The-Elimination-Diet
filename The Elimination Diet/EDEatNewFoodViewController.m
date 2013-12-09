//
//  EDEatNewFoodViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/7/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEatNewFoodViewController.h"
#import "EDTag+Methods.h"
#import "EDRestaurant+Methods.h"
#import "EDMeal+Methods.h"
#import "EDIngredient+Methods.h"

#import "EDDocumentHandler.h"

#import "NSString+MHED_EatDate.h"

#define mhedPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define mhedDatePickerTag              99     // view tag identifiying the date picker view

#define mhedTitleKey       @"title"   // key for obtaining the data source item's title
#define mhedDateKey        @"date"    // key for obtaining the data source item's date value
#define mhedCellIDKey      @"cellID"  // key for the type of cell to use



static NSString *mhedTableCellIDDateCell = @"DateCell";     // the cells with the start or end date
static NSString *mhedTableCellIDDatePickerCell = @"DatePicker"; // the cell containing the date picker
static NSString *mhedTableCellIDTagCell = @"TagsCell";
static NSString *mhedTableCellIDImageAndNameCell = @"ImageAndNameCell";
static NSString *mhedTableCellIDRestaurantCell = @"RestaurantCell";
static NSString *mhedMealsAndIngredientsCellID = @"MealsAndIngredientsCell";

@interface EDEatNewFoodViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, strong) NSArray *dataArray;


// Image and Name cell
@property (nonatomic, strong) UIImage *foodImage;
@property (nonatomic, strong) NSString *foodName;

// Tag Cell
@property (nonatomic, strong) NSArray *tagsList;
@property (nonatomic) BOOL favorite;

// Date Cell

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

        // keep track which indexPath points to the cell with UIDatePicker, if nil then it is NOT visible,
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (assign) NSInteger pickerCellRowHeight;

// Restaurant Cell
@property (nonatomic, strong) EDRestaurant *restaurant;

// Meal and Ingredient Cell
@property (nonatomic, strong) NSArray *mealsList;
@property (nonatomic, strong) NSArray *ingredientsList;

// Core Data
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;




@end

@implementation EDEatNewFoodViewController

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
    
    // setup our data source
    NSMutableDictionary *dateDict = [@{ mhedTitleKey : @"Date",
                                       mhedDateKey : [NSDate date],
                                       mhedCellIDKey : mhedTableCellIDDateCell} mutableCopy];
    
    NSMutableDictionary *restaurantDict = [@{ mhedTitleKey : @"Restaurant",
                                              mhedCellIDKey : mhedTableCellIDRestaurantCell} mutableCopy];
    
    NSMutableDictionary *tagsDict = [@{ mhedTitleKey : @"Tags",
                                        mhedCellIDKey : mhedTableCellIDTagCell} mutableCopy];
    
    
    self.dataArray = @[tagsDict, dateDict, restaurantDict];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:mhedTableCellIDDatePickerCell];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
    
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Picker View

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:indexPath.section]];
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
            //
            NSDictionary *itemData = self.dataArray[self.datePickerIndexPath.row - 1];
            [targetedDatePicker setDate:[itemData valueForKey:mhedDateKey] animated:NO];
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
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    NSInteger modelRow = indexPath.row;
    NSDictionary *itemData = self.dataArray[modelRow];

    
    if ([itemData[mhedCellIDKey] isEqualToString:mhedTableCellIDDateCell] )
    {
        hasDate = YES;
    }
    
    return hasDate;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self hasInlineDatePicker])
    {
        // we have a date picker, so allow for it in the number of rows in this section
        NSInteger numRows = self.dataArray.count;
        return ++numRows;
    }
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if we have a date picker open whose cell is above the cell we want to update, Or we are at the datePicker
        // then the data we want corresponds to self.dataArray[row - 1]

    NSInteger modelRow = indexPath.row;
    if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row <= indexPath.row)
    {
        modelRow--;
    }

    NSDictionary *itemData = self.dataArray[modelRow];

    
    
    UITableViewCell *cell = nil;
    
    NSString *cellID = nil;
    
    if ([self indexPathHasPicker:indexPath])
    {
        // the indexPath is the one containing the inline date picker the current/opened date picker cell
            // used because we don't define the datePicker in self.dataArray
        cellID = mhedTableCellIDDatePickerCell;
    }

    else
    {
        cellID = itemData[mhedCellIDKey];
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    
    
    cell.textLabel.text = [itemData valueForKey:mhedTitleKey];
    
    if ([cellID isEqualToString:mhedTableCellIDDatePickerCell]) {
        cell.textLabel.text = nil;
    }
    
    // proceed to configure our cell
    if ([cellID isEqualToString:mhedTableCellIDDateCell])
    {
        // we have either start or end date cells, populate their date field
        //
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[itemData valueForKey:mhedDateKey]];
    }
    else if ([cellID isEqualToString:mhedTableCellIDRestaurantCell])
    {
        // this cell is a non-date cell, just assign it's text label
        //
        cell.textLabel.text = [itemData valueForKey:mhedTitleKey];
    }
    
    else if ([cellID isEqualToString:mhedTableCellIDTagCell])
    {
        
    }
    
    else if ([cellID isEqualToString:mhedTableCellIDImageAndNameCell])
    {
        
    }
    
    else if ([cellID isEqualToString:mhedMealsAndIngredientsCellID])
    {
        
    }
    
	return cell;
}

/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
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
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == mhedTableCellIDDateCell)
    {
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];

    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - Actions

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    }
    else
    {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    // update our data model
    NSMutableDictionary *itemData = self.dataArray[targetedCellIndexPath.row];
    [itemData setValue:targetedDatePicker.date forKey:mhedDateKey];
    
    // update the cell's date string
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
}




@end
