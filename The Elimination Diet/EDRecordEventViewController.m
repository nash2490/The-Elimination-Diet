//
//  EDRecordEventViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/25/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDRecordEventViewController.h"

#import "EDEliminatedAPI.h"

#import "EDEliminatedFood+Methods.h"
#import "EDDocumentHandler.h"
#import "EDMeal+Methods.h"
#import "EDTag+Methods.h"
#import "EDEatenMeal+Methods.h"

#import "EDMedication+Methods.h"

#import "EDEliminatedFoodTableViewController.h"
#import "EDSearchToEatViewController.h"

#import "EDCameraViewController.h"

#import "UIView+MHED_AdjustView.h"

#define SEARCH_VIEW_CONTROLLER @"SearchToEatVC"


@interface EDRecordEventViewController ()
@property (nonatomic) BOOL beganUpdates;

@property (weak, nonatomic) IBOutlet UIButton *searchForFoodButton;

@property (weak, nonatomic) IBOutlet UIButton *medicationButton;

@property (weak, nonatomic) IBOutlet UIButton *searchForSymptomsButton;

@property (weak, nonatomic) IBOutlet UIButton *recentSymptomsButton;

- (IBAction)searchForFoodButtonPress:(id)sender;
- (IBAction)editEliminatedFoodButton:(id)sender;
- (IBAction)handlePastMealsButtonPress:(id)sender;

@end

@implementation EDRecordEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setSuspendAutomaticTrackingOfChangesInManagedObjectContext:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.debug = TRUE;
    
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) {
        
//        [EDEliminatedAPI performBlockWithContext:^(NSManagedObjectContext *context) {
//            self.managedObjectContext = context;
//            [EDMeal setUpDefaultMealsInContext:context];
//            //[EDTag setUpDefaultTagsInContext:document.managedObjectContext];
//            
//            //[EDEatenMeal setUpDefaultEatenMealsWithContext:document.managedObjectContext];
//            [EDEliminatedFood setUpDefaultEliminatedFoodsInContext:context];
//            
//            [self performFetch];
//            
//        }];
        
        [[EDDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            
            //[self setManagedObjectContext:document.managedObjectContext];
            self.managedObjectContext = document.managedObjectContext;
            
            [EDMeal setUpDefaultMealsInContext:self.managedObjectContext];
            //[EDTag setUpDefaultTagsInContext:document.managedObjectContext];
            
            //[EDEatenMeal setUpDefaultEatenMealsWithContext:document.managedObjectContext];
            [EDEliminatedFood setUpDefaultEliminatedFoodsInContext:document.managedObjectContext];
            
            [EDMedication setUpDefaultMedicationInContext:document.managedObjectContext];
            
            [self performFetch];
        }
         ];
    }
    
    else if (self.managedObjectContext) {
//        [[EDDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
//            
//            //[self setManagedObjectContext:document.managedObjectContext];
//            self.managedObjectContext = document.managedObjectContext;
//            
//            [self performFetch];
//        }
//         ];
        
        [self performFetch];
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Core Data -
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        if (!self.fetchRequest) {
           [self setEliminatedFoodFetchRequest];
        }
        
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                              managedObjectContext:managedObjectContext
                                                                                sectionNameKeyPath:nil
                                                                                         cacheName:nil];
        
        [self setFetchedResultsController:frc];
    }
    
    else {
        self.fetchedResultsController = nil;
    }
}


- (void) setEliminatedFoodFetchRequest
{
    self.fetchRequest = [EDEliminatedFood fetchAllEliminatedFoods];

}


- (void)performFetch
{
    if (self.fetchedResultsController && self.fetchedResultsController.managedObjectContext) {
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
        
        [self updateEliminatedFoodLabel];
    }
    
    else {
        if (self.debug) {
            NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        }
    }
    
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
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
            
           // [self updateEliminatedFoodLabel];
        }
    }
}

- (void) changeFetchedResultsControllerToFetchRequest: (NSFetchRequest *) fetch
{
    // we need a managedObjectContext for a fetchResultsController, so if no controller already exists we can't make a new one
    if (self.fetchedResultsController) {
        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch
                                                                                     managedObjectContext:self.fetchedResultsController.managedObjectContext
                                                                                       sectionNameKeyPath:self.fetchedResultsController.sectionNameKeyPath
                                                                                                cacheName:self.fetchedResultsController.cacheName];
        
        [self setFetchedResultsController:controller];
    }
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        //[self.tableView beginUpdates];
        self.beganUpdates = YES;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.beganUpdates) {
        NSLog(@"FRC updating");
        //[self.tableView endUpdates];
        self.beganUpdates = NO;
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

- (void) updateEliminatedFoodLabel
{
    NSArray *elimFoods = self.fetchedResultsController.fetchedObjects;
    if (elimFoods) {
        
        NSMutableArray *elimFoodNames = [@[] mutableCopy];
        
        for (EDEliminatedFood *food in elimFoods) {
            [elimFoodNames addObject:food.eliminatedFood.name];
        }
        
        NSString *labelString = [elimFoodNames componentsJoinedByString:@", "];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.eliminatedFoodTextView.text = labelString;
            
            //CGFloat labelHeight = CGRectGetHeight(self.eliminatedFoodLabel.frame);

            //[self.eliminatedFoodScrollView scrollsToTop];
            
            
            
//            if (labelHeight > 38) {
//                
//            
//                for (NSLayoutConstraint *constraint in self.view.constraints)
//                {
//                    //NSLog(@"the constraint is %@", [constraint description]);
//                    //NSLog(@" there are %i constraints", [self.view.constraints count]);
//                    
//                    if (constraint.secondAttribute == NSLayoutAttributeBottom &&
//                        constraint.relation == NSLayoutRelationEqual &&
//                        constraint.secondItem == self.pastMealDetailsButton) {
//                        
//                        [self.view removeConstraint: constraint];
//                        NSLog(@"Yup its here");
//                    }
//                    
//                }
//                
//                [self.eliminatedFoodScrollView edSetBoundsHeight:labelHeight];
//                [self.eliminatedFoodScrollView edSetFrameHeight:labelHeight];
//                
//                [self.eliminatedFoodScrollView sizeToFit];
//                
//                [self.view setNeedsDisplay];
//            }

        });
    }
    
}




#pragma mark - Segue -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditEliminatedFoodSegue"]) {
        EDEliminatedFoodTableViewController *detailViewController = segue.destinationViewController;
        
        detailViewController.subtype = AllCurrentEliminated;
        detailViewController.sortBy = SortByCurrent;
    }
    
    if ([segue.identifier isEqualToString:SEGUE_CAMERA_PICTURE]) {
        
    }
}


#pragma mark - Button Presses

- (IBAction)searchForFoodButtonPress:(id)sender {
    
    EDSearchToEatViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:SEARCH_VIEW_CONTROLLER];
    
    searchVC.medicationFind = NO;
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (IBAction)searchForMedicationButtonPress:(id)sender {
    EDSearchToEatViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:SEARCH_VIEW_CONTROLLER];
    
    searchVC.medicationFind = YES;
    
    [self.navigationController pushViewController:searchVC animated:YES];

}

- (IBAction)editEliminatedFoodButton:(id)sender {
}

- (IBAction)handlePastMealsButtonPress:(id)sender {
    
    EDCreationViewController *createVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EatMealSummaryVC"];
    
    
    
    [self.navigationController pushViewController:createVC animated:YES];
    
}
@end
