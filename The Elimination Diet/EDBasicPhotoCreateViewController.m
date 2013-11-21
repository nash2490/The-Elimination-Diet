//
//  EDBasicPhotoCreateViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/5/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDBasicPhotoCreateViewController.h"

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

#import "EDTableComponents.h"

@interface EDBasicPhotoCreateViewController ()

@property (nonatomic) BOOL tableLoaded; // yes if the table was loaded

@end

@implementation EDBasicPhotoCreateViewController



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
	// Do any additional setup after loading the view.
    
    // Date Setup
    // --------------------------------------
    [self setupDateAndDatePickerCell];
    
    
    self.imagePickerController = [self imagePickerControllerForSourceType:UIImagePickerControllerSourceTypeCamera];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // the first time we add an image we
    if (!self.tableLoaded && !self.imagePickerController) {
        self.tableLoaded = YES;
        [self.tableView reloadData];
    }
    
    //self.imagePickerController.tabBarController.tabBar.hidden = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![self.images count] && !self.cameraCanceled) {
        [super showImagePickerForCamera:self];
    }
    
    else if (self.cameraCanceled) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (BOOL)prefersStatusBarHidden
{
    if (self.imagePickerController) {
        return YES;
    }
    
    return NO;
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super navigationController:navigationController willShowViewController:viewController animated:animated];
}


#pragma mark - Table view data source and Delegate

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (!self.tableLoaded) {
        return 0;
        //return [super numberOfSectionsInTableView:tableView];

    }
    
    else {
        return [super numberOfSectionsInTableView:tableView];
    }
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
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [super tableView:tableView titleForHeaderInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableLoaded = YES;
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}





- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

}

#pragma mark - Storyboard Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    [super prepareForSegue:segue sender:sender];
    
}

#pragma mark - EDImageAndNameDelegate and Name Helpers-

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
    return [super textViewShouldBeginEditing];
}

- (void) textEnter:(UITextView *)textView
{
    [super textEnter:textView];
    
    
}

- (NSString *) eatDateAsString:(NSDate *) date
{
    return [super eatDateAsString:date];
}

- (NSString *) objectNameAsDefault
{
    return [self mealNameAsDefault];
}

- (NSString *) objectNameForDisplay
{
    return [self mealNameForDisplay];
}

#pragma mark - EDSelectTagsDelegate methods

- (void) addTagsToList: (NSSet *) tags
{
    [super addTagsToList:tags];
}



#pragma mark - EDCreateNewMealDelegate methods




- (NSArray *) mealsList
{
    if (!_mealsList) {
        _mealsList = [[NSArray alloc] init];
    }
    return _mealsList;
}

- (void) setNewMealsList: (NSArray *) newMealsList
{
    if (newMealsList) {
        self.mealsList = newMealsList;
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


- (NSArray *) ingredientsList
{
    if (!_ingredientsList) {
        _ingredientsList = [[NSArray alloc] init];
    }
    return _ingredientsList;
}




- (void) setNewIngredientsList: (NSArray *) newIngredientsList
{
    if (newIngredientsList) {
        self.ingredientsList = newIngredientsList;
    }
}




- (void) addToIngredientsList: (NSArray *) ingredients
{
    if (ingredients) {
        self.ingredientsList = [self.ingredientsList arrayByAddingObjectsFromArray:ingredients];
    }
}

- (EDRestaurant *) restaurant
{
    return [super restaurant];
}

- (void) setNewRestaurant: (EDRestaurant *) restaurant
{
    [super setNewRestaurant:restaurant];
}


- (void) addToTagsList:(NSArray *)tags
{
    [super addToTagsList:tags];
}

- (void) setNewTagsList:(NSArray *)newTagsList
{
    [super setNewTagsList:newTagsList];
}

- (UIImage *) objectImage {
    return [super objectImage];
}

- (void) setNewObjectImage:(UIImage *)newObjectImage
{
    [super setNewObjectImage:newObjectImage];
}



#pragma mark - Setup Methods to call in subclass (optional override)

- (void) setupDateAndDatePickerCell
{
    [super setupDateAndDatePickerCell];
}

- (void) setupObjectName
{
    [super setupObjectName];
}


#pragma mark - Subclass methods to Override

// override numberOfRows, and most other table delegate and data source methods

- (NSArray *) defaultDataArray
{
    self.date1 = [NSDate date];
    
    
    //NSMutableDictionary *largeImageDict = [super largeImageCellDictionary];
    
    //NSMutableDictionary *imageButtonsDict = [super imageButtonCellDictionary];
    
    NSMutableDictionary *mealOrMedDict = [super mealAndMedicationSegmentedControllCellDictionary];
    
    NSMutableDictionary *reminderDict = [super reminderCellDictionary];
    
    NSMutableDictionary *detailMealOrMedDict = [super detailMealMedCellDictionary];
    
    
    NSMutableDictionary *dateDict = [super dateCellDictionary:self.date1];
    
    
    NSMutableDictionary *restaurantDict = [super restaurantCellDictionary];
    
    NSMutableDictionary *tagsDict = [super tagCellDictionary];
    
    NSMutableDictionary *showHideDict = [super showHideCellDictionary];
    
    return @[showHideDict, mealOrMedDict, dateDict, restaurantDict, reminderDict, tagsDict, detailMealOrMedDict];
}

- (void) handleDoneButton
{
    if (self.medication) {
        [super handleMedDoneButton];
    }
    else {
        [super handleMealDoneButton];
    }
}

- (void) nameTextViewEditable: (UITextView *) textView
{
    [super mealNameTextViewEditable:textView];
    
}


@end
