//
//  EDEliminatedTypeTableViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/2/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDDocumentHandler.h"

#import "EDEliminatedTypeTableViewController.h"
#import "EDTypeTableViewController.h"

#import "EDEliminatedType+Methods.h"
#import "EDType+Methods.h"

#import "NSString+EatDate.h"

@interface EDEliminatedTypeTableViewController ()

@end

@implementation EDEliminatedTypeTableViewController

static NSString *EliminatedTypeCellIdentifier = @"Eliminated Type Identifier";

- (void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"EDEliminatedType"];
        
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"start"
                                                                  ascending:YES]];
        request.predicate = nil;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:EliminatedTypeCellIdentifier];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) {
        [[EDDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            self.managedObjectContext = document.managedObjectContext;
            
            // create basic type objects for testing purposes
            EDEliminatedType *elimType1 = [NSEntityDescription insertNewObjectForEntityForName:@"EDEliminatedType"
                                                          inManagedObjectContext:self.managedObjectContext];
            
            // create basic type objects for testing purposes
            EDType *type1 = [NSEntityDescription insertNewObjectForEntityForName:@"EDType"
                                                          inManagedObjectContext:self.managedObjectContext];
            
            type1.name = @"gluten";
            EDType *type2 = [NSEntityDescription insertNewObjectForEntityForName:@"EDType"
                                                          inManagedObjectContext:self.managedObjectContext];
            
            type2.name = @"diabetes";
         
            elimType1.uniqueID = @"This should be a unique ID";
            elimType1.start = [NSDate date];
            elimType1.type = type1;
            
            EDEliminatedType *elimType2 = [NSEntityDescription insertNewObjectForEntityForName:@"EDEliminatedType"
                                                          inManagedObjectContext:self.managedObjectContext];
            
            elimType2.uniqueID = @"diabetes";
            elimType2.start = [NSDate distantFuture];
            elimType2.type = type2;
            
            
        }
         ];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section %i, row %i", indexPath.section, indexPath.row);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EliminatedTypeCellIdentifier];
    
    EDEliminatedType *elimType = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString convertEatDateToString:elimType.start];
    
    if (elimType.uniqueID) {
        cell.detailTextLabel.text = elimType.uniqueID;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    EDTypeTableViewController *detailViewController = [[EDTypeTableViewController alloc] initWithNibName:nil bundle:nil];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"EDType"];
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    EDEliminatedType *elimType = [self.fetchedResultsController objectAtIndexPath:indexPath];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@",elimType.type.name];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
                                       initWithFetchRequest:fetchRequest
                                       managedObjectContext:elimType.managedObjectContext
                                         sectionNameKeyPath:nil
                                                  cacheName:nil];
    detailViewController.fetchedResultsController = frc;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
     
}

@end
