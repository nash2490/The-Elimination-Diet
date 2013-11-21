//
//  EDAddScreenViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/18/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDViewController.h"

@interface EDAddScreenViewController : EDViewController


@property (nonatomic, strong) UILabel *eatLabel;
@property (nonatomic, strong) UILabel *medicationLabel;
@property (nonatomic, strong) UILabel *healthLabel;



// Eat buttons
@property (nonatomic, strong) UIButton *mealExistingButton;
@property (nonatomic, strong) UIButton *mealNewButton;
@property (nonatomic, strong) UIButton *mealRestaurantButton;


// Medication Buttons
@property (nonatomic, strong) UIButton *medicationExistingButton;
@property (nonatomic, strong) UIButton *medicationNewButton;


// Health Buttons
@property (nonatomic, strong) UIButton *healthSymptomsButton;
@property (nonatomic, strong) UIButton *healthEnergyButton;
@property (nonatomic, strong) UIButton *healthBowelButton;

@end
