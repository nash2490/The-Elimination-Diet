//
//  MHEDMealCarouselViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/11/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDCarouselTopTableBottomViewController.h"

#import "MHEDFoodSelectionViewController.h"

@class EDRestaurant;

typedef NS_ENUM(NSInteger, MHEDMealCarouselInputType) {
    MHEDMealCarouselInputTypeQuickCapture = 1,
    MHEDMealCarouselInputTypeFillinType
};






@interface MHEDMealCarouselViewController : MHEDCarouselTopTableBottomViewController < UIImagePickerControllerDelegate, UINavigationControllerDelegate>



@property (nonatomic) MHEDMealCarouselInputType inputType;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) BOOL keyboardVisible;


// Name
@property (nonatomic, strong) NSString *objectName;
@property (nonatomic) BOOL defaultName;

// Tags
@property (nonatomic, strong) NSArray *tagsList;
@property (nonatomic) BOOL favorite;

// Meal Medication Segmented Control
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
@property (nonatomic) NSInteger pickerCellRowHeight;


#pragma mark - Image Capture

@property (nonatomic, weak) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) NSArray *capturedImages;

@property (nonatomic) BOOL cameraCanceled; // says if we just called cancel


#pragma mark - UIImagePickerController methods

- (void)showImagePickerForCamera:(id)sender;
- (UIImagePickerController *) imagePickerControllerForSourceType: (UIImagePickerControllerSourceType) sourceType;

#pragma mark - EDImageButtonCell delegate
- (void) handleTakeAnotherPictureButton: (id) sender;
- (void) handleDeletePictureButton:(id)sender;



#pragma mark - MHEDFoodSelectionViewControllerDataSource methods

- (NSArray *) mealsList;
- (void) setNewMealsList: (NSArray *) newMealsList;
- (void) addToMealsList: (NSArray *) meals;
- (void) removeMealsFromMealsList: (NSArray *) meals;
- (BOOL) doesMealsListContainMeals:(NSArray *) meals;

- (NSArray *) ingredientsList;
- (void) setNewIngredientsList: (NSArray *) newIngredientsList;
- (void) addToIngredientsList: (NSArray *) ingredients;
- (void) removeIngredientsFromIngredientsList: (NSArray *) ingredients;
- (BOOL) doesIngredientsListContainIngredients:(NSArray *) ingredients;

- (NSArray *) medicationsList;
- (void) setNewMedicationsList: (NSArray *) newMedicationsList;
- (void) addToMedicationsList: (NSArray *) medications;
- (void) removeMedicationsFromMedicationsList: (NSArray *) medications;
- (BOOL) doesMedicationsListContainMedications:(NSArray *) medications;





@end
