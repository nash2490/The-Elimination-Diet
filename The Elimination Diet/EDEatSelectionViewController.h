//
//  EDEatSelectionViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/26/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

typedef enum {addMealSelection, addIngredientsSelection, chooseRestaurantSelection, chooseDateSelection, chooseNameSelection, reviewMealSelection, endMealSelection} NextEatVC;

#import "EDSelectionViewController.h"

@interface EDEatSelectionViewController : EDSelectionViewController

// view controller sequence properties ///////////// not sure if this should be in category

@property (nonatomic) NSUInteger viewControllerInSequence; // number of vc that came before
@property (nonatomic, strong) NSArray *viewControllerSequence; // of NextEatVC

// meal properties ////////////////////////////
@property (nonatomic, strong) NSString *startObject; // could be a meal name, restaurant name, time

@property (nonatomic, strong) NSString *mealName;
@property (nonatomic, strong) NSSet *meals;
@property (nonatomic, strong) NSSet *ingredients;
@property (nonatomic, strong) NSString *restaurant;
@property (nonatomic, strong) NSString *eatDate;



- (id) initWithStartObject: (NSString *) startObject
                  MealName: (NSString *) mealName
                     Meals: (NSSet *) meals
            andIngredients: (NSSet *) ingredients
             andRestaurant: (NSString *) restaurant
                   andDate: (NSString *) date;

- (void) nextViewController;
@end
