//
//  EDSelectTagsViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/7/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDSelectTagsViewController.h"

#import "EDTag+Methods.h"

#import "EDEliminatedAPI+Fetching.h"
#import "EDEliminatedAPI+Helpers.h"
#import "EDEliminatedAPI+Sorting.h"

@interface EDSelectTagsViewController ()

@end

@implementation EDSelectTagsViewController

- (NSSet *) tagsList
{
    if (!_tagsList) {
        _tagsList = [[NSSet alloc] init];
    }
    return _tagsList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    self.populatedTableUsingFRC = YES;
    self.customSectionOrdering = NO;
    
    [super viewWillAppear:animated];
    
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
    return [EDTag fetchAllTags];
    
}


#pragma mark - Table View Controller Delegate and Data Source -

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"tag selection cell id";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    EDTag *tagForIndexPath = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (tagForIndexPath)
    {
        cell.textLabel.text = tagForIndexPath.name;
        
        if ([self.tagsList containsObject:tagForIndexPath]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    
    
    
    return cell;
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDTag *tagForIndexPath = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([self.tagsList containsObject:tagForIndexPath]) {
        NSMutableSet *mutTagsList = [self.tagsList mutableCopy];
        [mutTagsList removeObject:tagForIndexPath];
        self.tagsList = [mutTagsList copy];
    }
    
    else {
        self.tagsList = [self.tagsList setByAddingObject:tagForIndexPath];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    
}

- (IBAction)doneButtonPress:(id)sender {
    
    [self.delegate addTagsToList:self.tagsList];
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
