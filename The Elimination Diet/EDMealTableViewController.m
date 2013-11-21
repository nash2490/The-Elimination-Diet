//
//  EDMealTableViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/5/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDMealTableViewController.h"
#import "EDIngredientTableViewController.h"

#import "EDMeal+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDType+Methods.h"
#import "EDTag+Methods.h"
#import "EDEliminatedFood+Meals.h"

#define MEAL_ENTITY_NAME @"EDMeal"
#define MEAL_TABLECELL @"EDMeal Table Cell"

@interface EDMealTableViewController ()

@end

@implementation EDMealTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:MEAL_TABLECELL];
        self.debug = TRUE;
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    if (self) {
        [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:MEAL_TABLECELL];
        self.debug = TRUE;
    }
}



- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void) helperViewWillAppear
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.debug = TRUE;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [EDMeal fetchAllMeals];
}


#pragma mark - Core Data -

- (void) performFetch
{
    [super performFetch];
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [super controllerWillChangeContent:controller];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [super controllerDidChangeContent:controller];
}

#pragma mark - Table View Delegate and Data source -



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MEAL_TABLECELL forIndexPath:indexPath];
    
    EDMeal *meal = nil;
    meal = [self edObjectAtIndexPath:indexPath];
    
    cell.textLabel.text = meal.name;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDMeal *meal = [self edObjectAtIndexPath:indexPath];
    NSLog(@"meal ingredients count = %d", [meal.ingredientsAdded count]);
    BOOL isMeal = FALSE;
    if (meal) {
        isMeal = TRUE;
    }
    NSLog(@"meal %d", isMeal);

    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:INGREDIENT_ENTITY_NAME];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"self IN %@", meal.ingredientsAdded];
    
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:self.managedObjectContext
                                                                            sectionNameKeyPath:@"nameFirstLetter"
                                                                                     cacheName:nil];
    
    EDIngredientTableViewController *detailViewController = [[EDIngredientTableViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.fetchedResultsController = frc;
    
    [[self navigationController] pushViewController:detailViewController animated:YES];
}


#pragma mark - Reordered Sections  -

- (NSArray *) edSections
{
    return [super edSections];
}

- (NSArray *) edSectionIndexTitles
{
    return [super edSectionIndexTitles];
}

- (id) edObjectAtIndexPath: (NSIndexPath *) indexPath
{
    return [super edObjectAtIndexPath:indexPath];
}

@end
