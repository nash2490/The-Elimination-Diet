//
//  MHEDCarouselBrowseViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/11/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDCarouselBrowseViewController.h"

#import "EDTagCell.h"
#import "EDMealAndMedicationSegmentedControlCell.h"
#import "EDImageAndNameCell.h"
#import "EDShowHideCell.h"

#import "EDTag+Methods.h"
#import "EDRestaurant+Methods.h"
#import "EDMeal+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDEatenMeal+Methods.h"

#import "EDDocumentHandler.h"

#import "NSString+MHED_EatDate.h"
#import "UIImage+MHED_fixOrientation.h"

#import "EDTableComponents.h"


@interface MHEDCarouselBrowseViewController ()

@end

@implementation MHEDCarouselBrowseViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [super tableView:tableView titleForHeaderInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}





- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get sectionData
    NSMutableDictionary *sectionData = self.cellArray[indexPath.section];
    
    if ([sectionData[mhedTableComponentSectionKey] isEqualToString:mhedTableSectionIDBrowseSection]) {
        // then we selected the row 
    }
    
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
}




#pragma mark - Storyboard Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    [super prepareForSegue:segue sender:sender];
    
}


#pragma mark - EDImageButtonCell delegate


- (void) handleDeletePictureButton:(id)sender
{
    [super handleDeletePictureButton:sender];
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




#pragma mark - Setup Methods to call in subclass (optional override)

- (void) setupObjectName
{
    [super setupObjectName];
}


#pragma mark - Subclass methods to Override

// override numberOfRows, and most other table delegate and data source methods

- (NSArray *) defaultDataArray
{
    self.date1 = [NSDate date];
    
    NSMutableDictionary *largeImageSectionDict = [super largeImageSectionDictionary];
    
    
    //NSMutableDictionary *largeImageDict = [super largeImageCellDictionary];
    
    //NSMutableDictionary *imageButtonsDict = [super imageButtonCellDictionary];
    
    NSMutableDictionary *mealOrMedDict = [super mealAndMedicationSegmentedControllSectionDictionary];
    
    NSMutableDictionary *reminderDict = [super reminderSectionDictionary];
    
    NSMutableDictionary *detailMealOrMedDict = [super detailMealMedicationSectionDictionary];
    
    
    NSMutableDictionary *dateDict = [super dateSectionDictionary:self.date1];
    
    
    NSMutableDictionary *restaurantDict = [super restaurantSectionDictionary];
    
    NSMutableDictionary *tagsDict = [super tagSectionDictionary];
    
    //    NSMutableDictionary *showHideDict = [super showHideCellDictionary];
    
    return @[largeImageSectionDict, mealOrMedDict, dateDict, restaurantDict, reminderDict, tagsDict, detailMealOrMedDict];
}

- (void) handleDoneButton
{
    if (self.medication) {
        [super handleMedicationDoneButton];
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
