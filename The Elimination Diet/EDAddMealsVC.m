//
//  EDAddMealsVC.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/26/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDAddMealsVC.h"
#import "EDReviewVC.h"

#import "EDData.h"
#import "EDMeal.h"

@interface EDAddMealsVC () {
    EDData *allData;
}

@end

@implementation EDAddMealsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"New Meal";
    }
    return self;
}


- (void) viewWillAppear:(BOOL)animated
{
    NSDictionary *displayMeals = [allData sortAllMealsByIngredient];
    [self updateTableObjectsAndSectionHeaders:displayMeals];
    
    self.primaryCheckedTableObjects = self.meals;

    [super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    allData = [EDData eddata];
    
    self.rightButtonStyle = NextButton;
    self.leftButtonStyle = CancelButton;
    
    self.tableAccessory = UITableViewCellAccessoryCheckmark;
    
    self.keyPathForCellTitle = @"name";
    
    self.viewControllerSequence = [[NSArray alloc]
                                   initWithObjects:[NSNumber numberWithInt:addMealSelection],
                                   [NSNumber numberWithInt:reviewMealSelection], nil];
    
    self.questionAndAnswerStacked = @[@YES];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *) titlesForQuestion
{
    return @[@"Choose Meals to Add"];
}

- (NSArray *) placeHoldersForTextFields
{
    return nil;
}

- (NSArray *) textForTextFields
{
    return nil;
}


////////// TABLE METHODS //////////////






@end
