//
//  EDEatenMealTableViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/5/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEatenMealTableViewController.h"
#import "EDMealTableViewController.h"

#import "EDFood+Methods.h"
#import "EDEatenMeal+Methods.h"
#import "EDMeal+Methods.h"
#import "EDType+Methods.h"
#import "EDIngredient+Methods.h"

#import "NSString+EatDate.h"

#define EATEN_MEAL_ENTITY @"EDEatenMeal"
#define EATEN_MEAL_TABLECELL @"EDEatenMeal Table Cell"

@interface EDEatenMealTableViewController ()

@end

@implementation EDEatenMealTableViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:EATEN_MEAL_TABLECELL];
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
    [EDMeal setUpDefaultMealsInContext:self.managedObjectContext];
    
    NSError *error;
    NSArray *allMeals = [self.managedObjectContext executeFetchRequest:[EDMeal fetchAllMeals] error:&error];
    
    if ([allMeals count]) {
        EDMeal *mealToEat = allMeals[1];
        
        //[EDEatenMeal createEatenMealWithMeal:mealToEat atTime:[NSDate distantPast] forContext:self.managedObjectContext];
        [EDEatenMeal eatMealNow:mealToEat forContext:self.managedObjectContext];
    }
}





#pragma mark - Default Fetch Request and FetchedResultsController


- (NSFetchedResultsController *) defaultFetchedRequestController:(NSManagedObjectContext *)managedObjectContext
{
    if (!self.fetchRequest) {
        self.fetchRequest = [self defaultFetchRequest];
    }

    return [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                               managedObjectContext:managedObjectContext
                                                 sectionNameKeyPath:nil // to replace with @"eventDay"
                                                          cacheName:nil];
}

- (NSFetchRequest *)defaultFetchRequest
{
    NSFetchRequest *fetch = [EDEatenMeal fetchAllEatenMealsWithMedication:NO];
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    return fetch;
}


#pragma mark - Table View Delegate and Data Source methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EATEN_MEAL_TABLECELL];
    
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
    
    
    //NSFetchRequest *fetchRequest = [EDFood fetchObjectsForEntityName:MEAL_ENTITY_NAME setKeyPath:@"timesEaten" containsValue:eatenMeal];
    
    //NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:TYPE_ENTITY_NAME];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    //fetchRequest.predicate = [NSPredicate predicateWithFormat:@"self IN %@", ingredient.typesPrimary];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:self.managedObjectContext
                                                                            sectionNameKeyPath:@"nameFirstLetter"
                                                                                     cacheName:nil];
    
    EDMealTableViewController *detailViewController = [[EDMealTableViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.fetchedResultsController = frc;
    
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

@end
