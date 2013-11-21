//
//  EDEliminatedFoodTableViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/31/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedFoodTableViewController.h"

#import "EDIngredientTableViewController.h"
#import "EDMealTableViewController.h"
#import "EDEatenMealTableViewController.h"
#import "EDTypeTableViewController.h"

#import "EDEliminatedFood+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDMeal+Methods.h"
#import "EDType+Methods.h"
#import "EDRestaurant+Methods.h"

#import "NSString+EatDate.h"

#define ELIMINATED_FOOD_CELL_IDENTIFIER @"EDEliminatedFoodTableCell"

@interface EDEliminatedFoodTableViewController ()

@end

@implementation EDEliminatedFoodTableViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:ELIMINATED_FOOD_CELL_IDENTIFIER];
        self.debug = TRUE;
        self.sortBy = SortByEndDate;
        self.subtype = AllEliminated;
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
    [EDEliminatedFood setUpDefaultEliminatedFoodsInContext:self.managedObjectContext];
}





#pragma mark - Default Fetch Request and FetchedResultsController


- (NSFetchedResultsController *) defaultFetchedRequestController:(NSManagedObjectContext *)managedObjectContext
{
    if (!self.fetchRequest) {
        self.fetchRequest = [self defaultFetchRequest];
    }
    
    NSString *sortByMethod;
    
    switch (self.sortBy) {
        case SortByName:
            sortByMethod = @"eliminatedFood.nameFirstLetter";
            self.fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"eliminatedFood.name" ascending:YES]];
            break;
            
        case SortByEndDate:
            sortByMethod = @"endDateForSorting";
            self.fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"stop" ascending:NO]];
            break;
            
        case SortByStartDate:
            sortByMethod = @"startDateForSorting";
            self.fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
            break;
            
        case SortByCurrent: // should put the current at the top in 1 section, and the rest in another
                                // both sections sorted by either name or end date (not sure just yet as both make sense)
            sortByMethod = @"currentForSorting";
            self.fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"eliminatedFood.name" ascending:YES]];
            
        default:
            sortByMethod = @"eliminatedFood.nameFirstLetter";
            self.fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"eliminatedFood.name" ascending:YES]];
            break;
    }
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                               managedObjectContext:managedObjectContext
                                                 sectionNameKeyPath:sortByMethod
                                                          cacheName:nil];
}

- (NSFetchRequest *)defaultFetchRequest
{
    NSFetchRequest *fetch = nil;
    
    if (self.managedObjectContext) {
        switch (self.subtype) {
                
            case AllEliminated:
                fetch = [EDEliminatedFood fetchAllEliminatedFoods];
                break;
                
            case AllCurrentEliminated:
                fetch = [EDEliminatedFood fetchAllCurrentEliminatedFoods];
                break;
                
            case TypesEliminated:
                fetch = [EDEliminatedFood fetchAllEliminatedTypesForContext:self.managedObjectContext];
                break;
                
            case IngredientsEliminated:
                fetch = [EDEliminatedFood fetchAllEliminatedIngredientsForContext:self.managedObjectContext];
                break;
                
            case MealsEliminated:
                fetch = [EDEliminatedFood fetchAllEliminatedMealsForContext:self.managedObjectContext];
                break;
                
            case RestaurantsEliminated:
                fetch = [EDEliminatedFood fetchAllEliminatedRestaurantsForContext:self.managedObjectContext];
                break;
                
            
                
            default: // return all eliminated
                fetch = [EDEliminatedFood fetchAllEliminatedFoods];
                break;
        }
    }
    
    else {
        fetch = [EDEliminatedFood fetchAllEliminatedFoods];
    }
    
    
    
    return [EDEliminatedFood fetchAllCurrentEliminatedFoods];
}


#pragma mark Table View Controller Delegate methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ELIMINATED_FOOD_CELL_IDENTIFIER forIndexPath:indexPath];
    
    EDEliminatedFood *elim = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = elim.eliminatedFood.name;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //EDEliminatedFood *elim = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // WE NEED TO DISPLAY THE CONTENTS OF THIS OBJECT
    
    /*
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
     
     */
}


@end
