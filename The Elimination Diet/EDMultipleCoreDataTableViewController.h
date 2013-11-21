//
//  EDMultipleCoreDataTableViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/6/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface EDMultipleCoreDataTableViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSDictionary *fetchRequests; // key is the header for each fetch request
@property (nonatomic, strong) NSArray *orderedSectionHeaders; // the keys of fetchRequests ordered
@property (nonatomic, strong) NSDictionary *fetchedObjects; // the nsarrays returned from fetchRequests using the same keys

// if objects are broken into sections by the fetchRequest this is nil
//  - otherwise use this to sort all the objects from fetchedObjects into one section
@property (nonatomic, strong) NSSortDescriptor *sortDescriptorForAllObjects;

// all the fetchedObjects once sorted by sortDescriptors
@property (nonatomic, strong) NSArray *fetchedObjectsSorted;

@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

@property BOOL debug;

- (void)performFetch;

@end
