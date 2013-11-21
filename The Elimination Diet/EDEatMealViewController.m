//
//  EDEatMealViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/15/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEatMealViewController.h"

#import "EDSearchToEatViewController.h"

#import "EDTagCell.h"
#import "EDMealAndMedicationSegmentedControlCell.h"
#import "EDImageAndNameCell.h"

#import "EDTag+Methods.h"
#import "EDRestaurant+Methods.h"
#import "EDMeal+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDEatenMeal+Methods.h"

#import "EDDocumentHandler.h"

#import "NSString+EatDate.h"



@interface EDEatMealViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)doneButtonPress:(id)sender;

@property (weak, nonatomic) UITextView *foodNameTextView;

// Date Cell
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

// keep track which indexPath points to the cell with UIDatePicker, if nil then it is NOT visible,
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (assign) NSInteger pickerCellRowHeight;

@property (nonatomic) NSInteger mealCycle;


@property (nonatomic) BOOL keyboardVisible;

@end




@implementation EDEatMealViewController

- (NSArray *) mealsList
{
    if (!_mealsList) {
        _mealsList = [[NSArray alloc] init];
    }
    return _mealsList;
}

- (NSArray *) ingredientsList
{
    if (!_ingredientsList) {
        _ingredientsList = [[NSArray alloc] init];
    }
    return _ingredientsList;
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
    
    self.medication = NO;
    self.mealCycle = 0;
    self.defaultName = YES;
    self.keyboardVisible = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // setup our data source
    //NSMutableDictionary *mealSegmentedControlDict = [@{ edCellIDKey : edMealSegmentedControlCellID} mutableCopy];
    
    NSMutableDictionary *dateDict = [@{ edTitleKey : @"Date",
                                        edDateKey : [NSDate date],
                                        edCellIDKey : edDateCellID} mutableCopy];
    
    self.eatDate = [NSDate date];
    
    NSMutableDictionary *nameDict = [@{ edTitleKey : @"Name and Image",
                                        edCellIDKey : edImageAndNameCellID} mutableCopy];
    
    NSMutableDictionary *mealsAndIngredientsDict = [@{ edTitleKey : @"Meals and Ingredients",
                                                       edCellIDKey : edAddMealsAndIngredientsCellID} mutableCopy];
    
    NSMutableDictionary *restaurantDict = [@{ edTitleKey : @"Restaurant",
                                              edCellIDKey : edRestaurantCellID} mutableCopy];
    
    //NSMutableDictionary *tagsDict = [@{ edTitleKey : @"Tags",
    //                                    edCellIDKey : edTagCellID} mutableCopy];
    
    
    self.dataArray = @[dateDict, mealsAndIngredientsDict, nameDict, restaurantDict, ];
    
//    self.dateFormatter = [[NSDateFormatter alloc] init];
//    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
//    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a - M/d/yy"];
    self.dateFormatter = dateFormatter;
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:edDatePickerID];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
    
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
        
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBackToHomePage)];
        
        leftBarButton.tintColor = [UIColor redColor];
        [self.navigationItem setLeftBarButtonItem:leftBarButton animated:NO];
        
    }
    
    // if the first time we get info directly from previous and not from delegate
    // but then we want to set self as delegate for future
    if (self.mealCycle == 0) {
        self.delegate = self;
    }
    else if (self.mealCycle >0) {
        self.mealsList = [self.delegate mealsList];
        self.ingredientsList = [self.delegate ingredientsList];
        self.restaurant = [self.delegate restaurant];
    }
    
    if (!self.managedObjectContext) {
        [[EDDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            
            //[self setManagedObjectContext:document.managedObjectContext];
            self.managedObjectContext = document.managedObjectContext;
        }
         ];
    }
    
    
    // Set up name
    if (self.defaultName || !self.foodName || [self.foodName isEqualToString:@""]) {
        self.defaultName = YES;
        self.foodName = [self foodNameAsDefault];
    }
    
    
    
    [self.tableView reloadData];
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
            //
            NSDictionary *itemData = self.dataArray[0];
            [targetedDatePicker setDate:[itemData valueForKey:edDateKey] animated:NO];
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

#pragma mark - Actions

- (void) goBackToHomePage
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)doneButtonPress:(id)sender {
    
    
    if (self.keyboardVisible) {
        [self textEnter:self.foodNameTextView];
        self.keyboardVisible = NO;
    }
    
    if ([self.mealsList count] == 1 && [self.ingredientsList count] == 0)
    {
        // also should check the restaurant
        // but anyways, this means we don't need to create a new meal
    
        
        [self.managedObjectContext performBlockAndWait:^{
            [EDEatenMeal createEatenMealWithMeal:self.mealsList[0] atTime:self.eatDate forContext:self.managedObjectContext];

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
            
            [EDEatenMeal createEatenMealWithMeal:newMeal atTime:self.eatDate forContext:self.managedObjectContext];
        }];
    }
    
    else
    { // we need to create a new new meal first
        [self.managedObjectContext performBlockAndWait:^{
            EDMeal *newMeal = [EDMeal createMealWithName:self.foodName
                                        ingredientsAdded:[NSSet setWithArray:self.ingredientsList]
                                             mealParents:[NSSet setWithArray:self.mealsList]
                                              restaurant:self.restaurant tags:nil
                                              forContext:self.managedObjectContext];
            
            [EDEatenMeal createEatenMealWithMeal:newMeal atTime:self.eatDate forContext:self.managedObjectContext];
        }];
    }
    
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    [itemData setValue:targetedDatePicker.date forKey:edDateKey];
    self.eatDate = targetedDatePicker.date;
    // update the cell's date string
    cell.detailTextLabel.text = [self eatDateAsString];
    
    // update name if its the default
    if (self.defaultName) {
        self.foodName = [self foodNameAsDefault];
        self.foodNameTextView.text = [self foodNameForDisplay];
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
            if (foodIndex && foodIndex == [self.mealsList count]){ // the ingredient section seperator row
                return 1;
            }
            else {
                return 2;
            }
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) { // rows are the meals + ingredients + add row
        NSUInteger rowCount = [self.mealsList count] + [self.ingredientsList count] + 1;
        if ([self.mealsList count]) {
            rowCount++;
        }
        if ([self.ingredientsList count]) {
            rowCount++;
        }
        return rowCount;
    }
    
    else if (section == 0 && [self hasInlineDatePicker]) {
        return 2;
    }
    
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    return 20;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemData = self.dataArray[indexPath.section];
    if ([itemData[edCellIDKey] isEqualToString:edImageAndNameCellID]) {
        return 79;
    }
    
    else if ([itemData[edCellIDKey] isEqualToString:edAddMealsAndIngredientsCellID]) {
        
        if (indexPath.row == 1) { // always a food separator row
            return 20;
            
        }
        
        else if (indexPath.row >1) {
            NSInteger foodIndex = indexPath.row - 2;
            if (foodIndex && foodIndex == [self.mealsList count]){ // the ingredient section seperator row
                return 20;
            }
        }
    }
    
    else if ([self indexPathHasPicker:indexPath]) {
        return self.pickerCellRowHeight;
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
    
    if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row <= indexPath.row)
    {
        modelRow--;
    }
    
    NSDictionary *itemData = self.dataArray[modelSection];
    
    NSString *cellID = itemData[edCellIDKey];
    
    UITableViewCell *cell = nil;
    if ([self indexPathHasPicker:indexPath])
    {
        // the indexPath is the one containing the inline date picker the current/opened date picker cell
        // used because we don't define the datePicker in self.dataArray
        cellID = edDatePickerID;
    }
    
    else
    {
        cellID = itemData[edCellIDKey];
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    
    
    cell.textLabel.text = [itemData valueForKey:edTitleKey];
    
    if ([cellID isEqualToString:edDatePickerID]) {
        cell.textLabel.text = nil;

        UIDatePicker *checkDatePicker = (UIDatePicker *)[cell viewWithTag:edDatePickerTag];
        [checkDatePicker setMaximumDate: [EDEvent endOfDay:[NSDate date]]];
    }
    
    // proceed to configure our cell
    if ([cellID isEqualToString:edDateCellID])
    {
        // we have either start or end date cells, populate their date field
        //
        
        
        
        
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[itemData valueForKey:edDateKey]];
    }
    
    else if ([cellID isEqualToString:edImageAndNameCellID]) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        
        
        ((EDImageAndNameCell *) cell).imageView.image = self.foodImage;
        //((EDImageAndNameCell *) cell).nameTextView.text = self.foodName;
        
        self.foodNameTextView = ((EDImageAndNameCell *) cell).nameTextView;
        ((EDImageAndNameCell *) cell).delegate = self;
        self.foodNameTextView.text = [self foodNameForDisplay];
        
        if (self.foodNameTextView) {
        
            if ([self.mealsList count] == 1 && [self.ingredientsList count] == 0) {
                self.foodNameTextView.selectable = NO;
            }
            else {
                self.foodNameTextView.selectable = YES;
            }
            
            if (self.defaultName) {
                self.foodNameTextView.textColor = [UIColor grayColor];
            }
            else {
                self.foodNameTextView.textColor = [UIColor blackColor];
            }
        }
        
        

    }
    
    else if ([cellID isEqualToString:edRestaurantCellID]) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.textLabel.text = self.restaurant.name;
    }
    
    else if ([cellID isEqualToString:edAddMealsAndIngredientsCellID]) {
        if (indexPath.row == 0) { // then we use the add meals cell
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
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
        
        // enable scrolling again
        self.tableView.scrollEnabled = YES;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
        
        // disable scrolling
        self.tableView.scrollEnabled = NO;
        if (self.keyboardVisible) {
            [self textEnter:self.foodNameTextView];
            self.keyboardVisible = NO;
        }
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
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
        NSDictionary *itemData = self.dataArray[indexPath.section];
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
        [self.delegate increaseMealCycle];
    }
}


#pragma mark - EDCreateNewMealDelegate methods
- (void) setNewRestaurant: (EDRestaurant *) restaurant
{
    if (restaurant) {
        self.restaurant = restaurant;
    }
}

- (void) setNewMealsList: (NSArray *) newMealsList
{
    if (newMealsList) {
        self.mealsList = newMealsList;
    }
}

- (void) setNewIngredientsList: (NSArray *) newIngredientsList
{
    if (newIngredientsList) {
        self.ingredientsList = newIngredientsList;
    }
}

- (void) setNewFoodImage: (UIImage *) newFoodImage
{
    if (newFoodImage) {
        self.foodImage = newFoodImage;
    }
}

- (void) addToMealsList: (NSArray *) meals
{
    if (meals) {
        self.mealsList = [self.mealsList arrayByAddingObjectsFromArray:meals];
        for (EDTag *tag in [meals[0] tags]) {
            NSLog(@"tag name = %@", tag.name);
        }
    }
}

- (void) addToIngredientsList: (NSArray *) ingredients
{
    if (ingredients) {
        self.ingredientsList = [self.ingredientsList arrayByAddingObjectsFromArray:ingredients];
    }
}

- (NSInteger) mealCycle
{
    return _mealCycle;
}

- (void) increaseMealCycle
{
    _mealCycle++;
}


#pragma mark - EDImageAndNameDelegate and Name Helpers-

- (NSString *) defaultTextForNameTextView
{
    self.foodName = [self foodNameAsDefault];
    self.defaultName = YES;
    return [self foodNameForDisplay];
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
        self.foodName = newName;
        self.defaultName = NO;
    }
}


- (BOOL) textViewShouldBeginEditing
{
    // if the date picker is visible we need to dismiss
    [self displayInlineDatePickerForRowAtIndexPath:[NSIndexPath indexPathForRow:self.datePickerIndexPath.row -1 inSection:0]];
    
    return YES;
}

- (void) textEnter:(UITextView *)textView
{
    [textView resignFirstResponder];
    
    if (self.foodNameTextView.text && ![self.foodNameTextView.text isEqualToString:@""]) {
        [self setNameAs:self.foodNameTextView.text];
    }
    
    else if ([self.foodNameTextView.text isEqualToString:@""]) {
        self.foodNameTextView.text = [self defaultTextForNameTextView]; // also sets the name automatically
        self.foodNameTextView.textColor = [UIColor grayColor];
    }
    
    
}

- (NSString *) eatDateAsString
{
    if (!self.dateFormatter) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm a - M/d/yy"];
        self.dateFormatter = dateFormatter;
    }
    
    return [self.dateFormatter stringFromDate:self.eatDate];
}

- (NSString *) foodNameAsDefault
{
    if ([self.mealsList count] == 1 && [self.ingredientsList count] == 0) {
        EDMeal *meal = self.mealsList[0];
        return meal.name;
    }
    
    else if ([self.mealsList count] == 0 && [self.ingredientsList count] == 1) {
        EDIngredient *ingr = self.ingredientsList[0];
        return [NSString stringWithFormat:@"Meal with %@", ingr.name];
    }
    
    return [NSString stringWithFormat:@"Meal at %@", [self eatDateAsString]];
}

- (NSString *) foodNameForDisplay
{
    if ([self.mealsList count] == 1 && [self.ingredientsList count] == 0) {
        return [NSString stringWithFormat:@"(Add another meal or ingredient) %@", [self foodNameAsDefault]];
    }
    else if ([self.mealsList count] == 0 && [self.ingredientsList count] == 1) {
        return [NSString stringWithFormat:@"(Add another meal or ingredient) %@", [self foodNameAsDefault]];
    }
    
    else if (self.defaultName) {
        return [NSString stringWithFormat:@"(Default) %@", self.foodName];
    }
    
    else if ([self.foodName isEqualToString:@""]) {
        self.foodName = [self foodNameAsDefault];
        return [NSString stringWithFormat:@"(Default) %@", self.foodName];
    }
    else {
        return self.foodName;
    }
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

