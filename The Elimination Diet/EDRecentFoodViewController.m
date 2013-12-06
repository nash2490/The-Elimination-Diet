//
//  EDRecentFoodViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/25/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDRecentFoodViewController.h"

#import "EDMealTableViewController.h"

#import "EDFood+Methods.h"
#import "EDEatenMeal+Methods.h"
#import "EDMeal+Methods.h"
#import "EDType+Methods.h"
#import "EDIngredient+Methods.h"

#import "NSString+MHED_EatDate.h"

#define EATEN_MEAL_ENTITY @"EDEatenMeal"
#define EATEN_MEAL_TABLECELL @"EDEatenMealTableCell"

@interface EDRecentFoodViewController ()
@property (nonatomic) BOOL beganUpdates;
@end

@implementation EDRecentFoodViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:EATEN_MEAL_TABLECELL];
        self.debug = TRUE;
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    if (self) {
        [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:EATEN_MEAL_ENTITY];
        self.debug = TRUE;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) helperViewWillAppear
{
    [super helperViewWillAppear];
    [EDMeal setUpDefaultMealsInContext:self.managedObjectContext];
    [EDEatenMeal setUpDefaultEatenMealsWithContext:self.managedObjectContext];
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
    NSFetchRequest *fetch = [EDEatenMeal fetchEatenMealsForLastWeekWithMedication:NO];
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    return fetch;
}

#pragma mark - Core Data -

- (void)performFetch
{
    [super performFetch];
    
}

- (void) changeFetchedResultsControllerToFetchRequest: (NSFetchRequest *) fetch
{
    [super changeFetchedResultsControllerToFetchRequest:fetch];
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [super controllerWillChangeContent:controller];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [super controllerDidChangeContent:controller];
}



#pragma mark - Table View Controller Delegate and Data source

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EATEN_MEAL_TABLECELL forIndexPath:indexPath];
    
    EDEatenMeal *eatenMeal = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString convertEatDateToString:eatenMeal.date];
    cell.detailTextLabel.text = eatenMeal.meal.name;
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDEatenMeal *eatenMeal = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *uniqueIDForMeal = eatenMeal.meal.uniqueID;
    NSFetchRequest *fetchRequest = [EDFood fetchObjectsForEntityName:MEAL_ENTITY_NAME UniqueID:uniqueIDForMeal];
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    //fetchRequest.predicate = [NSPredicate predicateWithFormat:@"self IN %@", ingredient.typesPrimary];
    
    
    EDMealTableViewController *detailViewController = [[EDMealTableViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.fetchRequest = fetchRequest;
    
    [[self navigationController] pushViewController:detailViewController animated:YES];
}




@end
