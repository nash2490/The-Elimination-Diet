//
//  EDEatSelectionViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/26/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEatSelectionViewController.h"

#import "EDData.h"
#import "EDMeal.h"
#import "EDReviewVC.h"

// not sure if i want this here or in category
#import "EDAddMealsVC.h"

@interface EDEatSelectionViewController (){
    EDData *allData;
}

@end

@implementation EDEatSelectionViewController

///////// VIEW CONTROLLER //////////////
- (NSArray *) viewControllerSequence
{
    if (!_viewControllerSequence) {
        _viewControllerSequence = [[NSArray alloc]
                                   initWithObjects:[NSNumber numberWithInt:addMealSelection],
                                   [NSNumber numberWithInt:addIngredientsSelection],
                                   [NSNumber numberWithInt:chooseRestaurantSelection],
                                   [NSNumber numberWithInt:chooseDateSelection],
                                   [NSNumber numberWithInt:chooseNameSelection],
                                   [NSNumber numberWithInt:reviewMealSelection],nil];
    }
    return _viewControllerSequence;
}




//////// MEAL PROPERTIES /////////////
- (NSSet *) meals {
    if (!_meals) {
        if (self.startObject
            && [self.startObject isKindOfClass:[NSString class]]
            && [allData mealForName:self.startObject])
        {
            _meals = [[allData mealsForMeal:self.startObject] copy];
        }
        else {
            _meals = [[NSSet alloc] init];
        }
    }
    return _meals;
}

- (NSSet *) ingredients {
    if (!_ingredients) {
        if (self.startObject
            && [self.startObject isKindOfClass:[NSString class]]
            && [allData mealForName:self.startObject])
        {
            _ingredients = [[allData ingredientsForMeal:self.startObject] copy];
        }
        else {
            _ingredients = [[NSSet alloc] init];
        }
    }
    return _ingredients;
}

- (NSString *) restaurant {
    if (!_restaurant) {
        if (self.startObject
            && [self.startObject isKindOfClass:[NSString class]]
            && [allData mealForName:self.startObject])
        {
            _restaurant = [[allData restaurantForMealName:self.startObject] copy];
        }
        else {
            _restaurant = @"";
        }
    }
    return _restaurant;
}


//////////// METHODS /////////////////////
- (id) initWithStartObject:(id)obj
{
    self = [self initWithNibName:nil bundle:NULL];
    if (self) {
        if (obj && [obj isKindOfClass:[NSString class]]) {
            self.startObject = obj;
        }
    }
    return self;
}

- (id) initWithStartObject:(NSString *)startObject
                  MealName:(NSString *)mealName
                     Meals:(NSSet *)meals andIngredients:(NSSet *)ingredients
             andRestaurant:(NSString *)restaurant
                   andDate:(NSString *)date
{
    self = [self initWithStartObject:startObject];
    
    if (self) {
        self.mealName = mealName;
        self.meals = meals;
        self.ingredients = ingredients;
        self.restaurant = restaurant;
        self.eatDate = date;
    }
    
    return self;
}


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
    allData = [EDData eddata];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///////// NAV BUTTON PRESS //////////////




- (void) handleLeftNavButtonPress:(id)sender
{
    [super handleLeftNavButtonPress:sender];
}

- (void) handleRightNavButtonPress:(id)sender
{
    [self nextViewController];
}

- (void) nextViewController
{
    
    
    NSNumber *nextVC = [self.viewControllerSequence objectAtIndex:self.viewControllerInSequence];
    
    // need to do the next vc not self.viewControllerInSequence
    
    
    if ([nextVC intValue] == addMealSelection) {
        
        
        EDAddMealsVC *addVC =
            [[EDAddMealsVC alloc] initWithStartObject:self.startObject
                                             MealName:self.mealName
                                                Meals:self.meals
                                       andIngredients:self.ingredients
                                        andRestaurant:self.restaurant
                                              andDate:self.eatDate];
        
        addVC.viewControllerSequence = self.viewControllerSequence;
        addVC.viewControllerInSequence = self.viewControllerInSequence +1;
        
        [self.navigationController pushViewController:addVC animated:YES];
    }
    
    else if ([nextVC intValue] == reviewMealSelection) {
        
        EDReviewVC *addVC =
        [[EDReviewVC alloc] initWithStartObject:self.startObject
                                         MealName:self.mealName
                                            Meals:self.meals
                                   andIngredients:self.ingredients
                                    andRestaurant:self.restaurant
                                          andDate:self.eatDate];
        
        addVC.viewControllerSequence = self.viewControllerSequence;
        addVC.viewControllerInSequence = self.viewControllerInSequence +1;
        
        [self.navigationController pushViewController:addVC animated:YES];
    }
    
    else if ([nextVC intValue] == endMealSelection) {
        
        NSUInteger popOffNumber = self.viewControllerInSequence +1;
        UIViewController *popTo = [self.navigationController.viewControllers objectAtIndex:popOffNumber];
        [self.navigationController popToViewController:popTo animated:YES];
    }
}

@end
