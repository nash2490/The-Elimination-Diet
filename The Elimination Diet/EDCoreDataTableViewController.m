//
//  EDCoreDataTableViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/1/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDCoreDataTableViewController.h"
#import "EDEliminatedAPI.h"

#import "EDEliminatedAPI.h"


@interface EDCoreDataTableViewController ()
@property (nonatomic) BOOL beganUpdates;
@end

@implementation EDCoreDataTableViewController

- (void) awakeFromNib
{
    [super awakeFromNib];
    if (self) {
        self.debug = TRUE;
        self.populatedTableUsingFRC = YES;
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self setSuspendAutomaticTrackingOfChangesInManagedObjectContext:NO];
        self.populatedTableUsingFRC = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSuspendAutomaticTrackingOfChangesInManagedObjectContext:NO];
    self.populatedTableUsingFRC = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.mheditButtonItem;
    
    // if the VC doesn't have a MOC but it was given a FRC that has one then we will use it
    if (!self.managedObjectContext && self.fetchedResultsController && self.fetchedResultsController.managedObjectContext)
    {
        [self setManagedObjectContext:self.fetchedResultsController.managedObjectContext];
        //[self helperViewWillAppear];
        [self performFetch];
    }
    
    else if (!self.managedObjectContext) {
        
        [EDEliminatedAPI performBlockWithContext:^(NSManagedObjectContext *context) {
            [self setManagedObjectContext:context];
            //[self helperViewWillAppear];
            
            [self performFetch];
        }];
        
        //        [[EDDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
        //            //self.managedObjectContext = document.managedObjectContext;
        //            [self setManagedObjectContext:document.managedObjectContext];
        //            [self helperViewWillAppear];
        //
        //            [self performFetch];
        //        }];
    }
    else {
        [self performFetch];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(documentContextChanged:)
                   name:NSManagedObjectContextObjectsDidChangeNotification
                 object:self.document.managedObjectContext];
     */
    
    // if we didn't suspend the auto tracking then we don't need to reload the data
    if (self.fetchedResultsController.delegate && !self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        
    }
    else {
        [self.tableView reloadData];
    }
}

- (void) helperViewWillAppear
{
    // put any setup that needs to be run when viewWillAppear is called and before the first performFetch is called
}




//  - sets context and assures that we have an frc

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    if (managedObjectContext) {
        
        if (!self.fetchedResultsController || !self.fetchedResultsController.managedObjectContext)
        { // if we don't have a FRC with viable MOC then we need to make one
    
            [self setFetchedResultsController:[self defaultFetchedRequestController:managedObjectContext]];

        }
        
        // otherwise, we have a FRC with viable MOC
        
    }
    else {
        self.fetchedResultsController = nil;
    }
}



/// overwrite this in a subclass to be aware of the notifications
- (void) documentContextChanged: (NSNotification *) notification
{
    if (notification.name == NSManagedObjectContextObjectsDidChangeNotification) {
        
    }
    else
    {
        
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /*
     NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:self.document.managedObjectContext];
    
    [super viewWillDisappear:animated];
     */
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetch Results Controller Methods -

// override in subclasses
- (NSFetchRequest *) defaultFetchRequest
{
    //[EDMeal fetchAllMeals];
    return nil;
}

// override in subclass to change sectionNameKeyPath and cacheName
- (NSFetchedResultsController *) defaultFetchedRequestController:(NSManagedObjectContext *) managedObjectContext
{
    if (!self.fetchRequest) {
        self.fetchRequest = [self defaultFetchRequest];
    }
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                               managedObjectContext:managedObjectContext
                                                 sectionNameKeyPath:nil
                                                          cacheName:nil];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc && (newfrc != oldfrc)) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) &&
            (!self.navigationController || !self.navigationItem.title))
        {
            self.title = newfrc.fetchRequest.entity.name;
        }
        
        if (newfrc) {
            if (self.debug) {
                NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), oldfrc ? @"updated" : @"set");
            }
            //[self performFetch];
        }
        else {
            if (self.debug) {
                NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            }
            
            [self.tableView reloadData];
        }
    }
}

- (void) changeFetchedResultsControllerToFetchRequest: (NSFetchRequest *) fetch
{
    NSFetchRequest *newFetch = fetch;
    if (!newFetch) {
        newFetch = [self defaultFetchRequest];
    }
    
    // we need a managedObjectContext for a fetchResultsController, so if no controller already exists we need to make a new one make a new one
    if (self.fetchedResultsController && self.fetchedResultsController.managedObjectContext) {
        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:newFetch
                                                                                     managedObjectContext:self.fetchedResultsController.managedObjectContext
                                                                                       sectionNameKeyPath:self.fetchedResultsController.sectionNameKeyPath
                                                                                                cacheName:self.fetchedResultsController.cacheName];
        
        [self setFetchedResultsController:controller];
    }
    
    // otherwise, if we have an MOC we create the default FRC and then recursively call this method passing in the fetchRequest
    else if (self.managedObjectContext){
        [self setFetchedResultsController:[self defaultFetchedRequestController:self.managedObjectContext]];
        
        // a check to prevent infinite loops
        if (self.fetchedResultsController && self.fetchedResultsController.managedObjectContext) {
            [self changeFetchedResultsControllerToFetchRequest:newFetch];
        }
    }
}


- (void)performFetch
{
    if (self.fetchedResultsController) {
        if (self.fetchedResultsController.fetchRequest.predicate) {
            if (self.debug) {
                NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate); 
            }
        }
        else {
            if (self.debug) NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName);
        }
        
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        
        if (error) {
            NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
        }
        
        //[self.tableView reloadData];
    }
    
    else if (self.managedObjectContext){ // if there is a MOC but no FRC then we create the default FRC, set it, and call performFetch again
        
        if (self.debug) {
            NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        }
        
        [self setFetchedResultsController:[self defaultFetchedRequestController:self.managedObjectContext]];
        
        if (self.fetchedResultsController) {
            // to make sure we don't have an infinite loop, we make sure that self.FRC exists before recursing
            [self performFetch];
        }
    }
    
}




#pragma mark - Sections and reordering

// Must return an array of distinct NSNumber ints in [0, 1, ..., # of sections - 1]
- (NSArray *) mhedSections
{
    if (self.reorderedSections) {
        return self.reorderedSections;
    }
    
    
    NSArray *reorder = [[NSArray alloc] init];

    // override in subclasses when you want to have custom ordering for sections
    
    // use [self.fetchedResultsController sections] and perform operations to determine which should go where
    
//    // basic reverse ordering goes like this
//   
//    for (int i=0; i < [[self.fetchedResultsController sections] count]; i++) {
//        reorder = [reorder arrayByAddingObject:@([[self.fetchedResultsController sections] count] - 1 - i)];
//    }
//    
//    // for moving section j to location k (j > k), with k going to k+1, etc, use this
//    //      - if j < k then there is ambiguity in how things are adjusted
//    int j = 4;
//    int k = 2;
//    int min = MIN(j, k);
//    int max = MAX(j, k);
//    
//    for (int i=0; i < [[self.fetchedResultsController sections] count]; i++) {
//        if (min == i) {
//            reorder = [reorder arrayByAddingObject:@(j)];
//        }
//        else if (min < i <= max) {
//            reorder = [reorder arrayByAddingObject:@(i + 1)];
//        }
//        else {
//            reorder = [reorder arrayByAddingObject:@(i)];
//        }
//        
//    }
    
    return reorder;
}

- (void) updateReorderedSections
{
    self.reorderedSections = nil;
    self.reorderedSections = [self mhedSections];
}

- (NSArray *)mhedSectionIndexTitles
{
    if (self.reorderedSectionIndexTitles) {
        return self.reorderedSectionIndexTitles;
    }
    
    // override in subclasses
    return [[NSArray alloc] init];
}

- (id) mhedObjectAtIndexPath: (NSIndexPath *) indexPath
{
    if ([[self.fetchedResultsController sections] count] > 0) {
        
        NSIndexPath *originalIndexPath = indexPath;
        if (self.customSectionOrdering) {
            // section corresponds to the display location, so we need to find the old section
            // the row will not change
            NSInteger originalSection = [(NSNumber *)[self mhedSections][indexPath.section] integerValue];
            
            originalIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:originalSection];
            
        }
        
        if (!self.populatedTableUsingFRC) { // if we want to get the objects using other means than the FRC
            
            return [self mhedObjectWithoutFRCFromIndexPath:originalIndexPath];
        }
        
        else {
            
            originalIndexPath = indexPath;
        }
        
        return [self.fetchedResultsController objectAtIndexPath:originalIndexPath];

        
    } else
        return nil;
}

//
- (id) mhedObjectWithoutFRCFromIndexPath: (NSIndexPath *) indexPath
{
    // override in subclass if you want to use this feature
    
    return nil;
}


#pragma mark - Table view data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"fetchedResultsController has %d sections", [[self.fetchedResultsController sections] count]);
    
    if (self.customSectionOrdering) {
        
        return [[self.fetchedResultsController sections] count];
    }
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.fetchedResultsController sections] count] > 0) {
        if (self.customSectionOrdering) {
            // section corresponds to the display location, so we need to find the old section
            NSInteger originalSection = [(NSNumber *)[self mhedSections][section] integerValue];
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][originalSection];
            return [sectionInfo numberOfObjects];
        }
        
        else {
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
            return [sectionInfo numberOfObjects];
        }
        
    } else
        return 0;
    
    //return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if ([[self.fetchedResultsController sections] count] > 0) {
        
        if (self.customSectionOrdering) {
            // section corresponds to the display location, so we need to find the old section
            NSInteger originalSection = [(NSNumber *)[self mhedSections][section] integerValue];
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][originalSection];
            return [sectionInfo name];
        }
        
        else {
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
            return [sectionInfo name];
        }
        
    }
    else
        return nil;
    
	//return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self tableView:tableView titleForHeaderInSection:section]) {
        return tableView.sectionHeaderHeight;
    }
    else {
        return 0.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.customSectionOrdering) {
        // we get the section index of the section header that has 'title' as a substring
        
        NSUInteger sectionIndex = [[self mhedSections] indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            
            if ([[self.fetchedResultsController sections] count] > 0) {
                NSInteger objectIndex = [(NSNumber *)obj integerValue]; // the object at idx is the index of the section in the unordered sections from the FRC
                id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][objectIndex];
                NSRange stringRange = [[sectionInfo name] rangeOfString:title];
                return stringRange.length; // 0 if it wasn't for and >0 if it was a substring
            }
            return NO;
        }];
        
        return sectionIndex;
        
        
    }
	return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.customSectionOrdering) {
        return [self mhedSectionIndexTitles];
    }
    return [self.fetchedResultsController sectionIndexTitles];
}

#pragma mark - NSFetchedResultsControllerDelegate -

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        [self.tableView beginUpdates];
        self.beganUpdates = YES;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.beganUpdates) {
        [self.tableView endUpdates];
    }
}

- (void)endSuspensionOfUpdatesDueToContextChanges
{
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend
{
    if (suspend) {
        _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    } else {
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
}

@end
