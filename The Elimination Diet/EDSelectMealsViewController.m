//
//  EDSelectMealsViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/6/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDSelectMealsViewController.h"
#import "EDTimeAndDescriptionCell.h"

#import "EDEliminatedAPI+Helpers.h"

#import "EDDocumentHandler.h"

#import "EDFood+Methods.h"
#import "EDMeal+Methods.h"
#import "EDType+Methods.h"

#import "EDEvent+Methods.h"
#import "EDEatenMeal+Methods.h"
#import "EDEliminatedFood+Methods.h"


#define STARRED_MEALS_FETCH_NAME @"Display Favorite Meals"
#define RECENT_MEALS_FETCH_NAME @"Display Recent Meals"
#define ALL_MEALS_FETCH_NAME @"Display All Meals"
#define TYPES_MEALS_FETCH_NAME @"Display Meals by its Types"

static NSString *MealCellIdentifier = @"Meal Cell Identifier";
static NSString *EatenMealCellIdentfier = @"Eaten Meal Cell Identifier";


@interface EDSelectMealsViewController ()

- (CGRect) setUpTableViewFrame;
- (UITableView *) setUpTableView: (CGRect) frame;

- (id) getObjectForIndexPath: (NSIndexPath *) indexPath;

- (void) updateTable;

- (void) handleLeftNavButtonPress: (id) sender;
- (void) handleRightNavButtonPress: (id) sender;

@end

@implementation EDSelectMealsViewController


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
        [[self tableView] registerClass:[UITableView class] forCellReuseIdentifier:MealCellIdentifier];
        [[self tableView] registerClass:[EDTimeAndDescriptionCell class] forCellReuseIdentifier:EatenMealCellIdentfier];
    }
    return self;
}

# pragma mark - View Methods -


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) {
        [[EDDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            self.managedObjectContext = document.managedObjectContext;
            
            [EDMeal setUpDefaultMealsInContext:self.managedObjectContext];
            
            NSError *error;
            NSArray *allMeals = [self.managedObjectContext executeFetchRequest:[EDMeal fetchAllMeals] error:&error];
            
            if ([allMeals count]) {
                //EDMeal *mealToEat = [allMeals lastObject];
                
                //[EDEatenMeal createEatenMealWithMeal:mealToEat atTime:[NSDate distantPast] forContext:self.managedObjectContext];
                //[EDEatenMeal eatMealNow:mealToEat forContext:self.managedObjectContext];
            }
            
            [self updateTable];
            
        }];
    }
    
    else if (self.managedObjectContext) {
        [self updateTable];
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    self.rightButtonStyle = DoneButton;
    
    [super viewDidLoad];
    
    self.allMealsButton.enabled = NO;
}



- (CGRect) setUpTopViewFrame {
    return self.view.bounds;
}

- (UIView *) setUpTopView: (CGRect) frame
{
    UIView *tempView = [[UIView alloc] initWithFrame:frame];
    //NSLog(@"values (%f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    tempView.backgroundColor = TAN_BACKGROUND;
    tempView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // set up search text field
    CGFloat width = CGRectGetWidth(tempView.frame);    
    CGRect searchBarRect = CGRectMake( 0.0, 0.0, width, 40.0);
    
    self.searchBar = [self defaultSearchBarWithFrame:searchBarRect placeholder:@"search" andText:nil];
        
    [tempView addSubview:self.searchBar];
    
    // set up the buttons for different meal fetches
    CGRect allMealsRect = CGRectMake( 10.0, 40.0, 60.0, 25.0);
    CGRect recentMealsRect = CGRectMake( 80.0, 40.0, 60.0, 25.0);
    CGRect favoriteMealsRect = CGRectMake( 150.0, 40.0, 60.0, 25.0);
    CGRect typesMealsRect = CGRectMake( 220.0, 40.0, 60.0, 25.0);


    self.allMealsButton = [self defaultButtonWithFrame:allMealsRect title:@"All" withSelector:@selector(handleFetchButtonPress:)];
    self.recentMealsButton = [self defaultButtonWithFrame:recentMealsRect title:@"Recent" withSelector:@selector(handleFetchButtonPress:)];
    self.favoriteMealsButton = [self defaultButtonWithFrame:favoriteMealsRect title:@"Favorite" withSelector:@selector(handleFetchButtonPress:)];
    self.typesMealsButton = [self defaultButtonWithFrame:typesMealsRect title:@"Types" withSelector:@selector(handleFetchButtonPress:)];
    
    [tempView addSubview:self.allMealsButton];
    [tempView addSubview:self.recentMealsButton];
    [tempView addSubview:self.favoriteMealsButton];
    [tempView addSubview:self.typesMealsButton];

    return tempView;
}




- (CGRect) setUpTableViewFrame
{
    if (self.topView && self.searchBar) {
        return CGRectMake(0.0,
                          70.0,
                          CGRectGetWidth(self.topView.frame),
                          CGRectGetHeight(self.topView.frame) - 70.0);
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
    dispatch_queue_t performFetchQueue = dispatch_queue_create("fetch EDMeal objects", NULL);
    dispatch_async(performFetchQueue, ^{
        [self performFetch];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
    });
    
}


- (void) handleLeftNavButtonPress: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) handleRightNavButtonPress: (id) sender
{
    // go back to the previous page but pass along the selected meals
    
    //EDEatenMealTableViewController *detailViewController = [[EDEatenMealTableViewController alloc] initWithNibName:nil bundle:nil];
    
    //[[self navigationController] pushViewController:detailViewController animated:YES];
}

- (void) handleFetchButtonPress: (id) sender
{
    if ([self.allMealsButton isEqual:sender])
    {
        self.allMealsButton.enabled = NO;
        self.recentMealsButton.enabled = YES;
        self.favoriteMealsButton.enabled = YES;
        self.typesMealsButton.enabled = YES;
        
        // fetch for all meals
        self.stringForFetch = ALL_MEALS_FETCH_NAME;
        // set the table objects to all meals
        [self updateTable];
    }
    
    else if ([self.recentMealsButton isEqual:sender])
    {
        self.allMealsButton.enabled = YES;
        self.recentMealsButton.enabled = NO;
        self.favoriteMealsButton.enabled = YES;
        self.typesMealsButton.enabled = YES;
        
        // fetch for recent meals
        self.stringForFetch = RECENT_MEALS_FETCH_NAME;
        
        // set the table objects to recent meals
        [self updateTable];
    }
    
    else if ([self.favoriteMealsButton isEqual:sender])
    {
        self.allMealsButton.enabled = YES;
        self.recentMealsButton.enabled = YES;
        self.favoriteMealsButton.enabled = NO;
        self.typesMealsButton.enabled = YES;
        
        // fetch for favorite meals
        self.stringForFetch = STARRED_MEALS_FETCH_NAME;
        
        // set the table objects to favorite meals
        [self updateTable];
    }
    
    else if ([self.typesMealsButton isEqual:sender])
    {
        self.allMealsButton.enabled = YES;
        self.recentMealsButton.enabled = YES;
        self.favoriteMealsButton.enabled = YES;
        self.typesMealsButton.enabled = NO;
        
        // fetch for meals sorted into sections by its type
        self.stringForFetch = TYPES_MEALS_FETCH_NAME;
        
        // set the table objects to meals for type
        [self updateTable];
    }
    

}



#pragma mark - Core Data -

/*
 - (void) setFetchRequests:(NSDictionary *)fetchRequests
 {
 NSDictionary *oldFetchRequests = _fetchRequests;
 if (oldFetchRequests != fetchRequests) {
 _fetchRequests = fetchRequests;
 if (fetchRequests) {
 [self performFetch];
 }
 else {
 [self.tableView reloadData];
 }
 }
 }
 
 
 */

- (void) setDefaultFetchRequests
{
    self.stringForFetch = ALL_MEALS_FETCH_NAME;
}

- (void) performFetch
{

    [super performFetch];
}

- (void) performFetch: (NSString *) fetchName
{
    NSMutableDictionary *mutFetchedObjects = [self.fetchedObjects mutableCopy];
    NSArray *sectionHeaders = [[NSArray alloc] init];
    NSError *error;
    
    if (self.managedObjectContext) {
        
        if ([fetchName isEqualToString:ALL_MEALS_FETCH_NAME]) {
            
            
            NSArray *objects = [self.managedObjectContext executeFetchRequest:[EDMeal fetchAllMeals] error:&error];
            NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            NSArray *sortedArray = [objects sortedArrayUsingDescriptors:@[sorter]];
            
            NSArray *sections = [self sortMealsIntoSectionByName:sortedArray];
            
            mutFetchedObjects[ALL_MEALS_FETCH_NAME] = sections;
            
            
            // set the section header by getting object from each section and asking why its there
            for (int i = 0; i < [sections count]; i++) {
                NSArray *secI = sections[i];
                EDMeal *meal = [secI lastObject];
                
                sectionHeaders = [sectionHeaders arrayByAddingObject:[meal nameFirstLetter]];
            }
        }
        
        else if ([fetchName isEqualToString:TYPES_MEALS_FETCH_NAME]) {
            
            NSArray *objects = [self.managedObjectContext executeFetchRequest:[EDType fetchAllTypes] error:&error];
            NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            NSArray *sortedArray = [objects sortedArrayUsingDescriptors:@[sorter]];
            
            
            // if we have already done this before and sorted, then we don't need to do again
            if (!mutFetchedObjects[TYPES_MEALS_FETCH_NAME]) {
                NSArray *sections = [self sortMealsIntoSectionByType: sortedArray];
                
                mutFetchedObjects[TYPES_MEALS_FETCH_NAME] = sections;
            }
            
            
            
            /// section headers are just the types ordered by name
            for (int q=0; q < [sortedArray count]; q++) {
                
                EDType *type = sortedArray[q];
                NSString *headerForType = type.name;
                sectionHeaders = [sectionHeaders arrayByAddingObject:headerForType];
            }
        }
        
        else if ([fetchName isEqualToString:STARRED_MEALS_FETCH_NAME]) {
            
        }
        
        else if ([fetchName isEqualToString:RECENT_MEALS_FETCH_NAME]) {// actually this displays eaten meals
            
            NSArray *objects = [self.managedObjectContext executeFetchRequest:[EDEatenMeal fetchEatenMealsForLastWeekWithMedication:NO] error:&error];
            NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
            NSArray *sortedArray = [objects sortedArrayUsingDescriptors:@[sorter]];
            
            NSArray *sections = [self sortMealsIntoSectionByDate: sortedArray];
            
            mutFetchedObjects[RECENT_MEALS_FETCH_NAME] = sections;
            
            // set the section header by date counting backward for each section
            for (int i = 0; i < [sections count]; i++) {
                double secondsFromToday = -60 * 60 * 24 * i;
                NSDate *day = [EDEvent beginningOfDay:[NSDate dateWithTimeIntervalSinceNow: secondsFromToday]];
                
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit fromDate:day];
                
                
                
                NSInteger intDay = [components day];
                NSInteger intMonth = [components month];
                NSInteger intYear = [components year];
                
                NSString *headerForDay = [NSString stringWithFormat:@"%i/%i/%i", intMonth, intDay, intYear];
                
                sectionHeaders = [sectionHeaders arrayByAddingObject:headerForDay];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.fetchedObjects = [mutFetchedObjects copy];
            self.sectionHeaders = sectionHeaders;
        });
        
    }
}



// sorting of discrete property values into obvious sections
- (NSArray *) sortMealsIntoSectionByName: (NSArray *) sortedMeals
{
    
    // hope to use this eventually
    /*
     [self sortDiscreteIntoSectionsArray: objects
     byProperty: @"name"
     ascending: YES
     sectionCompareMethod: @selector(firstLeter:)]; // make first letter method
     */
    
    NSMutableArray *mutSectionRanges = [NSMutableArray arrayWithObject:@0];
    
    for (int i = 0; i < [sortedMeals count] - 1; i++) {
        
        EDMeal *mealA = sortedMeals[i];
        EDMeal *mealB = sortedMeals[i+1];
        
        BOOL equal = [[mealA nameFirstLetter] isEqualToString:
                      [mealB nameFirstLetter]];
        
        //NSLog(@"Is meal[i] name, %@, have same 1st letter as meal[i+1] name, %@, = %i", mealA.name, mealB.name, equal);

        
        if (!equal) { // if not equal we have i+1 the start of the next section
            [mutSectionRanges addObject:@(i+1)];
        }
    }
    
    // sets the end of the ranges at 1 beyond the last entry - we subtract 1 when we get ranges
    [mutSectionRanges addObject:[NSNumber numberWithInt:(NSInteger)[sortedMeals count]]];

    NSArray *sectionRanges = [mutSectionRanges copy];
    
    NSMutableArray *sections = [NSMutableArray array];
    
    for (int j = 0; j < [sectionRanges count] - 1; j++) {
        
        // the range is [j, j+1) so we must subtract 1 from the (j+1)th entry so we don't include it 
        NSRange range = [EDSelectMealsViewController rangeFromStart:[(NSNumber *)sectionRanges[j] intValue]
                                      andEnd:([(NSNumber *)sectionRanges[j+1] intValue] - 1)];

        //NSLog(@"Range for this section has loc = %i and length = %i)", range.location, range.length);

        NSArray *arrayForRange = [sortedMeals subarrayWithRange:range];
        
        [sections addObject:arrayForRange];
    }
    
    
    return [sections copy];
}


// THIS ACTUALLY RETURNS EATEN MEALS
- (NSArray *) sortMealsIntoSectionByDate: (NSArray *) sortedEatenMeals
{
    
    // interval is by day, so if we do a week, then we have 7 days and thus 7 sections
    NSMutableArray *mutSectionArrays = [NSMutableArray arrayWithCapacity:7];
    
    // give it 7 empty mutabale arrays
    for (int i = 1; i <= 7; i++) {
        [mutSectionArrays addObject:[NSMutableArray array]];
    }
    
    NSArray *sectionArrays = [mutSectionArrays copy];
    
    NSDate *endOfDay = [EDEvent endOfDay:[NSDate date]];
    double secondsInDay = 60 * 60 * 24;
    
    for (int j = 0; j < [sortedEatenMeals count]; j++)
    {
        EDEatenMeal *eatenMeal = sortedEatenMeals[j];
        
        double interval = [endOfDay timeIntervalSinceDate:eatenMeal.date];
        double days = interval/secondsInDay;
        
        NSLog(@"meal date = %@", [eatenMeal.date description]);
        NSLog(@"end of today = %@", [endOfDay description]);
        NSLog(@"interval = %f", interval);
        NSLog(@"days = %f", days);
        
        NSInteger arraySubscript = floor(fabs(days));
        
        NSMutableArray *sec = sectionArrays[arraySubscript];
        
        [sec addObject:eatenMeal];
    }
    
    return sectionArrays;
}

- (NSArray *) sortMealsIntoSectionByType: (NSArray *) sortedTypes
{
    NSMutableArray *mutSections = [NSMutableArray arrayWithCapacity:[sortedTypes count]];
    
    for (int i = 0; i < [sortedTypes count]; i++)
    {
        EDType *type = sortedTypes[i]; // get i_th type in array sorted by name
        NSSet *unsortedMeals = [type determineMeals]; // determine the types - its unordered set
        NSArray *sortedMeals = [[unsortedMeals allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]]; // sort the meals by name 
        
        [mutSections addObject:sortedMeals]; // add to section in correct order
    }
    
    return [mutSections copy];
}


+ (NSRange) rangeFromStart: (NSInteger) start andEnd: (NSInteger) end
{
    int location = start;
    int length = end + 1 - start;
    return NSMakeRange(location, length);
}

#pragma mark - Table View Delegate Methods -

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    int result = 0;
    if ([tableView isEqual:self.tableView]) {
        
        result = [self.sectionHeaders count];
        //NSLog(@"number of sections = %i", result);
    }
    return result;
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray *result = [[NSArray alloc] init];
    
    if ([tableView isEqual:self.tableView]) {
        if (self.sectionHeaders) {
            
            if ([self.stringForFetch isEqualToString:RECENT_MEALS_FETCH_NAME]) {
                for (int i=0; i < [self.sectionHeaders count]; i++) {
                    
                    NSString *header = self.sectionHeaders[i];
                    
                    NSArray *dateComponents = [header componentsSeparatedByString:@"/"];
                    NSString *month = dateComponents[0];
                    NSString *day = dateComponents[1];
                    
                    NSString *indexHeader = [NSString stringWithFormat:@"%@/%@", month, day];
                    result = [result arrayByAddingObject:indexHeader];
                }
                
                
            }
            else {
                for (int i=0; i < [self.sectionHeaders count]; i++) {
                    
                    NSString *header = self.sectionHeaders[i];
                    NSUInteger length = MIN(9, [header length]-1);
                    NSString *indexHeader = [header substringToIndex:length];
                    result = [result arrayByAddingObject:indexHeader];
                }
            }
        }
    }
    
    return result;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [super tableView:tableView titleForHeaderInSection:section];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *result = nil;
    if ([tableView isEqual:self.tableView]) {
        
        
        if ([self.stringForFetch isEqualToString:ALL_MEALS_FETCH_NAME] ||
            [self.stringForFetch isEqualToString:STARRED_MEALS_FETCH_NAME] ||
            [self.stringForFetch isEqualToString:TYPES_MEALS_FETCH_NAME]) {
            
            EDMeal *mealForIndexPath = [self getObjectForIndexPath:indexPath];
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MealCellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MealCellIdentifier];
            }
            
            cell.textLabel.text = mealForIndexPath.name;
            cell.detailTextLabel.text = nil;
            
            if ([self.selectedObjects containsObject:mealForIndexPath.uniqueID]) {
                //NSLog(@"name for meal = %@", mealForIndexPath.name);
                //NSLog(@"id for meal is = %@", mealForIndexPath.uniqueID);
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            result = cell;
        }
        
        else if ([self.stringForFetch isEqualToString:RECENT_MEALS_FETCH_NAME]) {
            EDEatenMeal *eatenMealForIndexPath = [self getObjectForIndexPath:indexPath];
            
            EDTimeAndDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:EatenMealCellIdentfier];
            
            if (cell == nil) {
                cell = [[EDTimeAndDescriptionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:EatenMealCellIdentfier];
                
            }
                        
            cell.timeLabel.text = [NSString convertEatDateToHoursAndMin:eatenMealForIndexPath.date];
            cell.timeLabel.textAlignment = NSTextAlignmentCenter;
            
            cell.indentationWidth = CGRectGetWidth(cell.timeLabel.frame);
            cell.indentationLevel = 1;
            cell.textLabel.text = eatenMealForIndexPath.meal.name;
            //NSLog(@"The text label for %@ ----------------------", cell.timeLabel.text);
            
            if ([self.selectedObjects containsObject:eatenMealForIndexPath.meal.uniqueID]) {
                //NSLog(@"name for meal = %@", eatenMealForIndexPath.meal.name);
                //NSLog(@"id for meal is = %@", eatenMealForIndexPath.meal.uniqueID);
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            result = cell;
        }
    }
    
    return result;
}

- (id) getObjectForIndexPath: (NSIndexPath *) indexPath {
    
    return [super getObjectForIndexPath:indexPath];
}

- (void) removeObjectForIndexPath: (NSIndexPath *) indexPath {
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableSet *mutSelectedObjects = [self.selectedObjects mutableCopy];
    NSSet *indices = [[NSSet alloc] init];
    //EDMeal *mealForIndexPath = [self getObjectForIndexPath:indexPath];
    NSString *mealUniqueID = @"";
    
    // determine the meal represented by the indexPath of selection and find all other cells that represent the same meal
    if ([self.stringForFetch isEqualToString:ALL_MEALS_FETCH_NAME] ||
        [self.stringForFetch isEqualToString:STARRED_MEALS_FETCH_NAME] ||
        [self.stringForFetch isEqualToString:TYPES_MEALS_FETCH_NAME])
    {
        EDMeal *mealForIndexPath = [self getObjectForIndexPath:indexPath];
        
        //NSLog(@"name for meal = %@", mealForIndexPath.name);
        
        mealUniqueID = mealForIndexPath.uniqueID;
        
        if ([self.stringForFetch isEqualToString:TYPES_MEALS_FETCH_NAME]) { // there are potentially several cells for this meal
            indices = [self indexPathsForMeal:mealUniqueID];
        }
        
        else { // then the meal only occurs once
            indices = [[NSSet alloc] initWithObjects:indexPath, nil];
        }
    }
    
    else if ([self.stringForFetch isEqualToString:RECENT_MEALS_FETCH_NAME])
    {
        EDEatenMeal *eatenMealForIndexPath = [self getObjectForIndexPath:indexPath];
        EDMeal *mealForIndexPath = eatenMealForIndexPath.meal;
        //NSLog(@"name for meal = %@", mealForIndexPath.name);

        mealUniqueID = mealForIndexPath.uniqueID;
        
        indices = [self indexPathsForMeal:mealUniqueID];
    }
    
    
    // if the meal is contained then the selection removes it
    if ([mutSelectedObjects containsObject:mealUniqueID]) {
        [mutSelectedObjects removeObject:mealUniqueID];
    }
    else { // otherwise we want to add it 
        [mutSelectedObjects addObject:mealUniqueID];
    }
    
    self.selectedObjects = [mutSelectedObjects copy];
    
    // for every cell representing the meal we modify the checkmark
    for (NSIndexPath *path in indices) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        
        if ([self.selectedObjects containsObject:mealUniqueID]) {
            //NSLog(@"id for meal is = %@", mealUniqueID);
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            //NSLog(@"id for meal is = %@", mealUniqueID);
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    

    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[tableView reloadData];
    
    
    
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

- (NSSet *) indexPathsForMeal: (NSString *) mealUniqueID
{
    NSMutableSet *mutIndexPaths = [NSMutableSet set];
    
    if ([self.stringForFetch isEqualToString:ALL_MEALS_FETCH_NAME] ||
        [self.stringForFetch isEqualToString:STARRED_MEALS_FETCH_NAME]) {
        // a meal only occurs once in these cases so we don't have to worry about
    }
    
    else if ([self.stringForFetch isEqualToString:TYPES_MEALS_FETCH_NAME])
    {
        NSArray *allSections = (self.fetchedObjects)[self.stringForFetch];
        
        for (int i=0; i < [allSections count]; i++) {
            NSArray *section = allSections[i];
            
            for (int j=0; j < [section count]; j++) {
                EDMeal *meal = section[j];
                NSString *tempID = meal.uniqueID;
                
                if ([tempID isEqualToString:mealUniqueID]) {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:j inSection:i];
                    [mutIndexPaths addObject:path];
                }
            }
        }
    }
    
    else if ([self.stringForFetch isEqualToString:RECENT_MEALS_FETCH_NAME])
    {
        NSArray *allSections = (self.fetchedObjects)[self.stringForFetch];
        
        for (int i=0; i < [allSections count]; i++) {
            NSArray *section = allSections[i];
            
            
            for (int j=0; j < [section count]; j++) {
                EDEatenMeal *eat = section[j];
                NSString *tempID = eat.meal.uniqueID;
                
                if ([tempID isEqualToString:mealUniqueID]) {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:j inSection:i];
                    [mutIndexPaths addObject:path];
                }
            }
        }
    }
    
    return [mutIndexPaths copy];
}


#pragma mark - Search Bar -

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

@end
