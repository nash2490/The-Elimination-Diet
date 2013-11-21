//
//  EDSelectionViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/6/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDSelectionViewController.h"
#import "EDTimeAndDescriptionCell.h"

#import "NSError+MultipleErrors.h"
#import "EDDocumentHandler.h"
#import "NSString+EatDate.h"


static NSString *selectionCellIdentifier = @"Selection Cell Identifier";


@interface EDSelectionViewController ()

- (CGRect) setUpTableViewFrame;
- (UITableView *) setUpTableView: (CGRect) frame withStyle: (UITableViewStyle) style;
- (id) getObjectForIndexPath: (NSIndexPath *) indexPath;

- (void) updateTable;

- (void) handleLeftNavButtonPress: (id) sender;
- (void) handleRightNavButtonPress: (id) sender;

@end

@implementation EDSelectionViewController


- (NSSet *) selectedObjects
{
    if (_selectedObjects == nil) {
        _selectedObjects = [[NSSet alloc] init];
    }
    return _selectedObjects;
}

- (NSDictionary *) fetchedObjects
{
    if (_fetchedObjects == nil) {
        _fetchedObjects = [[NSDictionary alloc] init];
    }
    return _fetchedObjects;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // SUBCLASS override - cell reuse identifier
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self tableView] registerClass:[UITableView class] forCellReuseIdentifier:selectionCellIdentifier];
    }
    return self;
}


# pragma mark - View Methods

- (void) viewWillAppear:(BOOL)animated
{
    // SUBCLASS - override but copy uncommented code
    
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) {
        [[EDDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            self.managedObjectContext = document.managedObjectContext;
            
            /*
             [EDMeal setUpDefaultMealsInContext:self.managedObjectContext];
             
             NSError *error;
             //NSArray *allMeals = [self.managedObjectContext executeFetchRequest:[EDMeal fetchAllMeals] error:&error];
             
             if ([allMeals count]) {
             EDMeal *mealToEat = allMeals[1];
             
             //[EDEatenMeal createEatenMealWithMeal:mealToEat atTime:[NSDate distantPast] forContext:self.managedObjectContext];
             [EDEatenMeal eatMealNow:mealToEat forContext:self.managedObjectContext];
             }
             */
            
            [self updateTable];
        }];
    }
    
    else if (self.managedObjectContext) {
        [self updateTable];
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    // SUBCLASS - super
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    // SUBCLASS - super
    
    self.rightButtonStyle = DoneButton;
    
    [super viewDidLoad];
    
    // set up table view
    self.tableView = [self setUpTableView:[self setUpTableViewFrame] withStyle:UITableViewStylePlain];
    [self.topView addSubview:self.tableView];
    
    
    // set the fetch requests
    [self setDefaultFetchRequests];
}

- (CGRect) setUpTopViewFrame {
    // SUBCLASS - override/super
    
    return self.view.bounds;
}

- (UIView *) setUpTopView: (CGRect) frame
{
    // SUBCLASS - super
    
    UIView *tempView = [[UIView alloc] initWithFrame:frame];
    NSLog(@"values (%f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    tempView.backgroundColor = TAN_BACKGROUND;
    tempView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    
    /*
     
     // set up search text field
     CGFloat width = CGRectGetWidth(tempView.frame);
     CGRect searchBarRect = CGRectMake( 20.0, 10, width - 20.0, 25.0);
     
     self.searchBar = [self defaultTextFieldWithFrame:searchBarRect placeholder:@"search" andText:nil];
     
     [tempView addSubview:self.searchBar];
     
     // set up the buttons for different meal fetches
     CGRect allMealsRect = CGRectMake( 10.0, 40.0, 60.0, 25.0);
     CGRect recentMealsRect = CGRectMake( 80.0, 40.0, 60.0, 25.0);
     CGRect favoriteMealsRect = CGRectMake( 150.0, 40.0, 60.0, 25.0);
     
     self.allMealsButton = [self defaultButtonWithFrame:allMealsRect title:@"All" withSelector:@selector(handleFetchButtonPress:)];
     self.recentMealsButton = [self defaultButtonWithFrame:recentMealsRect title:@"Recent" withSelector:@selector(handleFetchButtonPress:)];
     self.favoriteMealsButton = [self defaultButtonWithFrame:favoriteMealsRect title:@"Favorite" withSelector:@selector(handleFetchButtonPress:)];
     
     [tempView addSubview:self.allMealsButton];
     [tempView addSubview:self.recentMealsButton];
     [tempView addSubview:self.favoriteMealsButton];
     
     */
    
    return tempView;
}

- (void) handleFetchButtonPress: (id) sender
{
    // SUBCLASS - override
    
    /*
     
     if ([self.allMealsButton isEqual:sender])
     {
     // disable current button and enable all others
     self.allMealsButton.enabled = NO;
     self.recentMealsButton.enabled = YES;
     self.favoriteMealsButton.enabled = YES;
     self.typesMealsButton.enabled = YES;
     
     // set fetch requests / string for fetch
     self.stringForFetch = ALL_MEALS_FETCH_NAME;
     
     // update table
     [self updateTable];
     
     }
     
     
     */
}

- (CGRect) setUpTableViewFrame
{
    // SUBCLASS - OVERRIDE
    
    if (self.topView) {
        return self.topView.bounds;
    }
    return self.view.bounds;
}

- (UITableView *) setUpTableView: (CGRect) frame withStyle: (UITableViewStyle) style
{
    // SUBCLASS - super
    
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:frame style:style];
    
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


- (void) handleKeyboardWillShow: (NSNotification *) paramNotification
{
    NSDictionary *userInfo = [paramNotification userInfo];
    
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *animationDurationObject = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *keyboardEndRectObject = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    
    NSUInteger animationCurve = 0;
    double animationDuration = 0.0f;
    CGRect keyboardEndRect = CGRectMake(0, 0, 0, 0);
    
    [animationCurveObject getValue:&animationCurve];
    [animationDurationObject getValue:&animationDuration];
    [keyboardEndRectObject getValue:&keyboardEndRect];
    
    [UIView beginAnimations:@"changeTableViewContentInset" context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    
    CGRect intersectionOfTopViewAndKeyboardRect = CGRectIntersection(self.topView.frame, keyboardEndRect);
    
    
     CGFloat navBarHeight = 0.0f;
     if (self.navigationController) {
     navBarHeight = self.navigationController.navigationBar.frame.size.height;
     }
     
     CGFloat statusBarHeight = 0.0f;
     if (![UIApplication sharedApplication].statusBarHidden) {
     statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
     }
     CGFloat tableInset = intersectionOfTopViewAndKeyboardRect.size.height + navBarHeight + statusBarHeight;
     
     
     self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, tableInset, 0.0f);
    
    [UIView commitAnimations];
}


- (void) handleKeyboardWillHide:(NSNotification *)paramNotification
{
    
     if (UIEdgeInsetsEqualToEdgeInsets(self.tableView.contentInset, UIEdgeInsetsZero)){
     // Our table view's content inset is intact so no need to reset it
     return; }
     NSDictionary *userInfo = [paramNotification userInfo]; NSValue *animationCurveObject =
     [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey]; NSValue *animationDurationObject =
     [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey]; NSValue *keyboardEndRectObject =
     [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey]; NSUInteger animationCurve = 0;
     
     double animationDuration = 0.0f;
     CGRect keyboardEndRect = CGRectMake(0, 0, 0, 0);
     [animationCurveObject getValue:&animationCurve]; [animationDurationObject getValue:&animationDuration]; [keyboardEndRectObject getValue:&keyboardEndRect]; [UIView beginAnimations:@"changeTableViewContentInset"
     context:NULL];
     [UIView setAnimationDuration:animationDuration];
     [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve]; self.tableView.contentInset = UIEdgeInsetsZero;
     
    
    [UIView commitAnimations];
}

#pragma mark - Core Data -
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        
    }
}

- (void) performFetch
{
    if (self.managedObjectContext) {
        NSArray *fetchNames = [self.fetchRequests allKeys];
        
        if ([fetchNames count]) {
            for (NSString *name in fetchNames) {
                
                [self performFetch:name];
            }
        }
        
        else if (self.stringForFetch) {
            [self performFetch:self.stringForFetch];
        }
    }
}

- (void) performFetch: (NSString *) fetchName
{
    NSMutableDictionary *mutFetchedObjects = [self.fetchedObjects mutableCopy];
    NSArray *sectionHeaders = [[NSArray alloc] init];
    //NSError *error;
    
    if (self.managedObjectContext) {
        
        /*
        if ([fetchName isEqualToString:ALL_MEALS_FETCH_NAME]) {
            
            
            NSArray *objects = [self.managedObjectContext executeFetchRequest:[EDMeal fetchAllMeals] error:&error];
            NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            NSArray *sortedArray = [objects sortedArrayUsingDescriptors:@[sorter]];
            
            NSArray *sections = [self sortMealsIntoSectionByName:sortedArray];
            
            [mutFetchedObjects setObject:sections forKey:ALL_MEALS_FETCH_NAME];
            
            
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
            if (![mutFetchedObjects objectForKey:TYPES_MEALS_FETCH_NAME]) {
                NSArray *sections = [self sortMealsIntoSectionByType: sortedArray];
                
                [mutFetchedObjects setObject:sections forKey:TYPES_MEALS_FETCH_NAME];
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
            
            NSArray *objects = [self.managedObjectContext executeFetchRequest:[EDEatenMeal fetchEatenMealsForLastWeek] error:&error];
            NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
            NSArray *sortedArray = [objects sortedArrayUsingDescriptors:@[sorter]];
            
            NSArray *sections = [self sortMealsIntoSectionByDate: sortedArray];
            
            [mutFetchedObjects setObject:sections forKey:RECENT_MEALS_FETCH_NAME];
            
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
        */
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.fetchedObjects = [mutFetchedObjects copy];
            self.sectionHeaders = sectionHeaders;
        });
        
    }
}


- (void) setFetchRequests:(NSDictionary *)fetchRequests
{
    NSDictionary *oldFetchRequests = _fetchRequests;
    if (oldFetchRequests != fetchRequests) {
        _fetchRequests = fetchRequests;
        if (fetchRequests) {
            [self updateTable];
        }
        else {
            [self.tableView reloadData];
        }
    }
}



- (void) setDefaultFetchRequests
{
    // if we use methods or custom settings for the objects use stringForFetch
    // self.stringForFetch = ...;
    
    /* -- if we INSTEAD use actual NSFetchRequests do it like this
    NSFetchRequest *allFetch = [EDMeal fetchAllMeals];
    NSFetchRequest *favoriteFetch = [EDMeal fetchFavoriteMeals];
    NSFetchRequest *recentFetch = [EDMeal fetchRecentMeals];
    NSFetchRequest *typesFetch = [EDMeal fetchMealsForTypesWithContext:self.managedObjectContext];
    
    [self setFetchRequests: [NSDictionary dictionaryWithObjectsAndKeys:
                             allFetch, ALL_MEALS_FETCH_NAME,
                             favoriteFetch, STARRED_MEALS_FETCH_NAME,
                             recentFetch, RECENT_MEALS_FETCH_NAME,
                             typesFetch, TYPES_MEALS_FETCH_NAME, nil]];
     */
    
    
}

/*
// sorting of discrete property values into obvious sections
- (NSArray *) sortDiscreteIntoSectionsArray: (NSArray *) objects
                                 byProperty: (NSString *) property
                                  ascending: (BOOL) ascending
                       sectionCompareMethod: (SEL) selectionCompareMethod
{
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:property ascending:ascending];
    NSArray *sortedArray = [objects sortedArrayUsingDescriptors:@[sorter]];
    
    NSMutableArray *mutSectionRanges = [NSMutableArray arrayWithObject:@0];
    
    for (int i = 0; i < [objects count] - 1; i++) {
        if ([sortedArray[i] respondsToSelector:selectionCompareMethod] &&
            [sortedArray[i+1] respondsToSelector:selectionCompareMethod])
        {
            BOOL equal = [[sortedArray[i] performSelector:selectionCompareMethod] isEqual:
                          [sortedArray[i+1] performSelector:selectionCompareMethod]];
            
            if (!equal) {
                [mutSectionRanges addObject:@(i)];
            }
        }
    }
    
    NSArray *sectionRanges = [mutSectionRanges copy];
    
    NSMutableArray *sections = [NSMutableArray array];
    for (int j = 0; j < [sectionRanges count] - 1; j++) {
        
        NSRange range = NSMakeRange([(NSNumber *)sectionRanges[j] intValue], [(NSNumber *)sectionRanges[j+1] intValue]);
        [sections addObject:[sortedArray subarrayWithRange:range]];
    }
    
    return [sections copy];
}


*/

#pragma mark - Table View Delegate Methods -

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    int result = 0;
    
    if ([self.tableView isEqual:tableView]) {
        result = [self.sectionHeaders count];
    }
    return result;
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray *result = [[NSArray alloc] init];
    
    if ([tableView isEqual:self.tableView]) {
        if (self.sectionHeaders) {
            for (int i=0; i < [self.sectionHeaders count]; i++) {
                
                NSString *header = self.sectionHeaders[i];
                NSUInteger length = MIN(6, [header length]-1);
                NSString *indexHeader = [header substringToIndex:length];
                result = [result arrayByAddingObject:indexHeader];
            }
        }
    }
    
    return result;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * title;
    
    if ([tableView isEqual:self.tableView]) {
        title = self.sectionHeaders[section];
    }
    
    return title;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int result = 0;
    
    if ([tableView isEqual:self.tableView]) {
        NSArray *allSections = (self.fetchedObjects)[self.stringForFetch];
        
        NSArray *arrayForSection = allSections[section];
        
        result = [arrayForSection count];
        //NSLog(@"In section %i, there are %i rows", section, result);
        
    }
    return result;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *result = nil;
    /*
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
            NSLog(@"The text label for %@ ----------------------", cell.timeLabel.text);
            
            return cell;
        }
    }
    */
    return result;
}

- (id) getObjectForIndexPath: (NSIndexPath *) indexPath {
    
    id objectForIndexPath = nil;
    
    NSArray *allSections = (self.fetchedObjects)[self.stringForFetch];
    
    NSArray *arrayForSection = allSections[indexPath.section];
    
    objectForIndexPath = arrayForSection[indexPath.row];
    
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
