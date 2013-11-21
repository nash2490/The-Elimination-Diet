//
//  EDMainMenuViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/22/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDMainMenuViewController.h"

@interface EDMainMenuViewController ()

@end

@implementation EDMainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Main Menu";
    }
    return self;
}

- (id) initWithDefaultOptions
{
    NSArray *options = [[NSArray alloc] initWithObjects:@"Eat", @"Feel", @"Analysis", @"Eliminated Food", nil];
    
    self = [super initWithOptions:options];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableAccessory = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    // Navigation logic may go here. Create and push another view controller.
    
}

- (UIViewController *) viewControllerForDetailDisclosureButton:(NSIndexPath *)indexPath
{
    UIViewController *detailViewController = nil;
    
    switch (indexPath.section) {
        case 0:
            // detailViewController = [[STEatSelectionScreenViewController alloc] initWithDefaultOptionsAndStyle:UITableViewStylePlain];
            break;
            
        case 1:
            break;
            
        default:
            break;
    }
    
    if (detailViewController) {
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    return detailViewController;
}

@end
