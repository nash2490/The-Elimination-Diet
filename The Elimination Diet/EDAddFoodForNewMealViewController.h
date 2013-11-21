//
//  EDAddFoodForNewMealViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/9/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "EDCreateNewMealViewController.h"
#import "EDEatNewMealViewController.h"

@class EDRestaurant;

@interface EDAddFoodForNewMealViewController : UITableViewController <UISearchBarDelegate>

@property (nonatomic, weak) id <EDCreationDelegate> delegate;

@property (nonatomic, strong) EDRestaurant *restaurant;
@property (nonatomic) BOOL medication;
@property (nonatomic, strong) NSArray *mealsList;
@property (nonatomic, strong) NSArray *ingredientsList;

@end
