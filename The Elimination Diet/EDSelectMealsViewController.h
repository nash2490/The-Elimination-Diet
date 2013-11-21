//
//  EDSelectMealsViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/6/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDSelectionViewController.h" // should inherit from here

@interface EDSelectMealsViewController : EDSelectionViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIButton *allMealsButton;
@property (nonatomic, strong) UIButton *recentMealsButton;
@property (nonatomic, strong) UIButton *favoriteMealsButton;
@property (nonatomic, strong) UIButton *typesMealsButton;






@end
