//
//  EDEliminatedFoodTableViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/31/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDCoreDataTableViewController.h"

typedef enum {AllEliminated, AllCurrentEliminated, TypesEliminated, IngredientsEliminated, MealsEliminated, RestaurantsEliminated} EliminatedFoodSubtype;
typedef enum {SortByName, SortByEndDate, SortByStartDate, SortByCurrent} EliminatedFoodDisplaySort;

@interface EDEliminatedFoodTableViewController : EDCoreDataTableViewController

@property (nonatomic) EliminatedFoodSubtype subtype;
@property (nonatomic) EliminatedFoodDisplaySort sortBy;

@end
