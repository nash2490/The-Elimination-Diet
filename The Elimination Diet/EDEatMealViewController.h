//
//  EDEatMealViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/15/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EDImageAndNameCell.h"

@class EDRestaurant;

@protocol EDEatMealDelegate <NSObject>

- (NSArray *) mealsList;
- (NSArray *) ingredientsList;
- (EDRestaurant *) restaurant;

- (void) setNewRestaurant: (EDRestaurant *) restaurant;
- (void) setNewMealsList: (NSArray *) newMealsList;
- (void) setNewIngredientsList: (NSArray *) newIngredientsList;

- (void) addToMealsList: (NSArray *) meals;
- (void) addToIngredientsList: (NSArray *) ingredients;

@optional

- (NSArray *) tagsList;
- (void) addToTagsList: (NSArray *) tags;
- (void) setNewTagsList: (NSArray *) newTagsList;
- (void) setNewFoodImage: (UIImage *) newFoodImage;

@end

@interface EDEatMealViewController : UITableViewController <EDEatMealDelegate, EDImageAndNameDelegate>


@property (nonatomic, weak) id <EDEatMealDelegate> delegate;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic) BOOL medication;

@property (nonatomic, strong) NSDate *eatDate;

// Image and Name cell
@property (nonatomic, strong) UIImage *foodImage;
@property (nonatomic, strong) NSString *foodName;
@property (nonatomic) BOOL defaultName;

// Restaurant Cell
@property (nonatomic, strong) EDRestaurant *restaurant;

// Meal and Ingredient Cell
@property (nonatomic, strong) NSArray *mealsList;
@property (nonatomic, strong) NSArray *ingredientsList;

// Core Data
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


// EDCreateNewMealDelegate methods
- (void) setNewRestaurant: (EDRestaurant *) restaurant;
- (void) setNewMealsList: (NSArray *) newMealsList;
- (void) setNewIngredientsList: (NSArray *) newIngredientsList;
- (void) setNewFoodImage: (UIImage *) newFoodImage;

- (void) addToMealsList: (NSArray *) meals;
- (void) addToIngredientsList: (NSArray *) ingredients;

// EDImageAndNameDelegate methods
- (NSString *) defaultTextForNameTextView;
- (BOOL) textViewShouldClear;
- (void) setNameAs: (NSString *) newName;
- (BOOL) textViewShouldBeginEditing;
- (void) textEnter:(UITextView *)textView;

@end
