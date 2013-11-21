//
//  EDMainMenuVC.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/22/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDMainMenuVC.h"
#import "EDEatVC.h"

#import "EDDocumentHandler.h"

@interface EDMainMenuVC ()

@end

@implementation EDMainMenuVC

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
    NSArray *options = @[@"I'm Eating...", @"I'm Feeling...", @"View Trends", @"I'm NOT eating..." , @"Remind me too...", @"", @"Look Freely", @"Options"];
    
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

- (UIViewController *) viewControllerForDisclosureIndicator:(NSIndexPath *)indexPath
{
    UIViewController *detailViewController = nil;
    
    switch (indexPath.section) {
        case 0:
            detailViewController = [[EDEatVC alloc] initWithDefaultOptions];
            break;
            
        case 1:
            break;
            
        default:
            break;
    }
    return detailViewController;
}

@end
