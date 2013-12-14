//
//  MHEDMealSummaryViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/11/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDMealSummaryViewController.h"

#import "MHEDSplitFoodBrowseViewController.h"

#import "MHEDMealCarouselViewController.h"

#import "EDMeal+Methods.h"
#import "EDIngredient+Methods.h"

#import "MHEDBrowseFoodViewController.h"

static NSString *CellIdentifier = @"Cell";
static NSString *mhedAddFoodButtonCellIdentifier = @"Add Food Cell Identifier";

static NSString *mhedTableCellOptionsCell = @"Basic Options Cell";
static NSString *mhedTableCellMealCell = @"Meal Table Cell";
static NSString *mhedTableCellMedicationCell = @"Medication Table Cell";
static NSString *mhedTableCellIngredientCell = @"Ingredient Table Cell";

static NSString *mhedSegueIDBrowseFoodSegue = @"Browse Food Segue ID";

@interface MHEDMealSummaryViewController ()

@end

@implementation MHEDMealSummaryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.delegate) {
        self.delegate = (MHEDMealCarouselViewController *)[self.navigationController parentViewController];
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:mhedTableCellIngredientCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:mhedTableCellMealCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:mhedTableCellMedicationCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:mhedAddFoodButtonCellIdentifier];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFoodDataUpdateNotification:)
                                                 name:mhedFoodDataUpdateNotification
                                               object:nil];

    if (self.navigationController) {
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFoodToMeal:)]];
        //[self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addFoodToMeal:)]];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:mhedFoodDataUpdateNotification
                                                  object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // 2 sections
        // -- Meal section
        // -- Ingredient section
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {
        return [[self.delegate mealsList] count];
    }
    
    else if (section == 1) {
        return [[self.delegate ingredientsList] count];
    }
    
    return 0;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Meals";
    }
    else if (section == 1) {
        return @"Ingredients";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
//    if (indexPath.section == 0) {
//        cell = [tableView dequeueReusableCellWithIdentifier:mhedAddFoodButtonCellIdentifier forIndexPath:indexPath];
//        cell.textLabel.text = @"Add";
//    }
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellMealCell forIndexPath:indexPath];
        
        EDMeal *mealForCell = [self.delegate mealsList][indexPath.row];
        
        cell.textLabel.text = mealForCell.name;
        
        // detail label
    }
    
    else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:mhedTableCellIngredientCell forIndexPath:indexPath];
        
        EDIngredient *ingredientForCell = [self.delegate ingredientsList][indexPath.row];
        
        cell.textLabel.text = ingredientForCell.name;
    }

    
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

*/



#pragma mark - Table View Delegate


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self performSegueWithIdentifier:mhedSegueIDBrowseFoodSegue sender:self];
    }
    
}


#pragma mark - segue methods

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: mhedSegueIDBrowseFoodSegue]) {
        MHEDBrowseFoodViewController *destinationVC = segue.destinationViewController;
        
        destinationVC.delegate = self.delegate;
    }
}

- (void) addFoodToMeal: (id) sender
{
    [self performSegueWithIdentifier:mhedSegueIDBrowseFoodSegue sender:self];
}

#pragma mark - Notifications

- (void) handleFoodDataUpdateNotification: (id) sender
{
    if (self.isViewLoaded && self.view.window) {
        [self.tableView reloadData];
    }
}

@end
