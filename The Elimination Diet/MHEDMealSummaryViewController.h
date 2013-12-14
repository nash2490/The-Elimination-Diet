//
//  MHEDMealSummaryViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/11/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MHEDFoodSelectionViewController.h"

@interface MHEDMealSummaryViewController : UITableViewController 


@property (nonatomic, weak) id <MHEDFoodSelectionViewControllerDataSource> delegate;

@end
