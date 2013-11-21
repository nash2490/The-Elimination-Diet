//
//  EDSelectionViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/6/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDViewController.h"

@interface EDSelectionViewController : EDViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchBarDelegate>

#pragma mark - Core Data and Table Objects -
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSDictionary *fetchRequests;

@property (nonatomic, strong) NSString *stringForFetch;
@property (nonatomic, strong) NSDictionary *fetchedObjects;

@property (nonatomic, strong) NSArray *sectionHeaders;
@property (nonatomic, strong) NSArray *sectionIndexHeaders;

@property (nonatomic, strong) NSSet *selectedObjects;

#pragma mark - Views and Buttons -
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;


//@property (nonatomic, strong) UIButton *allButton;
//@property (nonatomic, strong) UIButton *recentButton;
//@property (nonatomic, strong) UIButton *favoriteButton;
//@property (nonatomic, strong) UIButton *typeButton;

/*
// sorting of discrete property values into obvious sections
- (NSArray *) sortDiscreteIntoSectionsArray: (NSArray *) objects
                                 byProperty: (NSString *) property
                                  ascending: (BOOL) ascending
                       sectionCompareMethod: (SEL) selectionCompareMethod;
*/
- (void) performFetch;
- (id) getObjectForIndexPath: (NSIndexPath *) indexPath;

@end
