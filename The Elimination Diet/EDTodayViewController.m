//
//  EDTodayViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/3/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDTodayViewController.h"
#import "EDDateView.h"
#import "EDTimeAndDescriptionCell.h"

#import "NSString+EatDate.h"
#import "NSError+MHED_MultipleErrors.h"
#import "EDDocumentHandler.h"

#import "EDEatenMealTableViewController.h"
#import "EDSelectMealsViewController.h"

#import "EDMeal+Methods.h"
#import "EDTag+Methods.h"

#import "EDEvent+Methods.h"
#import "EDEatenMeal+Methods.h"
#import "EDEliminatedFood+Methods.h"

#import "EDAddScreenViewController.h"



static NSString *ReminderCellIdentifier = @"Reminder Cell Identifier";
static NSString *EliminatedCellIdentifier = @"Eliminated Cell Identifier";
static NSString *SummaryCellIdentifier = @"Summary Cell Identifier";


@interface EDTodayViewController ()

- (CGRect) setUpTableViewFrame;
- (UITableView *) setUpTableView: (CGRect) frame;

- (id) getObjectForIndexPath: (NSIndexPath *) indexPath;

- (void) updateTable;

- (void) handleLeftNavButtonPress: (id) sender;
- (void) handleRightNavButtonPress: (id) sender;

@end


@implementation EDTodayViewController

#pragma mark - Core Data -
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        if (!self.fetchRequests) {
            [self setDefaultFetchRequests];
        }
    }
}

- (void) performFetch
{
    NSArray *fetchNames = [self.fetchRequests allKeys];
    NSMutableDictionary *mutFetchedObjects = [NSMutableDictionary dictionary];
    
    NSError *error;

    if (self.managedObjectContext) {
        for (NSString *name in fetchNames) {
            
            NSFetchRequest *fetch = (self.fetchRequests)[name];
            
            NSError *fetchError;
            NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:&fetchError];
            
            if (results) {
                mutFetchedObjects[name] = results;
            }
            else {
                mutFetchedObjects[name] = [[NSArray alloc] init];
            }
            
            // if there was no previous error, return the new error
            if (error == nil) {
                error = fetchError;
            }
            // if there was a previous error, combine it with the existing one
            else {
                error = [NSError errorFromOriginalError:error error:fetchError];
            }
        }
        
        self.fetchedObjects = [mutFetchedObjects copy];
        
        [self.tableView reloadData];
    }
}


- (void) setFetchRequests:(NSDictionary *)fetchRequests
{
    NSDictionary *oldFetchRequests = _fetchRequests;
    if (oldFetchRequests != fetchRequests) {
        _fetchRequests = fetchRequests;
        if (fetchRequests) {
            //[self performFetch];
        }
        else {
            [self.tableView reloadData];
        }
    }
}

- (void) setDefaultFetchRequests
{
    //      - reminders - later
    //      - eliminated - for now just get all (so food and restaurant are together)
    //      - summary of today
    
    NSFetchRequest *eliminatedFetch = [EDEliminatedFood fetchAllCurrentEliminatedFoods];
    NSFetchRequest *summaryFetch = [EDEatenMeal fetchEatenMealsForTodayWithMedication:NO];
    
    [self setFetchRequests: @{@"Eliminated": eliminatedFetch, @"Day Summary": summaryFetch}];
}


# pragma mark - View Controller Methods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Today";
        [[self tableView] registerClass:[EDTimeAndDescriptionCell class] forCellReuseIdentifier:ReminderCellIdentifier];
        [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:EliminatedCellIdentifier];
        [[self tableView] registerClass:[EDTimeAndDescriptionCell class] forCellReuseIdentifier:SummaryCellIdentifier];

    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) {
        [[EDDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            self.managedObjectContext = document.managedObjectContext;
            
            [EDMeal setUpDefaultMealsInContext:self.managedObjectContext];
            [EDTag setUpDefaultTagsInContext:self.managedObjectContext];
            
            NSError *error;
            NSArray *allMeals = [self.managedObjectContext executeFetchRequest:[EDMeal fetchAllMeals] error:&error];
            
            if ([allMeals count]) {
                                
                for (int i=0; i < 5; i++) {
                    int randMealIndex = arc4random() % ([allMeals count] -1);
                    EDMeal *mealToEat = allMeals[randMealIndex];
                    [EDEatenMeal eatMealNow:mealToEat forContext:self.managedObjectContext];
                }
                
                for (int j=0; j < 3; j++) {
                    int randTime = arc4random() % 600000;
                    NSDate *date = [NSDate dateWithTimeInterval:-randTime sinceDate:[NSDate date]];
                    
                    int randMealIndex = arc4random() % ([allMeals count] -1);
                    EDMeal *mealToEat = allMeals[randMealIndex];
                    [EDEatenMeal createEatenMealWithMeal:mealToEat atTime:date forContext:self.managedObjectContext];
                }
                
                //[EDEatenMeal createEatenMealWithMeal:mealToEat atTime:[NSDate distantPast] forContext:self.managedObjectContext];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateTable];
            });
        }
         ];
    }
    
    else if (self.managedObjectContext) {
        [self performFetch];
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{    
    self.leftButtonStyle = CameraButton;
    self.rightButtonStyle = PlusButton;
    
    [super viewDidLoad];
    
    // set up table view
    self.tableView = [self setUpTableView:[self setUpTableViewFrame]];
    [self.topView addSubview:self.tableView];
    

    // set the fetch requests
    [self setDefaultFetchRequests];
}

- (CGRect) setUpTopViewFrame {
    return self.view.bounds;
}

- (UIView *) setUpTopView: (CGRect) frame
{
    UIView *tempView = [[UIView alloc] initWithFrame:frame];
    //NSLog(@"values (%f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    tempView.backgroundColor = TAN_BACKGROUND;
    tempView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    
    // make date header
    CGFloat width = CGRectGetWidth(tempView.frame);
    //NSLog(@"values (%f, %f, %f, %f", self.topView.frame.origin.x, self.topView.frame.origin.y, self.topView.frame.size.width, self.topView.frame.size.height);
    
    CGRect headerRect = CGRectMake(0.0, 0.0, width, 40.0);
    
    EDDateView *dateView = [[EDDateView alloc] initWithFrame:headerRect];
    [dateView setBackgroundColor:TAN_YELLOW_BACKGROUND];
    dateView.delegate = self;
    [dateView drawViewInFrame];
    
    self.dateHeader = dateView;
    
    [tempView addSubview:self.dateHeader];
    
    return tempView;
}

- (CGRect) setUpTableViewFrame
{
    if (self.topView && self.dateHeader) {
        return CGRectMake(0.0,
                          CGRectGetHeight(self.dateHeader.frame),
                          CGRectGetWidth(self.topView.frame),
                          CGRectGetHeight(self.topView.frame) - CGRectGetHeight(self.dateHeader.frame));
    }
    return self.view.bounds;
}

- (UITableView *) setUpTableView: (CGRect) frame
{
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    
    tempTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    tempTableView.delegate = self;
    tempTableView.dataSource = self;
    
    [tempTableView setBackgroundColor: [UIColor clearColor]];
    //self.tableView.backgroundColor = TAN_YELLOW_BACKGROUND;
    tempTableView.separatorColor = BROWN_SEPARATOR_COLOR;
    
    return tempTableView;
}

- (void) updateTable
{
    [self performFetch];
}

- (void) handleLeftNavButtonPress: (id) sender
{
    
}

- (void) handleRightNavButtonPress: (id) sender
{
    //EDSelectMealsViewController *detailViewController = [[EDSelectMealsViewController alloc] initWithNibName:nil bundle:nil];
    //EDTodayViewController *detailViewController = [[EDTodayViewController alloc] initWithNibName:nil bundle:nil];
    //EDAddScreenViewController *detailViewController = [[EDAddScreenViewController alloc] initWithNibName:nil bundle:nil];
    EDEatenMealTableViewController *detailViewController = [[EDEatenMealTableViewController alloc] initWithNibName:nil bundle:nil];

    [[self navigationController] pushViewController:detailViewController animated:YES];
}

#pragma mark - EDDateViewProtocol methods -

- (NSDate *) getDateForDisplay
{
    return [NSDate date];
}


#pragma mark - Table View Delegate Methods -

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    int result = 0;
    if ([tableView isEqual:self.tableView]) {
        result = 3;
    }
    return result;
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray *result = nil;
    return result;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * title;
    
    if ([tableView isEqual:self.tableView]) {
        switch (section) {
            case 0:
                title = @"Reminders";
                break;
                
            case 1:
                title = @"Eliminated";
                break;
                
            case 2:
                title = @"Day Summary";
                break;
                
            default:
                break;
        }
    }
    return nil;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int result = 0;
    
    if ([tableView isEqual:self.tableView]) {
        NSArray *reminders = (self.fetchedObjects)[@"Reminders"];
        NSArray *eliminated = (self.fetchedObjects)[@"Eliminated"];
        NSArray *summary = (self.fetchedObjects)[@"Day Summary"];

        switch (section) {
            case 0:
                if ([reminders count]) {
                    result = 1;
                }
                break;
                
            case 1:
                if ([eliminated count]) {
                    result = 1;
                }
                break;
                
            case 2:
                if ([summary count]) {
                    result = [summary count];
                }
                break;
                
            default:
                break;
        }
    }
    return result;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *result = nil;
    if ([tableView isEqual:self.tableView]) {
        
        
        // gets the objects for the indexPath
        if (indexPath.section == 0) {
            EDTimeAndDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:ReminderCellIdentifier];
            
            if (cell == nil) {
                cell = [[EDTimeAndDescriptionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ReminderCellIdentifier];
                
            }
            
            return cell;
        }
        
        else if (indexPath.section == 1) {
            
        }
        
        else if (indexPath.section == 2 ) {
            EDTimeAndDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:SummaryCellIdentifier];
            
            if (cell == nil) {
                cell = [[EDTimeAndDescriptionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SummaryCellIdentifier];
                
            }
            
            EDEatenMeal *eatenMealForCell = [self getObjectForIndexPath:indexPath];
                        
            cell.timeLabel.text = [NSString convertEatDateToHoursAndMin:eatenMealForCell.date];
            cell.timeLabel.textAlignment = NSTextAlignmentCenter;
            
            cell.indentationWidth = CGRectGetWidth(cell.timeLabel.frame);
            cell.indentationLevel = 1;
            cell.textLabel.text = eatenMealForCell.meal.name;
            //NSLog(@"The text label for %@ ----------------------", cell.timeLabel.text);
            
            return cell;
        }
        
        
    }
    return result;
}

- (id) getObjectForIndexPath: (NSIndexPath *) indexPath {
    
    id objectForIndexPath = nil;
    
    if (indexPath.section == 0) { // reminders
        
    }
    
    else if (indexPath.section == 1) { // eliminated
        
    }
    
    else if (indexPath.section == 2) { // day summary
        NSArray *day = (self.fetchedObjects)[@"Day Summary"];
        objectForIndexPath = day[indexPath.row];
    }
    
    return objectForIndexPath;
}

- (void) removeObjectForIndexPath: (NSIndexPath *) indexPath {
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    id objectForIndexPath = [self getObjectForIndexPath:indexPath];
    UITableViewCell *cellForIndexPath = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    // if were are in a checked table
    if (self.tableAccessory == UITableViewCellAccessoryCheckmark) {
        
        // if object IS in self.primaryCheckedTableObjects then remove it and remove checkmark
        if ([self.primaryCheckedTableObjects containsObject:objectForIndexPath])
        {
            NSMutableArray *mutPrimaryCheckedTableObjects = [self.primaryCheckedTableObjects mutableCopy];
            
            [mutPrimaryCheckedTableObjects removeObject: [self getObjectForIndexPath:indexPath]];
            self.primaryCheckedTableObjects = [mutPrimaryCheckedTableObjects copy];
            
            cellForIndexPath.accessoryType = UITableViewCellAccessoryNone;
        }
        
        // if object is in self.secondaryTableObjects then do nothing
        else if ([self.secondaryCheckedTableObjects containsObject:objectForIndexPath])
        {
            
        }
        
        else // object was not in either sets so it was not checked, so we add it to self.primaryCheckedTableObjects and add a checkmark
        {
            NSMutableArray *mutPrimaryCheckedTableObjects = [self.primaryCheckedTableObjects mutableCopy];
            
            [mutPrimaryCheckedTableObjects addObject: [self getObjectForIndexPath:indexPath]];
            self.primaryCheckedTableObjects = [mutPrimaryCheckedTableObjects copy];
            
            cellForIndexPath.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    else if (self.tableAccessory == UITableViewCellAccessoryDisclosureIndicator) {
        // if you select a cell with a disclosure indicator then it changes the VC based on the selected cell
        [self.navigationController pushViewController:[self viewControllerForDisclosureIndicator:indexPath] animated:YES];
    }
    
    else if (self.tableAccessory == UITableViewCellAccessoryDetailDisclosureButton) {
        // nothing
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     */
}

@end
