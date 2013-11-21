//
//  EDReviewVC.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/26/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDReviewVC.h"
#import "EDData.h"
#import "EDMeal.h"

@interface EDReviewVC (){
    EDData *allData;
}

@end

@implementation EDReviewVC

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
    return @[@"Choose Meals to Add", @" fuck"];
}

- (NSArray *) placeHoldersForTextFields
{
    return @[@"Choose Meals to Add", @" fuck"];
}

- (NSArray *) textForTextFields
{
    return @[@"Choose Meals to Add", @" fuck"];
}

@end
