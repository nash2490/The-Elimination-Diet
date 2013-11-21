//
//  EDAddScreenViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/18/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDAddScreenViewController.h"

@interface EDAddScreenViewController ()

@end

@implementation EDAddScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Add";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect) setUpTopViewFrame {
    return self.view.bounds;
}

- (UIView *) setUpTopView: (CGRect) frame {
    UIView *tempView = [[UIView alloc] initWithFrame:frame];
    tempView.backgroundColor = TAN_YELLOW_BACKGROUND;
    tempView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    
    // Eat section -----
    //      eat label
    CGRect eatLabelRect = CGRectMake(20.0, 10.0, 50.0, 20.0);
    self.eatLabel = [self defaultLabelWithFrame:eatLabelRect andString:@"Eat"];
    [tempView addSubview:self.eatLabel];
    
    //      eat buttons
    CGRect eatExistingRect = CGRectMake(40.0, 40.0, 100.0, 20.0);
    CGRect eatNewRect = CGRectMake(40.0, 70.0, 100.0, 20.0);
    CGRect eatRestaurantRect = CGRectMake(40.0, 100.0, 100.0, 20.0);
    self.mealExistingButton = [self defaultButtonWithFrame:eatExistingRect title:@"Existing Meal" withSelector:@selector(mealExistingButtonPress:)];
    self.mealNewButton = [self defaultButtonWithFrame:eatNewRect title:@"New Meal" withSelector:@selector(mealExistingButtonPress:)];
    self.mealRestaurantButton = [self defaultButtonWithFrame:eatRestaurantRect title:@"From Restaurant" withSelector:@selector(mealExistingButtonPress:)];

    [tempView addSubview:self.mealExistingButton];
    [tempView addSubview:self.mealNewButton];
    [tempView addSubview:self.mealRestaurantButton];
    
    
    // Medication section -------
    
    
    // Health Section --------
    
    
    
    return tempView;
}

- (void) mealExistingButtonPress: (id) sender
{
    
}

- (void) mealNewButtonPress: (id) sender
{
    
}

- (void) mealRestaurantButtonPress: (id) sender
{
    
}
@end
