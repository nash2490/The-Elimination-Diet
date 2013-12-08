//
//  EDAddTableViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDCoreDataTableViewController.h"

#import "EDFood+Methods.h"
#import "EDCreationViewController.h"

@class EDRestaurant;

@interface EDAddTableViewController : EDCoreDataTableViewController


@property (nonatomic, weak) id <EDCreationDelegate> delegate;

@property (nonatomic) BOOL medicationFind;

@property (nonatomic, strong) EDRestaurant *restaurant;
@property (nonatomic, strong) NSArray *medicationList;
@property (nonatomic, strong) NSArray *mealsList;
@property (nonatomic, strong) NSArray *ingredientsList;
@property (nonatomic) FoodSortType sortBy;
@property (nonatomic) FoodTypeForTable tableFoodType;

// Must return an array of distinct NSNumber ints in [0, 1, ..., # of sections - 1]
- (NSArray *) mhedSections;
- (NSArray *)mhedSectionIndexTitles;
- (id) mhedObjectAtIndexPath: (NSIndexPath *) indexPath;


@end
