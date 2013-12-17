//
//  EDCoreDataTableViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/1/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

/*
 There are 4 possible choices for data sources with the FRC
    1 - standard
    2 - rearrange the sections  but have data be the same
    3 - use FRC.fetchRequest to get the objects to use for the sections and then use those to get access to the objects to use as the row contents
            - set "name", or some other property/method of the objects from the FRC, as the sectionNameKeyPath
    4 - do 2 and 3. Populate sections headers using the FRC but the rows by other means. But then reorder the sections.
*/

@interface EDCoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

#pragma mark - Properties
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

/// for initialization of fetchedResultsController
//      - allows us to set a fetch request before having a controller, and thus before having a context
@property (nonatomic, strong) NSFetchRequest *fetchRequest;


@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

@property (nonatomic) BOOL customSectionOrdering; // YES if we want the sections reordered
@property (nonatomic) BOOL populatedTableUsingFRC; // YES is default. NO if we only use the FRC for sectioning.

@property BOOL debug;

@property (nonatomic, strong) NSArray *reorderedSections;
@property (nonatomic, strong) NSArray *reorderedSectionIndexTitles;

//@property (nonatomic, strong) UIManagedDocument *document;

#pragma mark - Methods

/// called in ViewDidLoad, within a block. gets called after context is set, but before the table is reloaded
- (void) mhedViewDidLoadCoreDataHelper;

/// called within viewWillAppear - in performWithDocument:
- (void) helperViewWillAppear;

/// OVERRIDE IN SUBCLASSES
/// -- create a fetch request that the VC uses automatically
- (NSFetchRequest *) defaultFetchRequest;

/// OVERRIDE IN SUBCLASSES
/// -- creates a FRC that the VC uses automatically
- (NSFetchedResultsController *) defaultFetchedRequestController:(NSManagedObjectContext *) managedObjectContext;

- (void)performFetch;

- (void) changeFetchedResultsControllerToFetchRequest: (NSFetchRequest *) fetch;


///
/// Must return an array of distinct NSNumber ints in [0, 1, ..., # of sections - 1]
- (NSArray *) mhedSections;

///
- (NSArray *)mhedSectionIndexTitles;

///
- (id) mhedObjectAtIndexPath: (NSIndexPath *) indexPath;

///
- (id) mhedObjectWithoutFRCFromIndexPath: (NSIndexPath *) indexPath;

@end
