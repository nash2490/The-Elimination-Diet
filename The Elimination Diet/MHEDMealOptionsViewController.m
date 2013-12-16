//
//  MHEDMealOptionsViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//


#import "MHEDMealOptionsViewController.h"

//#import "EDSearchToEatViewController.h"

#import "MHEDMealSummaryViewController.h"

#import "EDTableComponents.h"

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



@import MobileCoreServices;

static NSString *mhedStoryBoardSegueIDMealSummarySegue = @"MealSummarySegue";


NSString *const mhedDateCellID = @"DateCell";     // the cells with the start or end date
NSString *const mhedDatePickerID = @"DatePicker"; // the cell containing the date picker

NSString *const mhedValueCellID = @"ValueCell";
NSString *const mhedValuePickerCellID = @"ValuePickerCell";

NSString *const mhedTagCellID = @"TagCell";
NSString *const mhedImageAndNameCellID = @"ImageAndNameCell";
NSString *const mhedRestaurantCellID = @"RestaurantCell";
//NSString *const mhedAddMealsAndIngredientsCellID = @"AddMealsAndIngredientsCell";
//NSString *const mhedDetailMealsAndIngredientsCellID = @"DetailMealsAndIngredientsCell";

//NSString *const mhedAddMedsAndIngredientsCellID = @"AddMedsAndIngredientsCell";
//NSString *const mhedDetailMedsAndIngredientsCellID = @"DetailMedsAndIngredientsCell";

NSString *const mhedAddObjectsCellID = @"AddObjectsCell";
NSString *const mhedDetailObjectsCellID = @"DetailedObjectsCellID";

NSString *const mhedLargeImageCellID = @"LargeImageCell";
NSString *const mhedImageButtonCellID = @"ImageButtonCell";

NSString *const mhedShowHideCellID = @"ShowHideCell";


NSString *const mhedMealAndMedicationSegmentedControlCellID = @"MealAndMedicationSegmentedControlCell";

NSString *const mhedReminderCellID = @"ReminderCell";

//NSString *const mhedDetailMealMedCellID = @"DetailMealMedCell";



@interface MHEDMealOptionsViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)doneButtonPress:(id)sender;

@end



@implementation MHEDMealOptionsViewController




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
    
    // set the section data (self.cellArray)
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
    [self.objectsDictionary setDate:[NSDate date]];
    
    NSMutableDictionary *dateDict = [@{ mhedTableComponentTitleKey : @"Date",
                                        mhedTableComponentDateKey : self.date,
                                        mhedTableComponentCellIDKey : mhedDateCellID} mutableCopy];
    
    
    
    NSMutableDictionary *nameDict = [@{ mhedTableComponentTitleKey : @"Name and Image",
                                        mhedTableComponentCellIDKey : mhedImageAndNameCellID} mutableCopy];
    
//    NSMutableDictionary *mealsAndIngredientsDict = [@{ mhedTableComponentTitleKey : @"Meals and Ingredients",
//                                                       mhedTableComponentCellIDKey : mhedAddMealsAndIngredientsCellID} mutableCopy];
    
    NSMutableDictionary *restaurantDict = [@{ mhedTableComponentTitleKey : @"Restaurant",
                                              mhedTableComponentCellIDKey : mhedRestaurantCellID} mutableCopy];
    
    //NSMutableDictionary *tagsDict = [@{ mhedTitleKey : @"Tags",
    //                                    mhedCellIDKey : mhedTagCellID} mutableCopy];
    
    
    return @[dateDict, nameDict, restaurantDict ];
    
    
    
    
}

- (void) setupDateAndDatePickerCell
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a - M/d/yy"];
    self.dateFormatter = dateFormatter;
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:mhedDatePickerID];
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
    
//    self.mhedCarousel.delegate = nil;
//    self.mhedCarousel.dataSource = nil;
//    
//    self.imagePickerController = nil;
//    self.delegate = nil;
    
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
//    if (!self.delegate) {
//        self.delegate = self;
//    }
    
    
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





#pragma mark - Table view data source and Delegate

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [super tableView:tableView heightForHeaderInSection:section];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView: tableView heightForRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [super tableView:tableView titleForHeaderInSection:section];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView: tableView cellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *) mhedTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super mhedTableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView: tableView willSelectRowAtIndexPath:indexPath];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
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
    
    if ([segue.identifier isEqualToString:mhedStoryBoardSegueIDMealSummarySegue]) {
        
        MHEDMealSummaryViewController *destinationVC = segue.destinationViewController;
        
        destinationVC.delegate = self.dataSource;
        
    }
    
    
//    if ([segue.identifier isEqualToString:@"AddMoreFoodSegue"]) {
//        EDSearchToEatViewController *destinationVC = segue.destinationViewController;
//        destinationVC.delegate = self.delegate;
//    }
//    
//    if ([segue.identifier isEqualToString:@"AddTagSegue"]) {
//        EDSelectTagsViewController *destinationVC = segue.destinationViewController;
//        destinationVC.tagsList = [NSSet setWithArray:self.tagsList];
//        destinationVC.delegate = self;
//    }
    
    
    
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





#pragma mark - EDMealAndMedicationSegmentedControlDelegate

- (void) handleMealAndMedicationSegmentedControl: (id) sender
{
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        NSInteger selectedSegment = [(UISegmentedControl *)sender selectedSegmentIndex];
        self.medication = selectedSegment;
        NSLog(@" Creation is now Medication = %i", self.medication);
    }
}

//
//#pragma mark - EDShowHideCell delegate
//- (void) handleShowHideButtonPress:(id) sender
//{
//    // sender is the cell that
//    
//    if ([sender isKindOfClass:[EDShowHideCell class]]) {
//        EDShowHideCell *cell = (EDShowHideCell *) sender;
//        
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//        if (indexPath) {
//            
//            NSMutableDictionary *itemData = self.cellArray[indexPath.section];
//            
//            BOOL hidden = [itemData[mhedTableComponentHideShowBooleanKey] boolValue];
//            
//            // if the row is hidden and we selected the showHideCell then we want to show it
//            if (hidden) {
//                itemData[mhedTableComponentHideShowBooleanKey] = @(NO);
//                
//                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
//                
//                
//            }
//            
//            // else, if the row is shown and we select the showHideCell then we want to hide it
//            else if(!hidden && indexPath.row == 1){
//                itemData[mhedTableComponentHideShowBooleanKey] = @(YES);
//                
//                NSIndexPath *pathForLargeImageCell = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
//                
//                [self.tableView deleteRowsAtIndexPaths:@[pathForLargeImageCell] withRowAnimation:UITableViewRowAnimationBottom];
//            }
//            
//        }
//    }
//}
//




@end
