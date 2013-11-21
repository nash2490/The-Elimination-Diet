//
//  EDEliminatedIngredientTableViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/5/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedIngredientTableViewController.h"
#import "EDEliminatedIngredient+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDDocumentHandler.h"

#define ELIMINATION_INGREDIENT_ENTITY @"EDEliminatedIngredient"
#define ELIMINATION_INGREDIENT_TABLECELL @"Eliminated Ingredient Table Cell"

@interface EDEliminatedIngredientTableViewController ()

@end

@implementation EDEliminatedIngredientTableViewController

- (void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        if (!self.fetchedResultsController) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:ELIMINATION_INGREDIENT_ENTITY];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
            fetchRequest.predicate = nil;
            
            self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                managedObjectContext:managedObjectContext
                                                                                  sectionNameKeyPath:nil
                                                                                           cacheName:nil];
        }
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:ELIMINATION_INGREDIENT_TABLECELL];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!self.managedObjectContext) {
        [[EDDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
            self.managedObjectContext = document.managedObjectContext;
        }];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ELIMINATION_INGREDIENT_TABLECELL];
    
    EDEliminatedIngredient *elimIngredient = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = elimIngredient.ingredient.name;
    
    return cell;
}

@end
