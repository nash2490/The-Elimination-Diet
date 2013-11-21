//
//  EDRecentFoodViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/25/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDCoreDataTableViewController.h"

@interface EDRecentFoodViewController : EDCoreDataTableViewController

- (void)performFetch;

- (void) changeFetchedResultsControllerToFetchRequest: (NSFetchRequest *) fetch;



@end
