//
//  EDRecordEventViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/25/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;

#define SEGUE_CAMERA_PICTURE @"Camera Picture Segue"

@interface EDRecordEventViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *pastMealDetailsButton;
@property (weak, nonatomic) IBOutlet UITextView *eliminatedFoodTextView;

#pragma mark - Core Data -

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSFetchRequest *fetchRequest;

@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

@property BOOL debug;


//@property (nonatomic, strong) UIManagedDocument *document;

- (void)performFetch;

- (void) changeFetchedResultsControllerToFetchRequest: (NSFetchRequest *) fetch;

@end
