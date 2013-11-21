//
//  EDMultipleCoreDataTableViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/6/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDMultipleCoreDataTableViewController.h"

@interface EDMultipleCoreDataTableViewController ()
@property (nonatomic) BOOL beganUpdates;

@end

@implementation EDMultipleCoreDataTableViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {

    }
}

- (void) setSortDescriptorForAllObjects:(NSSortDescriptor *)sortDescriptorForAllObjects
{
    _sortDescriptorForAllObjects = sortDescriptorForAllObjects;
}

- (void) setFetchRequests:(NSDictionary *)fetchRequests
{
    NSDictionary *oldFetchRequests = _fetchRequests;
    if (oldFetchRequests != fetchRequests) {
        _fetchRequests = fetchRequests;
        if (fetchRequests) {
            [self performFetch];
        }
        else {
            [self.tableView reloadData];
        }
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self setSuspendAutomaticTrackingOfChangesInManagedObjectContext:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
     [center addObserver:self
     selector:@selector(managedObjectContextChanged:)
     name:NSManagedObjectContextObjectsDidChangeNotification
     object:self.managedObjectContext];
     
}


/// overwrite this in a subclass to be aware of the notifications
- (void) managedObjectContextChanged: (NSNotification *) notification
{
    if (notification.name == NSManagedObjectContextObjectsDidChangeNotification) {
        if (notification.userInfo[NSInsertedObjectsKey]) {
            
        }
        if (notification.userInfo[NSUpdatedObjectsKey]) {
            
        }
        if (notification.userInfo[NSDeletedObjectsKey]) {
            
        }
    }
    else
    {
        
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    
     NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
     
     [center removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
     
     [super viewWillDisappear:animated];
     
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetch Results Controller Methods

- (void)performFetch
{
    // create a dictionary to store the fetch results
    NSMutableDictionary *mutFetchResults = [[NSMutableDictionary alloc] initWithCapacity:[self.fetchRequests count]];
    
    // execute each fetch request in self.fetchRequests
    for (NSString *fetch in [self.fetchRequests allKeys]) {
        
        [self performFetchForFetchRequest:fetch];
    }
    
    // save objects to self.fetchedObjects
    self.fetchedObjects = [mutFetchResults copy];
    
    // sort fetched objects into one list if we want to
    [self performSortIntoOneSection];
    
    // reload tableView
    [self.tableView reloadData];
}

// perform a fetch on only the fetch you want from the list of fetch requests in the dictionary
- (void) performFetchForFetchRequest: (NSString *) fetchRequestName
{
    NSFetchRequest *request = self.fetchRequests[fetchRequestName];
    if (request) {
        NSError *error = nil;
        NSArray *fetchedResults = [self.managedObjectContext executeFetchRequest:request error:&error];
        NSMutableDictionary *mutFetchedObjects = [self.fetchedObjects mutableCopy];
        
        if (fetchedResults) {
            mutFetchedObjects[fetchRequestName] = fetchedResults;
        }
        else {
            NSLog(@" kjkljklj %@", [error localizedDescription]);
            mutFetchedObjects[fetchRequestName] = nil;
        }
        
    }
}



- (void) performSortIntoOneSection
{
    if (self.sortDescriptorForAllObjects) {
        NSMutableArray *allObjectsSorted = nil;
        
        
        if (!self.fetchedObjects) {
            [self performFetch];
        }
            
        if (self.fetchedObjects) {
            
            // combine all objects into one array
            for (NSString *frName in self.fetchedObjects) {
                [allObjectsSorted addObjectsFromArray:self.fetchedObjects[frName]];
            }
            
            // sort the array into the end array
            [allObjectsSorted sortUsingDescriptors:@[self.sortDescriptorForAllObjects]];
            self.fetchedObjectsSorted = [allObjectsSorted copy];
        }
        
        
    }
}



#pragma mark - Table view data source and useful methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.sortDescriptorForAllObjects) {
        return 1;
    }
    else {
        return [self.fetchRequests count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sortDescriptorForAllObjects && (section == 0)) {
        return [self.fetchedObjectsSorted count];
    }
    else if (!self.sortDescriptorForAllObjects){
        NSString *sectionHeader = self.fetchedObjectsSorted[section];
        return [self.fetchedObjects[sectionHeader] count];
    }
    else { // should never happen
        NSLog(@"Table thought there was 2 sections for all objects sorted");
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return self.orderedSectionHeaders[section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.sortDescriptorForAllObjects) {
        return 0;
    }
    
    else { // for now we assume that the sectionIndexTitle = sectionHeader
        return [self.orderedSectionHeaders indexOfObject: self.fetchedObjects[title]];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{// for now we assume that the sectionIndexTitle = sectionHeader
    return self.orderedSectionHeaders;
}

- (id) objectForIndexPath: (NSIndexPath *) indexPath
{
    if (self.fetchedObjectsSorted && (indexPath.section ==0)) {
        return self.fetchedObjectsSorted[indexPath.row];
    }
    else if (!self.sortDescriptorForAllObjects){
        // get section for indexPath.section
        NSString *sectionHeader = self.orderedSectionHeaders[indexPath.section];
        NSArray *sectionObjects = self.fetchedObjects[sectionHeader];
        
        // get object from section
        if (sectionObjects) {
            return sectionObjects[indexPath.row];
        }
    }
    return nil;
}

#pragma mark - Notification of Change to Table or Context

 



@end
