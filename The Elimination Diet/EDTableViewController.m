//
//  EDTableViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/8/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDTableViewController.h"

@interface EDTableViewController ()

@end

@implementation EDTableViewController

- (NSDictionary *) tableObjects {
    if (!_tableObjects) {
        _tableObjects = [[NSDictionary alloc] init];
    }
    return _tableObjects;
}

- (NSSet *) primaryCheckedTableObjects {
    if (!_primaryCheckedTableObjects) {
        _primaryCheckedTableObjects = [[NSSet alloc] init];
    }
    return _primaryCheckedTableObjects;
}

- (NSSet *) secondaryCheckedTableObjects {
    if (!_secondaryCheckedTableObjects) {
        _secondaryCheckedTableObjects = [[NSSet alloc] init];
    }
    return _secondaryCheckedTableObjects;
}


- (NSArray *) tableSectionHeaders {
    if (!_tableSectionHeaders) {
        if ([self.tableObjects count]) {
            _tableSectionHeaders = [self.tableObjects allKeys];
        }
        else {
            _tableSectionHeaders = [[NSArray alloc] init];
        }
    }
    return _tableSectionHeaders;
}

- (NSString *) keyPathForCellTitle {
    if (!_keyPathForCellTitle) {
        _keyPathForCellTitle = @"name";
    }
    return _keyPathForCellTitle;
}

- (NSString *) keyPathForCellSubtitle {
    if (!_keyPathForCellSubtitle) {
        _keyPathForCellSubtitle = @"name";
    }
    return _keyPathForCellSubtitle;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(handleKeyboardWillShow:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(handleKeyboardWillHide:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateTable];
    [self.tableView reloadData];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

// SUBCLASS
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create tableView and add as subview
    self.tableView = [self setUpTableView:[self setUpTableViewFrame]];
    
    [self.topView addSubview:self.tableView];
}



// SUBCLASS - redefine the bounds
//      - gets called in viewDidLoad
- (CGRect) setUpTopViewFrame {
    return [super setUpTopViewFrame];
}

- (UIView *) setUpTopView: (CGRect) frame {
    return [super setUpTopView:frame];
}

// SUBCLASS - redefine the bounds
//      - gets called in viewDidLoad
- (CGRect) setUpTableViewFrame {
    if (self.topView) {
        return self.topView.bounds;
    }
    return self.view.bounds;
}

- (UITableView *) setUpTableView:(CGRect) frame {
    
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    
    tempTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    
    tempTableView.delegate = self;
    tempTableView.dataSource = self;
    
    [tempTableView setBackgroundColor: [UIColor clearColor]];
    //self.tableView.backgroundColor = TAN_YELLOW_BACKGROUND;
    tempTableView.separatorColor = BROWN_SEPARATOR_COLOR;
    
    return tempTableView;
}

- (void) updateProperties
{
    // override in subclass
    [self saveCheckedTableObjects];
}

- (void) updateTable
{
    // override in subclass
}

- (void) saveCheckedTableObjects
{
    // override in subclass
}

// launches when a keyboard shows on screen,
// - this is to adjust the screen to view the table
- (void) handleKeyboardWillShow: (NSNotification *) paramNotification {
    
    
    
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
    
    //NSIndexPath *indexPathOfOwnerCell = nil;
    
    /* Also, make sure the selected text field is visible on the screen */
    //NSInteger numberOfCells = [self.stTableView.dataSource tableView:self.stTableView numberOfRowsInSection:0];
    
    /* So let's go through all the cells and find their accessory text fields. Once we have the reference to those text fields, we can see which one of them is the first responder (has the keyboard) and we will make a call
     to the table view to make sure that, after the keyboard is displayed, that specific cell is NOT obstructed by the keyboard */
    /*
     for (NSInteger counter = 0; counter < numberOfCells; counter++){
     
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:counter inSection:0];
     UITableViewCell *cell = [self.stTableView cellForRowAtIndexPath:indexPath];
     UITextField *textField = (UITextField *)cell.accessoryView;
     if ([textField isKindOfClass:[UITextField class]] == NO){
     continue;
     }
     if ([textField isFirstResponder]){ indexPathOfOwnerCell = indexPath;
     break;
     }
     }
     */
    [UIView commitAnimations];
    /*
     if (indexPathOfOwnerCell != nil){
     [self.stTableView scrollToRowAtIndexPath:indexPathOfOwnerCell
     atScrollPosition:UITableViewScrollPositionMiddle
     animated:YES];
     }
     */
}

- (void) handleKeyboardWillHide:(NSNotification *)paramNotification{
    if (UIEdgeInsetsEqualToEdgeInsets(self.tableView.contentInset, UIEdgeInsetsZero)){
        /* Our table view's content inset is intact so no need to reset it */
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

// -------------------------------------------------------
// Data Source Methods for Ingredient Type Table

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    int result = 0;
    if ([tableView isEqual:self.tableView]) {
        result = [self.tableSectionHeaders count];
    }
    return result;
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray *result = nil;
    if ([tableView isEqual:self.tableView]) {
        if ([self.tableSectionHeaders count]){
            result = self.tableSectionHeaders;
        }
    }
    return result;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionHeader = (self.tableSectionHeaders)[section];
    NSArray *sectionObjects = (self.tableObjects)[sectionHeader];
    
    if ([sectionObjects count] // if the section is not empty
        && ![sectionHeader isEqualToString:@"DEFAULT"] // AND header is not default
        && ([sectionHeader integerValue] != section)) { // AND header is not string of section
        return sectionHeader;
    }
    return nil;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    
    int result = 0;
    
    if ([tableView isEqual:self.tableView]) {
        NSString *key = (self.tableSectionHeaders)[section];
        NSArray *objectsForSection = (self.tableObjects)[key];
        result = [objectsForSection count];
    }
    return result;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *result = nil;
    if ([tableView isEqual:self.tableView]) {
        
        // getting the reusable cell through the reuse identifier
        static NSString *tableViewCellIdentifier = @"MainCells";
        static NSString *tableViewButtonCellIdentifier = @"ButtonCells";
        //static NSString *selectionScreenRowIdentifier = @"Selection Screen Row";
        
        
        // gets the objects for the indexPath
        id objectForCellAtIndexPath = [self getObjectForIndexPath:indexPath];
        
        if ([objectForCellAtIndexPath isKindOfClass:[UIButton class]]) {
            result = [tableView dequeueReusableCellWithIdentifier:tableViewButtonCellIdentifier];
            
            // if the cell hasnt been defined with the reuse identifier, it creates one
            if (result == nil) {
                result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:tableViewButtonCellIdentifier];
            }
            
            UIButton *tableButton = (UIButton *)objectForCellAtIndexPath;
            CGRect buttonFrame = CGRectInset(result.contentView.bounds, 75.0, 5.0);
            [tableButton setFrame: buttonFrame];
            [tableButton setCenter:result.contentView.center];
            
            [result.contentView addSubview:tableButton];
        }
        
        else {
            result = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
            
            // if the cell hasnt been defined with the reuse identifier, it creates one
            if (result == nil) {
                result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                reuseIdentifier:tableViewCellIdentifier];
            }
            
            
            // TITLE OF CELL - if the object has a name property define it as the title of the cell
            result.textLabel.text = [self stringFromObject:objectForCellAtIndexPath andKeyPath: self.keyPathForCellTitle];
            
            // SUBTITLE OF CELL -
            if (self.cellSubtitle) {
                result.detailTextLabel.text = [self stringFromObject:objectForCellAtIndexPath andKeyPath:self.keyPathForCellSubtitle];
            }
            
            if (self.tableAccessory == UITableViewCellAccessoryCheckmark) {
                
                // if the object for the cell is in the checkedTableObjects array we give it a checkmark
                if ([self.primaryCheckedTableObjects containsObject:objectForCellAtIndexPath]) {
                    result.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else if ([self.secondaryCheckedTableObjects containsObject:objectForCellAtIndexPath]) {
                    // CHANGE THIS - MAKE THIS THE CUSTOM GREY IMAGE
                    result.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else {
                    result.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            else if (self.tableAccessory == UITableViewCellAccessoryDisclosureIndicator) {
                result.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else if (self.tableAccessory == UITableViewCellAccessoryDetailDisclosureButton) {
                result.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            }
            
        }
        
    }
    return result;
}

- (id) getObjectForIndexPath: (NSIndexPath *) indexPath {
    
    id objectForIndexPath = nil;
    
    // gets the objects for the section indexPath.section
    if ([self.tableSectionHeaders count]) {
        
        NSArray *objectsForSection = (self.tableObjects)[(self.tableSectionHeaders)[indexPath.section]];
        
        if (objectsForSection) {
            // gets the object at the row
            objectForIndexPath = objectsForSection[indexPath.row];
        }
    }
    
    return objectForIndexPath;
}

- (void) removeObjectForIndexPath: (NSIndexPath *) indexPath {
    // gets the objects for the section indexPath.section
    NSString *key = (self.tableSectionHeaders)[indexPath.section];
    NSArray *objectsForSection = (self.tableObjects)[key];
    
    // gets the object at the row
    NSMutableArray *mutObjectsForSection = [objectsForSection mutableCopy];
    [mutObjectsForSection removeObjectAtIndex:indexPath.row];
    NSMutableDictionary *mutTableObjects = [self.tableObjects mutableCopy];
    [mutTableObjects removeObjectForKey:key];
    mutTableObjects[key] = mutObjectsForSection;
    self.tableObjects = [mutTableObjects copy];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete row from data source
        //[self.tableObjects objectForKey:];
    }
}


- (UIViewController *) viewControllerForDisclosureIndicator: (NSIndexPath *) indexPath{
    // subclass if you want to use a disclosure button to replace the current VC with a new VC
    return nil;
}
- (UIViewController *) viewControllerForDetailDisclosureButton: (NSIndexPath *) indexPath {
    // subclass if you want to use a detail disclosure button to replace the current VC with a new VC
    return nil;
}

// this means the detail disclosure button was tapped
- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // detail disclosure means we want to edit the object at the location
    //      - we replace the current VC with the edit VC for the object
    //          - we just forward to viewControllerForDetailDisclosureButton:
    
    [self.navigationController pushViewController:[self viewControllerForDetailDisclosureButton:indexPath] animated:YES];
}


- (NSString *) stringFromObject: (id) obj andKeyPath:(NSString *)keyPath
{
    // Default is to use a method specific to the object - contentsAsString
    
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    
    else if ([obj valueForKeyPath:keyPath])
    {
        
        if ([[obj valueForKeyPath:keyPath] isKindOfClass:[NSString class]])
        {
            return [obj valueForKeyPath:keyPath];
        }
        
        else if([[obj valueForKeyPath:keyPath] isKindOfClass:[NSArray class]])
        {
            NSString *string = @"";
            NSArray *arrayOfString = [obj valueForKeyPath:keyPath];
            string = [[EDTableViewController sortArrayOfString:arrayOfString] componentsJoinedByString:@","];
            
            return string;
        }
        
    }
    return @"";
}

// objects is an array of arrays
+ (NSDictionary *) defaultDictionaryForTableObjectsUsingObjects: (NSArray *) objects
{
    if ([objects count]) {
        return [EDTableViewController dictionaryForTableObjectsUsingObjects:objects
                                                          andSectionHeaders:@[@"DEFAULT"]];
    }
    
    return [[NSDictionary alloc] init];
}

// creates section headers 1,2,...
+ (NSDictionary *) indexedDictionaryForTableObjectsUsingObjects:(NSArray *)objects
{
    NSArray *tempHeaders = [[NSArray alloc] init];
    
    for (int i = 0; i < [objects count]; i++) {
        tempHeaders = [tempHeaders arrayByAddingObject:[NSString stringWithFormat:@"%i", i]];
    }
    return [EDTableViewController dictionaryForTableObjectsUsingObjects:objects
                                                      andSectionHeaders:tempHeaders];
}

// objects is an array of arrays
+ (NSDictionary *) dictionaryForTableObjectsUsingObjects: (NSArray *) objects
                                       andSectionHeaders: (NSArray *) headers
{
    return [[NSDictionary alloc] initWithObjects:objects forKeys:headers];
    
}

- (void) updateTableObjectsAndSectionHeaders: (NSDictionary *) objects
{
    [self updateTableObjects:objects withOrderedSectionHeaders:
                            [EDTableViewController sortArrayOfString:[objects allKeys]]];
}

- (void) updateTableObjects: (NSDictionary *) objects withOrderedSectionHeaders: (NSArray *) headers
{
    self.tableObjects = objects;
    self.tableSectionHeaders = headers;
}

@end
