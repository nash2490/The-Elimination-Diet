//
//  EDTakeNewMedicationViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/29/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDCreationViewController.h"

@class EDRestaurant;

@interface EDTakeNewMedicationViewController : EDCreationViewController


@property (nonatomic, strong) NSArray *parentMedicationsList; // MedicationDoses
@property (nonatomic, strong) NSArray *ingredientsList;


#pragma mark - EDCreateNewMealDelegate methods

- (EDRestaurant *) restaurant;
- (void) setNewRestaurant: (EDRestaurant *) restaurant;

- (NSArray *) ingredientsList;
- (void) setNewIngredientsList: (NSArray *) newIngredientsList;
- (void) addToIngredientsList: (NSArray *) ingredients;

- (NSArray *) parentMedicationsList; // for medication creation
- (void) setNewMedicationsList: (NSArray *) newMedicationsList;
- (void) addToMedicationsList: (NSArray *) medications;

- (NSArray *) tagsList;
- (void) addToTagsList: (NSArray *) tags;
- (void) setNewTagsList: (NSArray *) newTagsList;

- (UIImage *) objectImage; // when we want images
- (void) setNewObjectImage: (UIImage *) newObjectImage;


#pragma mark - EDImageAndNameDelegate methods
- (NSString *) defaultTextForNameTextView; // override in subclass
- (BOOL) textViewShouldClear;
- (void) setNameAs: (NSString *) newName;
- (BOOL) textViewShouldBeginEditing;
- (void) textEnter:(UITextView *)textView;



#pragma mark - Setup Methods to call in subclass (optional override)

- (void) setupDateAndDatePickerCell;
- (void) setupObjectName;
- (NSString *) objectNameForDisplay;

- (NSString *) objectNameAsDefault;

#pragma mark - Subclass methods to Override

// override numberOfRows, and most other table delegate and data source methods

- (NSArray *) defaultDataArray;
- (void) handleDoneButton;

@end
