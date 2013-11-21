//
//  EDBasicPhotoCreateViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/5/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDCreationViewController.h"

@class EDRestaurant;

@interface EDBasicPhotoCreateViewController : EDCreationViewController

// Meal and Ingredient Cell
@property (nonatomic, strong) NSArray *mealsList;
@property (nonatomic, strong) NSArray *ingredientsList;


#pragma mark - EDCreateNewMealDelegate methods

- (NSArray *) mealsList;
- (NSArray *) ingredientsList;
- (EDRestaurant *) restaurant;

- (void) setNewRestaurant: (EDRestaurant *) restaurant;
- (void) setNewMealsList: (NSArray *) newMealsList;
- (void) setNewIngredientsList: (NSArray *) newIngredientsList;

- (void) addToMealsList: (NSArray *) meals;
- (void) addToIngredientsList: (NSArray *) ingredients;

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

#pragma mark - EDSelectTagsDelegate methods

- (void) addTagsToList: (NSSet *) tags;


#pragma mark - Setup Methods to call in subclass (optional override)

/// call in VDL to setup
- (void) setupDateAndDatePickerCell;
- (void) setupObjectName;

- (NSString *) objectNameForDisplay;
- (NSString *) objectNameAsDefault;

#pragma mark - Subclass methods to Override

// override numberOfRows, and most other table delegate and data source methods

- (NSArray *) defaultDataArray;
- (void) handleDoneButton;

@end
