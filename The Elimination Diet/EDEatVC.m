//
//  EDEatVC.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/24/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEatVC.h"

@interface EDEatVC ()

@end

@implementation EDEatVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"I'm Eating...";
    }
    return self;
}

- (id) initWithDefaultOptions
{
    //NSArray *options = [[NSArray alloc] initWithObjects:@"Create New", @"Favorites", @"Recent", @"By Location" , @"By Food", nil];
    
    self = [self initWithNibName:Nil bundle:Nil];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableAccessory = UITableViewCellAccessoryDisclosureIndicator;
    
    self.tableObjects = @{@"DEFAULT": @[@"Create New Meal"], @"Quick Find": @[@"Favorites", @"Recent"], @"Browse": @[@"By Location", @"By Food"]};
    self.tableSectionHeaders = @[@"DEFAULT", @"Quick Find", @"Browse"];

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
     //NSArray *options = [[NSArray alloc] initWithObjects:@"Create New", @"Favorites", @"Recent", @"By Location" , @"By Food", nil];
    
    UIViewController *detailViewController = nil;
    
    switch (indexPath.section) {
        
        case 0: // create a new meal
            
            
            break;
            
        case 1: // quick find
            
            switch (indexPath.row) {
                case 0: // favorites
                    
                    break;
                    
                case 1: // recent
                
                    break;
                    
                default:
                    break;
            }
            
            break;
            
        case 2: // browse
            
            switch (indexPath.row) {
                case 0: // location
                    
                    break;
                    
                case 1: // food
                    
                    break;
                    
                default:
                    break;
            }
            
            break;
            
        default:
            break;
    }
    return detailViewController;
}

@end
