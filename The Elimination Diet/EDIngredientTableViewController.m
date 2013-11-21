//
//  EDIngredientTableViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/2/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDIngredientTableViewController.h"
#import "EDTypeTableViewController.h"

#import "EDFood+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDType+Methods.h"
#import "EDEliminatedFood+Ingredients.h"
#import "EDTag+Methods.h"

@interface EDIngredientTableViewController ()

@end

static NSString *IngredientCellIdentifier = @"Ingredient Cell Identifier";

@implementation EDIngredientTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:IngredientCellIdentifier];
        self.debug = TRUE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) helperViewWillAppear
{
    [EDIngredient setUpDefaultIngredientsWithContext:self.managedObjectContext];
}





#pragma mark - Default Fetch Request and FetchedResultsController


- (NSFetchedResultsController *) defaultFetchedRequestController:(NSManagedObjectContext *)managedObjectContext
{
    if (!self.fetchRequest) {
        self.fetchRequest = [self defaultFetchRequest];
    }
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:@"nameFirstLetter"
                                                                                   cacheName:nil];
}

- (NSFetchRequest *)defaultFetchRequest
{
    return [EDIngredient fetchAllIngredients];
}

#pragma mark Table View Controller Delegate methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IngredientCellIdentifier];
    
    EDIngredient *ingredient = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = ingredient.name;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDIngredient *ingredient = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSFetchRequest *fetchRequest = [EDFood fetchObjectsForEntityName:TYPE_ENTITY_NAME
                                                       withSelfInSet:ingredient.typesPrimary];
    
    //NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:TYPE_ENTITY_NAME];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    //fetchRequest.predicate = [NSPredicate predicateWithFormat:@"self IN %@", ingredient.typesPrimary];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:self.managedObjectContext
                                                                            sectionNameKeyPath:@"nameFirstLetter"
                                                                                     cacheName:nil];
    
    EDTypeTableViewController *detailViewController = [[EDTypeTableViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.fetchedResultsController = frc;
    
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

@end
