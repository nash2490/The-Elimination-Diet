//
//  EDAddMealTableViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/9/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDMealTableViewController.h"

//#import "EDEatMealViewController.h"
#import "EDEatNewMealViewController.h"

#import "EDFood+Methods.h"

@class EDRestaurant;


@interface EDAddMealTableViewController : EDMealTableViewController

@property (nonatomic, weak) id <EDCreationDelegate> delegate;

@property (nonatomic) BOOL medicationFind;

@property (nonatomic, strong) EDRestaurant *restaurant;
@property (nonatomic, strong) NSArray *medicationList;
@property (nonatomic, strong) NSArray *mealsList;
@property (nonatomic, strong) NSArray *ingredientsList;
@property (nonatomic) FoodSortType sortBy;
@property (nonatomic) FoodTypeForTable tableFoodType;

@end
