//
//  EDCreationViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/29/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDCreationViewController.h"

#import "EDSearchToEatViewController.h"

#import "EDTableComponents.h"

#import "EDTagCell.h"
#import "EDMealAndMedicationSegmentedControlCell.h"
#import "EDImageAndNameCell.h"

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

#import "NSString+EatDate.h"

#import "UIImage+MHED_fixOrientation.h"


#import "EDShowHideCell.h"

@import MobileCoreServices;



@interface EDCreationViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)doneButtonPress:(id)sender;




@end

@implementation EDCreationViewController

- (NSMutableArray *) images
{
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}

- (NSArray *) capturedImages
{
    if (!_capturedImages) {
        _capturedImages = [[NSArray alloc] init];
    }
    return _capturedImages;
}

- (NSMutableArray *) carouselImages
{
    if (!_carouselImages) {
        _carouselImages = [[NSMutableArray alloc] init];
    }
    return _carouselImages;
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
    
    self.dataArray = [self defaultDataArray];
    
    
    
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
    self.date1 = [NSDate date];
    
    NSMutableDictionary *dateDict = [@{ edTitleKey : @"Date",
                                        edDateKey : self.date1,
                                        edCellIDKey : edDateCellID} mutableCopy];
    
    
    
    NSMutableDictionary *nameDict = [@{ edTitleKey : @"Name and Image",
                                        edCellIDKey : edImageAndNameCellID} mutableCopy];
    
    NSMutableDictionary *mealsAndIngredientsDict = [@{ edTitleKey : @"Meals and Ingredients",
                                                       edCellIDKey : edAddMealsAndIngredientsCellID} mutableCopy];
    
    NSMutableDictionary *restaurantDict = [@{ edTitleKey : @"Restaurant",
                                              edCellIDKey : edRestaurantCellID} mutableCopy];
    
    //NSMutableDictionary *tagsDict = [@{ edTitleKey : @"Tags",
    //                                    edCellIDKey : edTagCellID} mutableCopy];
    
    
     return @[dateDict, mealsAndIngredientsDict, nameDict, restaurantDict ];
    
    
    
    
}

- (void) setupDateAndDatePickerCell
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a - M/d/yy"];
    self.dateFormatter = dateFormatter;
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:edDatePickerID];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
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
    
    self.edCarousel.delegate = nil;
    self.edCarousel.dataSource = nil;
    
    self.imagePickerController = nil;
    self.delegate = nil;
    
}


- (void)keyboardDidShow: (NSNotification *) notif
{
    self.keyboardVisible = YES;
}

- (void)keyboardDidHide: (NSNotification *) notif
{
    self.keyboardVisible = NO;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController) {
        
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(popToHomePage)];
        
        leftBarButton.tintColor = [UIColor redColor];
        [self.navigationItem setLeftBarButtonItem:leftBarButton animated:NO];
        
    }
    
    // if the first time we get info directly from previous and not from delegate
    // but then we want to set self as delegate for future
    if (!self.delegate) {
        self.delegate = self;
    }
    
    
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


#pragma mark - Picker View

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:indexPath.section]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:edDatePickerTag];
    
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
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:edDatePickerTag];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            //    by getting item data for the date display cell
            
            [targetedDatePicker setDate:self.date1 animated:NO];
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
    NSDictionary *itemData = self.dataArray[modelSection];
    
    
    if ([itemData[edCellIDKey] isEqualToString:edDateCellID]
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
    [self handleMealDoneButton];
}





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
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:self.datePickerIndexPath.section];
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
    
    self.date1 = targetedDatePicker.date;
    [itemData setValue:self.date1 forKey:edDateKey];
    
    // update the cell's date string
    cell.detailTextLabel.text = [self eatDateAsString:self.date1];
    
    // update name if its the default
    if (self.defaultName) {
        self.objectName = [self objectNameAsDefault];
        self.objectNameTextView.text = [self objectNameForDisplay];
    }
}



#pragma mark - Table view data source and Delegate

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemData = self.dataArray[indexPath.section];
    
    if ([itemData[edCellIDKey] isEqualToString:edAddMealsAndIngredientsCellID]) {
        
        if (indexPath.row == 1) { // always a food separator row
            return 1;
            
        }
        
        else if (indexPath.row >1) {
            NSInteger foodIndex = indexPath.row - 2;
            
            if ([self respondsToSelector:@selector(mealsList)]) {
                
                if (foodIndex && foodIndex == [self.mealsList count]){ // the ingredient section seperator row
                    return 1;
                }
                else {
                    return 2;
                }
            }
        }
    }
    return 1;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *itemData = self.dataArray[section];
    
     if (section == self.datePickerIndexPath.section && [self hasInlineDatePicker]) {
        return 2;
    }
    
     else if ([itemData[edCellIDKey] isEqualToString:edAddMealsAndIngredientsCellID]) {
         // rows are the meals + ingredients + add row
         
         if ([self respondsToSelector:@selector(ingredientsList)] &&
             [self respondsToSelector:@selector(mealsList)]) {
             
             NSUInteger rowCount = [self.mealsList count] + [self.ingredientsList count] + 1;
             if ([self.mealsList count]) {
                 rowCount++;
             }
             if ([self.ingredientsList count]) {
                 rowCount++;
             }
             return rowCount;
         }
         
         return 0;
    }
    
     else if ([itemData[edCellIDKey] isEqualToString:edAddMedsAndIngredientsCellID]) {
         // rows are the meds + ingredients + add row
         
         if ([self respondsToSelector:@selector(ingredientsList)] &&
             [self respondsToSelector:@selector(parentMedicationsList)]) {
             
             NSUInteger rowCount = [self.parentMedicationsList count] + [self.ingredientsList count] + 1;
             if ([self.parentMedicationsList count]) {
                 rowCount++;
             }
             if ([self.ingredientsList count]) {
                 rowCount++;
             }
             return rowCount;
         }
         
         return 0;
         
         
     }
    
     else if ([itemData[edCellIDKey] isEqualToString:edShowHideCellID]) {
         
         BOOL hidden = [itemData[edHideShowKey] boolValue];
         
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
    
    NSDictionary *itemData = self.dataArray[section];
    
    
    if ([itemData[edCellIDKey] isEqualToString:edDateCellID]) {
        return 0.1;
    }
    else if ([itemData[edTitleKey] isEqualToString:@""]){
        NSLog(@"header should be nothing");
        return 0.1;
    }
    
    return 20;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *itemData = self.dataArray[indexPath.section];
    NSString *cellID = itemData[edCellIDKey];
    
    if ([cellID isEqualToString:edImageAndNameCellID]) {
        return 79;
    }
    
    else if ([cellID isEqualToString:edShowHideCellID]) {
        
        BOOL hidden = [itemData[edHideShowKey] boolValue];
        
        // if the row is hidden and this is the showHide cell then it is normal size
        if (hidden) {
            
        }
        
        // else, if the row is shown and it is the showHideCell it is larger
        else if(!hidden && indexPath.row == 0){
            return LARGE_IMAGE_CELL_DEFAULT_SIZE;
        }
        
        
    }
    
    else if ([itemData[edCellIDKey] isEqualToString:edLargeImageCellID]) {
        
        
        return LARGE_IMAGE_CELL_DEFAULT_SIZE;
    }
    
    
    else if ([itemData[edCellIDKey] isEqualToString:edTagCellID]) {
        return 47;
    }
    
    else if ([self indexPathHasPicker:indexPath]) {
        return self.pickerCellRowHeight;
    }
    
    else if ([itemData[edCellIDKey] isEqualToString:edAddMealsAndIngredientsCellID]) {
        
        if (indexPath.row == 1) { // always a food separator row
            return 20;
            
        }
        
        else if (indexPath.row >1) {
            NSInteger foodIndex = indexPath.row - 2;
            
            if ([self respondsToSelector:@selector(mealsList)]) {
                if (foodIndex && foodIndex == [self.mealsList count]){ // the ingredient section seperator row
                    return 20;
                }
            }
            
        }
    }
    
    else if ([itemData[edCellIDKey] isEqualToString:edAddMedsAndIngredientsCellID]) {
        
        if (indexPath.row == 1) { // always a food separator row
            return 20;
            
        }
        
        else if (indexPath.row >1) {
            NSInteger foodIndex = indexPath.row - 2;
            
            if ([self respondsToSelector:@selector(parentMedicationsList)]) {
                if (foodIndex && foodIndex == [self.parentMedicationsList count]){ // the ingredient section seperator row
                    return 20;
                }
            }
            
        }
    }
    
    return self.tableView.rowHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *itemData = self.dataArray[section];
    if ([itemData[edCellIDKey] isEqualToString:edDateCellID]) {
        return nil;
    }
    else {
        return itemData[edTitleKey];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if we have a date picker open whose cell is above the cell we want to update, Or we are at the datePicker
    // then the data we want corresponds to self.dataArray[row - 1]
    
    NSInteger modelRow = indexPath.row;
    NSInteger modelSection = indexPath.section;
    
    if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row <= indexPath.row && self.datePickerIndexPath.section == modelSection)
    {
        modelRow--;
    }
    
    NSMutableDictionary *itemData = self.dataArray[modelSection];
    
    NSString *cellID = itemData[edCellIDKey];
    
    UITableViewCell *cell = nil;
    if ([self indexPathHasPicker:indexPath])
    {
        // the indexPath is the one containing the inline date picker the current/opened date picker cell
        // used because we don't define the datePicker in self.dataArray
        cellID = edDatePickerID;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
        
        if (itemData[edCellStyleKey]) {
            cellStyle = [itemData[edCellStyleKey] integerValue];
        }
        
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellID];
    }
    
    
    
    
    if ([cellID isEqualToString:edDatePickerID]) {
        cell.textLabel.text = nil;
        
        UIDatePicker *checkDatePicker = (UIDatePicker *)[cell viewWithTag:edDatePickerTag];
        [checkDatePicker setMaximumDate: [EDEvent endOfDay:[NSDate date]]];
    }
    
    // proceed to configure our cell
    else if ([cellID isEqualToString:edDateCellID])
    {
        // we have either start or end date cells, populate their date field
        //
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[itemData valueForKey:edDateKey]];
    }
    
    else if ([cellID isEqualToString:edImageAndNameCellID]) {
        
        ((EDImageAndNameCell *) cell).imageView.image = self.objectImage;
        //((EDImageAndNameCell *) cell).nameTextView.text = self.foodName;
        
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
    
    else if ([cellID isEqualToString:edRestaurantCellID]) {
        cell.textLabel.text = self.restaurant.name;
    }
    
    else if ([cellID isEqualToString:edAddMealsAndIngredientsCellID] &&
             [self respondsToSelector:@selector(mealsList)] &&
             [self respondsToSelector:@selector(ingredientsList)]) {

        if (indexPath.row == 0) { // then we use the add meals cell
            cell.detailTextLabel.text = @"Add";
        }
        
        else if (indexPath.row == 1) { // we use the seperator for the first type
            cell = [tableView dequeueReusableCellWithIdentifier:@"FoodSeperatorCell"];
            if ([self.mealsList count]) { // there is at least 1 meal so we use the meal seperator
                cell.textLabel.text = @"Meals";
            }
            else {
                cell.textLabel.text = @"Ingredients";
            }
            
        }
        
        else if (indexPath.row >1) { // then we use the detail meals cell
            cell = [tableView dequeueReusableCellWithIdentifier:edDetailMealsAndIngredientsCellID];
            NSInteger foodIndex = indexPath.row - 2;
            
            if (foodIndex < [self.mealsList count]) {
                    EDMeal *mealForIndex = self.mealsList[foodIndex];
                    cell.textLabel.text = mealForIndex.name;
            }
            
            else { // if foodIndex = 0 then so is [self.mealsList count] = 0 and then we already have a cell for the ingredients separator
                
                
                if (foodIndex && foodIndex == [self.mealsList count]){
                    cell = [tableView dequeueReusableCellWithIdentifier:@"FoodSeperatorCell"];
                    cell.textLabel.text = @"Ingredients";
                }
                
                else {
                    foodIndex -= [self.mealsList count];
                    if ([self.mealsList count]) {
                        foodIndex--;
                    }
                    EDIngredient *ingredientForIndex = self.ingredientsList[foodIndex];
                    cell.textLabel.text = ingredientForIndex.name;
                }
            }
            
            
        }
        
    }
    
    else if ([cellID isEqualToString:edAddMedsAndIngredientsCellID] &&
             [self respondsToSelector:@selector(parentMedicationsList)] &&
             [self respondsToSelector:@selector(ingredientsList)]) {
        
        if (indexPath.row == 0) { // then we use the add meals cell
            cell.detailTextLabel.text = @"Add";
        }
        
        else if (indexPath.row == 1) { // we use the seperator for the first type
            cell = [tableView dequeueReusableCellWithIdentifier:@"FoodSeperatorCell"];
            if ([self.parentMedicationsList count]) { // there is at least 1 meal so we use the meal seperator
                cell.textLabel.text = @"Medications";
            }
            else {
                cell.textLabel.text = @"Ingredients";
            }
            
        }
        
        else if (indexPath.row >1) { // then we use the detail meals cell
            cell = [tableView dequeueReusableCellWithIdentifier:edDetailMedsAndIngredientsCellID];
            NSInteger foodIndex = indexPath.row - 2;
            
            if (foodIndex < [self.parentMedicationsList count]) {
                EDMedication *medForIndex = self.parentMedicationsList[foodIndex];
                cell.textLabel.text = medForIndex.name;
            }
            
            else { // if foodIndex = 0 then so is [self.mealsList count] = 0 and then we already have a cell for the ingredients separator
                if (foodIndex && foodIndex == [self.parentMedicationsList count]){
                    cell = [tableView dequeueReusableCellWithIdentifier:@"FoodSeperatorCell"];
                    cell.textLabel.text = @"Ingredients";
                }
                else {
                    foodIndex -= [self.parentMedicationsList count];
                    if ([self.parentMedicationsList count]) {
                        foodIndex--;
                    }
                    EDIngredient *ingredientForIndex = self.ingredientsList[foodIndex];
                    cell.textLabel.text = ingredientForIndex.name;
                }
                
            }
            
            
        }
        
    }
    
    else if ([cellID isEqualToString:edTagCellID]) {
        
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
    
    
    
    
    
    else if ([cellID isEqualToString:edImageButtonCellID]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        EDImageButtonCell *buttonCell = (EDImageButtonCell *)cell;
        buttonCell.delegate = self;
    }
    
    else if ([cellID isEqualToString:edShowHideCellID]) {
        
        BOOL hide = [itemData[edHideShowKey] boolValue];
        
        // if the image is shown and the row is 0
        if (!hide && indexPath.row == 0) {
            
            cellID = edLargeImageCellID;
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            EDLargeImageCell *imageCell = (EDLargeImageCell *)cell;
            imageCell.delegate = self;

            if (!self.edCarousel) {
                self.edCarousel = imageCell.edCarousel;
                
                
                
                self.edCarousel.type = iCarouselTypeCoverFlow2;
                [self.edCarousel scrollToItemAtIndex:0 animated:NO];
                
                self.edCarousel.scrollSpeed = 0.5;
                self.edCarousel.decelerationRate = 0.5;
                
                self.edCarousel.delegate = self;
                self.edCarousel.dataSource = self;
            }
            else {
                imageCell.edCarousel = self.edCarousel;
                
                if ([self.images count]) {
                    [self.edCarousel scrollToItemAtIndex:[self.images count] animated:YES];
                }
            }
            
            
           
        }
        
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            EDShowHideCell *buttonCell = (EDShowHideCell *)cell;
            buttonCell.cellHidden = hide;
            buttonCell.delegate = self;
            
            [buttonCell updateShowHide];
        }
        
    }
    
    
    else if ([cellID isEqualToString:edMealAndMedicationSegmentedControlCellID]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        UISegmentedControl *control = [(EDMealAndMedicationSegmentedControlCell *)cell segControl];
        
        control.selectedSegmentIndex = self.medication;
        [(EDMealAndMedicationSegmentedControlCell *)cell setDelegate:self];
    }
    
    else if ([cellID isEqualToString:edReminderCellID]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        
    }
    
    else if ([cellID isEqualToString:edDetailMealMedCellID]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        
    }
    
    else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Default]"];
    }
    
    
    
    if (!cell) {
        NSLog(@"Cell is nil with cellID = %@", cellID);
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.selectionStyle == UITableViewCellSelectionStyleNone){
        return nil;
    }
    return indexPath;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == edDateCellID)
    {
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
        
    }
    else
    {
        NSMutableDictionary *itemData = self.dataArray[indexPath.section];
        NSString *cellID = itemData[edCellIDKey];
        
        if ([cellID isEqualToString:edRestaurantCellID]) {
            UITableViewCell *cellAtIndexPath = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            cellAtIndexPath.highlighted = YES;
            // perform segue to restaurant vc and pass on the restaurant, mealsList, ingredientsList, and whether this is medication or meal
        }
        
        else if ([cellID isEqualToString:edAddMealsAndIngredientsCellID]) {
            if (indexPath.row == 0) { // then we use the add meals cell
                [self performSegueWithIdentifier:@"AddMoreFoodSegue" sender:self];
            }
            
            
            /* For use with removal later
             
             else if (indexPath.row >=1) { // then we use the detail meals cell
             cell = [tableView dequeueReusableCellWithIdentifier:edDetailMealsAndIngredientsCellID];
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
        
        else if ([cellID isEqualToString:edTagCellID]) {
            if (indexPath.row == 0) {
                // add tag
            }
        }
        
        else if ([cellID isEqualToString:edShowHideCellID]) {
            
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    
}






/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
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
    
    if ([segue.identifier isEqualToString:@"AddMoreFoodSegue"]) {
        EDSearchToEatViewController *destinationVC = segue.destinationViewController;
        destinationVC.delegate = self.delegate;
    }
    
    if ([segue.identifier isEqualToString:@"AddTagSegue"]) {
        EDSelectTagsViewController *destinationVC = segue.destinationViewController;
        destinationVC.tagsList = [NSSet setWithArray:self.tagsList];
        destinationVC.delegate = self;
    }
}


//#pragma mark - EDCreateNewMealDelegate methods
//- (void) setNewRestaurant: (EDRestaurant *) restaurant
//{
//    if (restaurant) {
//        self.restaurant = restaurant;
//    }
//}
//
//- (void) setNewMealsList: (NSArray *) newMealsList
//{
//    if (newMealsList) {
//        self.mealsList = newMealsList;
//    }
//}
//
//- (void) setNewIngredientsList: (NSArray *) newIngredientsList
//{
//    if (newIngredientsList) {
//        self.ingredientsList = newIngredientsList;
//    }
//}
//
//- (void) setNewFoodImage: (UIImage *) newFoodImage
//{
//    if (newFoodImage) {
//        self.objectImage = newFoodImage;
//    }
//}
//
//- (void) addToMealsList: (NSArray *) meals
//{
//    if (meals) {
//        self.mealsList = [self.mealsList arrayByAddingObjectsFromArray:meals];
//        for (EDTag *tag in [meals[0] tags]) {
//            NSLog(@"tag name = %@", tag.name);
//        }
//    }
//}
//
//- (void) addToIngredientsList: (NSArray *) ingredients
//{
//    if (ingredients) {
//        self.ingredientsList = [self.ingredientsList arrayByAddingObjectsFromArray:ingredients];
//    }
//}
//
//- (NSInteger) mealCycle
//{
//    return _mealCycle;
//}
//
//- (void) increaseMealCycle
//{
//    _mealCycle++;
//}



#pragma mark - EDCreationDelegate -
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

- (UIImage *) objectImage
{
    return _objectImage;
}

- (void) setNewObjectImage: (UIImage *) newObjectImage
{
    if (newObjectImage) {
        self.objectImage = newObjectImage;
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
    self.objectName = [self objectNameAsDefault];
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
        self.objectName = newName;
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
        self.objectName = [self objectNameAsDefault];
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



- (UIImage *) imageForThumbnail
{
    if ([self.images count]) {
        return self.images[0];
    }
    
    else {
        EDMeal *meal = [self.mealsList lastObject];
        
        if ([meal.images count]) {
            EDImage *edImg = [meal.images anyObject];
            UIImage *img = [edImg getImageFile];
            return img;
        }
    }
    
    return nil;
}


#pragma mark - EDSelectTagsDelegate methods

- (void) addTagsToList: (NSSet *) tags
{
    self.tagsList = [tags allObjects];
}


#pragma mark - EDMealAndMedicationSegmentedControlDelegate

- (void) handleMealAndMedicationSegmentedControl: (id) sender
{
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        NSInteger selectedSegment = [(UISegmentedControl *)sender selectedSegmentIndex];
        self.medication = selectedSegment;
        NSLog(@" Creation is now Medication = %i", self.medication);
    }
}



#pragma mark - LargeImageCell and iCarousel data and delegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSLog(@"number of carousel items = %i", [self.carouselImages count]);
    return [self.carouselImages count];
}

static inline double radians (double degrees) {return degrees * M_PI/180;}
UIImage* rotate(UIImage* src, UIImageOrientation orientation)
{
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, radians(90));
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, radians(-90));
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, radians(90));
    }
    
    [src drawAtPoint:CGPointMake(0, 0)];
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
//    //create a numbered view
//    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
//    view.backgroundColor = [UIColor lightGrayColor];
//    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
//    label.text = [NSString stringWithFormat:@"%i", index];
//    label.backgroundColor = [UIColor clearColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [label.font fontWithSize:50];
//    [view addSubview:label];
//    return view;
    
    //view = [[UIImageView alloc] initWithImage:self.images[index]];
    
    //UIImage *displayImage = [UIImage alloc] initwith
    
    
    // use this to size the image
    //UIImage *displayImage = [self convertImageForCarousel:self.images[index]];
    // OR this to get it if it is already made
    UIImage *displayImage = self.carouselImages[index];
    
    view = [[UIImageView alloc] initWithImage:displayImage];
    return view;
}


- (UIImage *) convertImageForCarousel:(UIImage *) originalImage
{
    UIImage *displayImage;
    
    //[originalImage fixOrientation];
    
    if (originalImage.imageOrientation == UIImageOrientationUp ||
        originalImage.imageOrientation == UIImageOrientationDown) {
        //imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130.0 * SCREEN_RATIO, 130.0f)];
        //displayImage = [UIImage newImageFrom:originalImage toFitHeight: LARGE_IMAGE_CELL_DEFAULT_SIZE];
        displayImage = [UIImage newImageFrom:originalImage scaledToFitHeight:LARGE_IMAGE_CAROUSEL_MAX_IMAGE_HEIGHT andWidth:LARGE_IMAGE_CAROUSEL_MAX_IMAGE_WIDTH];
        
    }
    else if (originalImage.imageOrientation == UIImageOrientationRight ||
             originalImage.imageOrientation == UIImageOrientationLeft){
        //imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130.0 / SCREEN_RATIO, 130.0f)];
        //displayImage = [UIImage newImageFrom:originalImage toFitHeight: LARGE_IMAGE_CELL_DEFAULT_SIZE];
        displayImage = [UIImage newImageFrom:originalImage scaledToFitHeight:LARGE_IMAGE_CAROUSEL_MAX_IMAGE_HEIGHT andWidth:LARGE_IMAGE_CAROUSEL_MAX_IMAGE_WIDTH];
        
    }
    
    return displayImage;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return NO;
        }
            
        case iCarouselOptionSpacing:
        {
            return 0.5;
        }
            
        default:
        {
            return value;
        }
    }
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
	NSLog(@"Carousel will begin dragging");
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
	NSLog(@"Carousel did end dragging and %@ decelerate", decelerate? @"will": @"won't");
}

- (void)carouselWillBeginDecelerating:(iCarousel *)carousel
{
	NSLog(@"Carousel will begin decelerating");
}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
	NSLog(@"Carousel did end decelerating");
}

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel
{
	NSLog(@"Carousel will begin scrolling");
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
	NSLog(@"Carousel did end scrolling");
}


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
        NSInteger imageIndex = self.edCarousel.currentItemIndex;
        
        // remove image from the array,
//        NSMutableArray *mutImages = [self.images mutableCopy];
//        [mutImages removeObjectAtIndex:(NSUInteger)imageIndex];
//        self.images = [mutImages copy];
        
        
        [self.edCarousel removeItemAtIndex:imageIndex animated:YES];
        
        [self.images removeObjectAtIndex:(NSUInteger)imageIndex];
        [self.carouselImages removeObjectAtIndex:(NSUInteger) imageIndex];
        //
    }
    
}


#pragma mark - EDShowHideCell delegate
- (void) handleShowHideButtonPress:(id) sender
{
    // sender is the cell that
    
    if ([sender isKindOfClass:[EDShowHideCell class]]) {
        EDShowHideCell *cell = (EDShowHideCell *) sender;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        if (indexPath) {
            
            NSMutableDictionary *itemData = self.dataArray[indexPath.section];
            
            BOOL hidden = [itemData[edHideShowKey] boolValue];
            
            // if the row is hidden and we selected the showHideCell then we want to show it
            if (hidden) {
                itemData[edHideShowKey] = @(NO);
                
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                
                
            }
            
            // else, if the row is shown and we select the showHideCell then we want to hide it
            else if(!hidden && indexPath.row == 1){
                itemData[edHideShowKey] = @(YES);
                
                NSIndexPath *pathForLargeImageCell = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
                
                [self.tableView deleteRowsAtIndexPaths:@[pathForLargeImageCell] withRowAnimation:UITableViewRowAnimationBottom];
            }
            
        }
    }
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
    
    // set editing
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
    
    self.edCarousel = nil;
    
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
        
        [self.edCarousel insertItemAtIndex:[self.carouselImages count] - 1 animated:YES];
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




#pragma mark - Default Meal Methods
//---------------------------
- (void) handleMealDoneButton
{
    if ([self respondsToSelector:@selector(mealsList)] &&
        [self respondsToSelector:@selector(ingredientsList)]) {
    
        if ([self.mealsList count] == 1 && [self.ingredientsList count] == 0)
        {
            // also should check the restaurant
            // but anyways, this means we don't need to create a new meal
            
            
            [self.managedObjectContext performBlockAndWait:^{
                [EDEatenMeal createEatenMealWithMeal:self.mealsList[0] atTime:self.date1 forContext:self.managedObjectContext];
                
            }];
            
        }
    
        else if ([self.mealsList count] == 0 && [self.ingredientsList count] == 1)
        { // then we only ate the 1 ingredient so we want the name to be just a meal with the ingredient
            [self.managedObjectContext performBlockAndWait:^{
                EDMeal *newMeal = [EDMeal createMealWithName:[NSString stringWithFormat:@"Meal with %@", [self.ingredientsList[0] name]]
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
    
    
    
    return [NSString stringWithFormat:@"Meal at %@", [self eatDateAsString:self.date1]];
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
        self.objectName = [self mealNameAsDefault];
        return [NSString stringWithFormat:@"(Default) %@", self.objectName];
    }
    else {
        return self.objectName;
    }
}


#pragma mark - Default Cell Dictionaries

- (NSMutableDictionary *) dateCellDictionary:(NSDate *)date
{
    NSMutableDictionary *dateDict = [@{ edTitleKey : @"Date",
                                        edDateKey : date,
                                        edCellIDKey : edDateCellID} mutableCopy];
    return dateDict;
}

- (NSMutableDictionary *) imageAndNameCellDictionary
{
    NSMutableDictionary *nameDict = [@{ edTitleKey : @"Name and Image",
                                        edCellIDKey : edImageAndNameCellID} mutableCopy];
    
    return nameDict;
}

- (NSMutableDictionary *) mealAndIngredientCellDictionary
{
    NSMutableDictionary *cellDict = [@{ edTitleKey : @"Meals and Ingredients",
                                        edCellIDKey : edAddMealsAndIngredientsCellID} mutableCopy];
    return cellDict;
}


- (NSMutableDictionary *) restaurantCellDictionary
{
    NSMutableDictionary *restaurantDict = [@{ edTitleKey : @"Restaurant",
                                              edCellIDKey : edRestaurantCellID} mutableCopy];
    return restaurantDict;
}


- (NSMutableDictionary *) tagCellDictionary
{
    NSMutableDictionary *cellDict = [@{edCellIDKey : edTagCellID ,
                                       edTitleKey : @"Favorite and Tags"} mutableCopy];
    return cellDict;
}



- (NSMutableDictionary *) largeImageCellDictionary
{
    NSMutableDictionary *cellDict = [@{edCellIDKey : edLargeImageCellID ,
                                       edTitleKey : @"Food Pictures"} mutableCopy];
    return cellDict;
}

- (NSMutableDictionary *) imageButtonCellDictionary
{
    NSMutableDictionary *cellDict = [@{edCellIDKey : edImageButtonCellID ,
                                       edTitleKey : @""} mutableCopy];
    return cellDict;
}

- (NSMutableDictionary *) showHideCellDictionary
{
    NSMutableDictionary *cellDict = [@{edCellIDKey : edShowHideCellID ,
                                       edTitleKey : @""} mutableCopy];
    return cellDict;
}


- (NSMutableDictionary *) mealAndMedicationSegmentedControllCellDictionary
{
    NSMutableDictionary *cellDict = [@{edCellIDKey : edMealAndMedicationSegmentedControlCellID ,
                                       edTitleKey : @"" ,
                                       edHideShowKey : @(NO)} mutableCopy];
    return cellDict;
}


- (NSMutableDictionary *) reminderCellDictionary
{
    NSMutableDictionary *cellDict = [@{edCellIDKey : edReminderCellID ,
                                       edTitleKey : @"Symptom Reminder"} mutableCopy];
    return cellDict;
}

- (NSMutableDictionary *) detailMealMedCellDictionary
{
    NSMutableDictionary *cellDict = [@{edCellIDKey : edDetailMealMedCellID ,
                                       edTitleKey : @"Add Ingredients to Meal"} mutableCopy];
    return cellDict;
}



- (NSMutableDictionary *) cellDictionaryWithCellID:(NSString *)cellID
                                       headerTitle:(NSString *)headerTitle
                                      detailString:(NSString *)detailString
                                              date:(NSDate *)date
{
    NSMutableDictionary *cellDict = [@{edCellIDKey : cellID ,
                                                     edTitleKey : headerTitle,
                                                     edDetailKey : detailString,
                                                     edDateKey : date} mutableCopy];
    return cellDict;
}


#pragma mark - Default Medication Methods
// ---------------------------------------



- (void) handleMedDoneButton
{
    
    if ([self respondsToSelector:@selector(parentMedicationsList)] &&
        [self respondsToSelector:@selector(ingredientsList)]) {
        
        if ([self.parentMedicationsList count] == 1 && [self.ingredientsList count] == 0)
        {
            // also should check the restaurant
            // but anyways, this means we don't need to create a new meal
        
            
            [self.managedObjectContext performBlockAndWait:^{
            
                [EDTakenMedication createWithMedication:self.parentMedicationsList[0] onDate:self.date1 inContext:self.managedObjectContext];
            }];
        
        }
    
        else if ([self.parentMedicationsList count] > 0 || [self.ingredientsList count] > 0)
        { // we need to create a new med first
            [self.managedObjectContext performBlockAndWait:^{
            
                EDMedication *newMed = [EDMedication createMedicationWithName:self.objectName ingredientsAdded:[NSSet setWithArray:self.ingredientsList] medicationParents:[NSSet setWithArray:self.parentMedicationsList] company:self.restaurant tags:nil forContext:self.managedObjectContext];
                
                if ([self.images count]) {
                    [newMed addUIImagesToFood:[NSSet setWithArray:self.images] error:nil];
                }
        
                [EDTakenMedication createWithMedication:newMed onDate:self.date1 inContext:self.managedObjectContext];
            }];
    }
    }
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void) medNameTextViewEditable: (UITextView *) textView
{
    if (textView) {
        
        textView.editable = YES;
    }
}

- (NSString *) medNameAsDefault
{
    return [NSString stringWithFormat:@"Medication at %@", [self eatDateAsString:self.date1]];

}
- (NSString *) medNameForDisplay
{
    if (self.defaultName) {
        return [NSString stringWithFormat:@"(Default) %@", self.objectName];
    }
    
    else if ([self.objectName isEqualToString:@""]) {
        self.objectName = [self mealNameAsDefault];
        return [NSString stringWithFormat:@"(Default) %@", self.objectName];
    }
    else {
        return self.objectName;
    }
}

- (NSMutableDictionary *) medAndIngredientCellDictionary
{
    NSMutableDictionary *medsAndIngredientsDict = [@{ edTitleKey : @"Medication and Ingredients",
                                                      edCellIDKey : edAddMedsAndIngredientsCellID} mutableCopy];
    return medsAndIngredientsDict;
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

@end
