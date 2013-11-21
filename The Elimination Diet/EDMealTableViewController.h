//
//  EDMealTableViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/5/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDCoreDataTableViewController.h"

@interface EDMealTableViewController : EDCoreDataTableViewController


// Must return an array of distinct NSNumber ints in [0, 1, ..., # of sections - 1]
- (NSArray *) edSections;
- (NSArray *)edSectionIndexTitles;
- (id) edObjectAtIndexPath: (NSIndexPath *) indexPath;

@end
