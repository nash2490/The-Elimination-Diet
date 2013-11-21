//
//  EDTypeTableViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/1/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//


#import "EDTypeTableViewController.h"
#import "EDIngredient+Methods.h"
#import "EDType+Methods.h"
#import "EDTag+Methods.h"

#import "EDIngredientTableViewController.h"

@interface EDTypeTableViewController ()

@end


static NSString *TypeCellIdentifier = @"Type Cell";

@implementation EDTypeTableViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:TypeCellIdentifier];
        self.debug = TRUE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return [EDType fetchAllTypes];
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section %i, row %i", indexPath.section, indexPath.row);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TypeCellIdentifier];
    
    EDType *type = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = type.name;
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDType *type = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"type.ingredientsPrimary has %d", [type.ingredientsPrimary count]);
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:INGREDIENT_ENTITY_NAME];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"self IN %@", type.ingredientsPrimary];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:self.managedObjectContext
                                                                            sectionNameKeyPath:@"nameFirstLetter"
                                                                                     cacheName:nil];
    
    EDIngredientTableViewController *detailViewController = [[EDIngredientTableViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.fetchedResultsController = frc;
    
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

@end
