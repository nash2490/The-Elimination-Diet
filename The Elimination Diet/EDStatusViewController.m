//
//  EDStatusViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/18/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDStatusViewController.h"

#import "EDSearchToEatViewController.h"


#import "EDEliminatedAPI.h"
#import "EDEliminatedAPI+Helpers.h"

#import "EDEliminatedFood+Methods.h"
#import "EDFood+Methods.h"
#import "EDDocumentHandler.h"

#import "EDSymptom+Methods.h"
#import "EDHadSymptom+Methods.h"
#import "EDEliminatedFood+Methods.h"

#define ACTION_TABLE_CELL_ID @"Action Table Cell ID"


@interface EDStatusViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, strong) NSFetchRequest *fetchRequestCurrentElimFood;
//@property (nonatomic, strong) NSFetchRequest *fetchRequestSymptomFree;

@property (nonatomic) BOOL coreDataUpToDate;

@property (nonatomic, strong) NSArray *currentElimFoods;
@property (nonatomic, strong) EDHadSymptom *mostRecentHadSymptom;


@property (weak, nonatomic) IBOutlet UIView *mhedStatusView;
@property (weak, nonatomic) IBOutlet UILabel *eliminatedFoodNumberLabel;
@property (weak, nonatomic) IBOutlet UITextView *eliminatedFoodListTextView;

@property (weak, nonatomic) IBOutlet UILabel *eliminationFoodChangeLabel;

@property (weak, nonatomic) IBOutlet UILabel *symptomFreeLabel;


@property (weak, nonatomic) IBOutlet UITableView *mhedActionsTableView;

@property (nonatomic, strong) UIImage *quickCaptureImage;
@property (nonatomic, strong) UIImage *barcodeImage;
@property (nonatomic, strong) UIImage *symptomImage;
@property (nonatomic, strong) UIImage *browseImage;
@property (nonatomic, strong) UIImage *mealDetailsImage;


@end

@implementation EDStatusViewController

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
    NSLog(@"Table View is good ? = %d", (self.mhedActionsTableView != nil));
	// Do any additional setup after loading the view.
    
//    self.fetchRequestCurrentElimFood = [self defaultFetchRequestCurrentElimFood];
//    self.fetchRequestSymptomFree = [self defaultFetchRequestSymptomFree];
    
    self.eliminatedFoodListTextView.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
    
    [self setupCoreData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.coreDataUpToDate == NO && self.managedObjectContext) { // if we have a MOC but the view isn't up to date
        [self setupCoreData];
    }
}

- (void) setupCoreData
{
    if (!self.managedObjectContext) {
        
        [[EDDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            self.coreDataUpToDate = YES;
    
            [self setManagedObjectContext:document.managedObjectContext];
            
            [EDEliminatedFood setUpDefaultEliminatedFoodsInContext:document.managedObjectContext];
            [EDHadSymptom setUpDefaultHadSymptomsWithContext:document.managedObjectContext];
            
            [self performFetch];
            
#warning run this on main thread
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateStatusView];
            });
            
        }];
    }
    
    else if (self.managedObjectContext) {
        self.coreDataUpToDate = YES;

        [self performFetch];
        
        [self updateStatusView];
        
    }

    
}


- (void) updateStatusView
{
    // make the string for the eliminated foods
    //      - if there are current elim foods then make a string from them
    
    
    UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline] fontDescriptor];
    UIFont *newFont = [UIFont fontWithDescriptor:descriptor size:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline].pointSize + 3];
    
    if ([self.currentElimFoods count]) {
        
        self.eliminatedFoodNumberLabel.text = [NSString stringWithFormat:@"Avoid - (%i)", [self.currentElimFoods count]];
        
        NSMutableArray *elimFoodNamesArray = [@[] mutableCopy];
        
        for (int i = 0; i < [self.currentElimFoods count]; i++) {
            EDEliminatedFood *food = self.currentElimFoods[i];
            
            NSAttributedString *new = [[NSAttributedString alloc] initWithString:food.eliminatedFood.name attributes:
                                       @{NSFontAttributeName: newFont,
                                         NSForegroundColorAttributeName: [UIColor whiteColor],
                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                         }];
            
            [elimFoodNamesArray addObject:new];
        }
        
        NSAttributedString *commaSpace = [[NSAttributedString alloc] initWithString:@", " attributes:
                                          @{NSFontAttributeName: newFont,
                                            NSForegroundColorAttributeName: [UIColor whiteColor]
                                            }];
        
        NSAttributedString *elimHeader = [elimFoodNamesArray attributedComponentsJoinedByAttributedString:commaSpace];
//        NSAttributedString *attElimHeader = [[NSAttributedString alloc] initWithString:elimHeader attributes:
//                                             @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
//                                               NSForegroundColorAttributeName: [UIColor whiteColor]
//                                               }];
        
        [self.eliminatedFoodListTextView.textStorage setAttributedString: elimHeader];
        
    }
    
    // if there are no current elim foods then need to determine what to do
    else {
        
        // if we are just starting, then we want the user to add foods to elim or to try for a week
        self.eliminatedFoodNumberLabel.text = @"Avoid - (0) ";
        
        NSAttributedString *attElimHeader = [[NSAttributedString alloc] initWithString:@"None" attributes:
                                             @{NSFontAttributeName: newFont,
                                               NSForegroundColorAttributeName: [UIColor whiteColor]
                                               }];
        
        [self.eliminatedFoodListTextView.textStorage setAttributedString: attElimHeader];
        
        // and present an alert asking the user what they want to do
            // (1) add elim food
            // (2) try for a week
        
        
        // if we are finishing then we have a problem
        
    }
    
    
    NSString *elimSubText = [NSString stringWithFormat:@"%i days to change", [self daysUntilChangeElimFoods]];
    self.eliminationFoodChangeLabel.text = elimSubText;
    
    NSString *symptomTextTime = [self timeSinceSymptom:self.mostRecentHadSymptom];
    self.symptomFreeLabel.text = [NSString stringWithFormat:@"%@ since last symptom", symptomTextTime];
}

- (NSInteger) daysUntilChangeElimFoods
{
    return 2;
}

- (NSString *) timeSinceSymptom:(EDHadSymptom *) hadSymptom
{
    if (hadSymptom && hadSymptom.date) {
        NSDate *symptomDate = hadSymptom.date;
        
        NSCalendar *currentCalendar = [NSCalendar currentCalendar];
        
        NSUInteger unitFlags = NSHourCalendarUnit | NSDayCalendarUnit;
        
        NSDateComponents *components = [currentCalendar components:unitFlags
                                                          fromDate:symptomDate
                                                            toDate:[NSDate date] options:0];
        NSInteger days = [components day];
        NSInteger hours = [components hour];
        
        if (days == 0) {
            if (hours == 1) {
                return @"1 hour";
            }
            return [NSString stringWithFormat:@"%i hours", hours];
        }
        else {
            return [NSString stringWithFormat:@"%i days, %i hours", days, hours];
        }
    }
    return nil;
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.coreDataUpToDate = NO;
}


#pragma mark - Core Data

- (NSFetchRequest *) defaultFetchRequestCurrentElimFood
{
    return [EDEliminatedFood fetchAllCurrentEliminatedFoods];
}

- (NSFetchRequest *) defaultFetchRequestSymptomFree
{
    return nil;
}

- (void) performFetch
{
    NSError *error;
    self.currentElimFoods = [self.managedObjectContext executeFetchRequest:[EDEliminatedFood fetchAllCurrentEliminatedFoods] error:&error];
    
    self.mostRecentHadSymptom = [EDHadSymptom fetchMostRecentHadSymptomInContext:self.managedObjectContext];
    
    // fetch data for filling in old meal info
}


#pragma mark - Table View Delegate




#pragma mark - table View Data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ACTION_TABLE_CELL_ID];
    
    if (!cell) {
        
        UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
        
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:ACTION_TABLE_CELL_ID];
    }
    
    NSInteger rowNumber = indexPath.row;

    switch (rowNumber) {
        
        case 0:
            cell.textLabel.text = @"Quick Capture";
            if (self.quickCaptureImage) {
                cell.imageView.image = self.quickCaptureImage;
            }
            
            break;
            
        case 1:
            cell.textLabel.text = @"Barcode Scanner";
            if (self.barcodeImage) {
                cell.imageView.image = self.barcodeImage;
            }
            
            break;
            
            
        case 2:
            cell.textLabel.text = @"Symptom";
            cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            if (self.symptomImage) {
                cell.imageView.image = self.symptomImage;
            }
            
            break;
            
        case 3:
            cell.textLabel.text = @"Browse Food";
            if (self.browseImage) {
                cell.imageView.image = self.browseImage;
            }
            
            break;
            
            
        case 4:
            cell.textLabel.text = @"Enter Meal Details";
            if (self.mealDetailsImage) {
                cell.imageView.image = self.mealDetailsImage;
            }
            
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNumber = indexPath.row;
    
    switch (rowNumber) {
            
        case 0:
            // QuickCaptureSegue
            [self performSegueWithIdentifier:@"QuickCaptureSegue" sender:self];
            
            break;
            
        case 1:
            // barcode
            
            break;
            
            
        case 2:
            // symptom add
            
            break;
            
        case 3:
            // browse
            [self pushToSearchToEat];
            break;
            
            
        case 4:
            // meal info add
            
            break;
            
        default:
            break;
    }
}


- (void) pushToSearchToEat
{
    EDSearchToEatViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchToEatVC"];
    
    searchVC.medicationFind = NO;
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

@end
