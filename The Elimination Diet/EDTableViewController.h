//
//  EDTableViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/8/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDViewController.h"

@interface EDTableViewController : EDViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

// key is display string for section (if not "DEFAULT")
// object is NSArray for section (ordered)
@property (nonatomic, strong) NSDictionary *tableObjects;

// the keys of tableObjects ordered the way they are to be displayed
@property (nonatomic, strong) NSArray *tableSectionHeaders;

// the list of the objects in the table that are checked
@property (nonatomic, strong) NSSet *primaryCheckedTableObjects;
@property (nonatomic, strong) NSSet *secondaryCheckedTableObjects;

@property (nonatomic, strong) NSString *keyPathForCellTitle;
@property (nonatomic, strong) NSString *keyPathForCellSubtitle;
@property (nonatomic) BOOL cellSubtitle;

@property (nonatomic) UITableViewCellAccessoryType tableAccessory;


- (CGRect) setUpTableViewFrame;
- (UITableView *) setUpTableView: (CGRect) frame;

- (id) getObjectForIndexPath: (NSIndexPath *) indexPath;

- (void) updateTable;
- (void) saveCheckedTableObjects;

- (NSString *) stringFromObject: (id) obj andKeyPath: (NSString *) keyPath;

// changes properties and then returns self
- (UIViewController *) viewControllerForDisclosureIndicator:(NSIndexPath *) indexPath;
// returns a VC to edit the object at indexPath
- (UIViewController *) viewControllerForDetailDisclosureButton: (NSIndexPath *) indexPath;

+ (NSDictionary *) defaultDictionaryForTableObjectsUsingObjects: (NSArray *) objects;
+ (NSDictionary *) indexedDictionaryForTableObjectsUsingObjects: (NSArray *) objects;
+ (NSDictionary *) dictionaryForTableObjectsUsingObjects: (NSArray *) objects andSectionHeaders: (NSArray *) headers;

- (void) updateTableObjectsAndSectionHeaders: (NSDictionary *) objects;
- (void) updateTableObjects: (NSDictionary *) objects withOrderedSectionHeaders: (NSArray *) headers;

@end
