//
//  EDStatusViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/18/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDStatusViewController.h"

#import "EDEliminatedAPI.h"

#import "EDEliminatedFood+Methods.h"
#import "EDDocumentHandler.h"



#define ACTION_TABLE_CELL_ID @"Action Table Cell ID"


@interface EDStatusViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchRequest *fetchRequestCurrentElimFood;
@property (nonatomic, strong) NSFetchRequest *fetchRequestSymptomFree;




@property (weak, nonatomic) IBOutlet UIView *edStatusView;
@property (weak, nonatomic) IBOutlet UITableView *edActionsTableView;

@property (nonatomic, strong) UIImage *quickCaptureImage;

@property (nonatomic,strong) UIImage *barcodeImage;

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
    NSLog(@"Table View is good ? = %d", (self.edActionsTableView != nil));
	// Do any additional setup after loading the view.
    
    self.fetchRequestCurrentElimFood = [self defaultFetchRequestCurrentElimFood];
    self.fetchRequestSymptomFree = [self defaultFetchRequestSymptomFree];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) {
        
        [[EDDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            
            [self setManagedObjectContext:document.managedObjectContext];
            
            //[EDMeal setUpDefaultMealsInContext:self.managedObjectContext];
            
            //[EDEatenMeal setUpDefaultEatenMealsWithContext:document.managedObjectContext];
            [EDEliminatedFood setUpDefaultEliminatedFoodsInContext:document.managedObjectContext];
            
            //[EDMedication setUpDefaultMedicationInContext:document.managedObjectContext];
            
            [self performFetch];
        }
         ];
    }
    
    else if (self.managedObjectContext) {
        
        [self performFetch];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
        
        case 1:
            cell.textLabel.text = @"Quick Capture";
            if (self.quickCaptureImage) {
                cell.imageView.image = self.quickCaptureImage;
            }
            
            break;
            
        case 2:
            cell.textLabel.text = @"Barcode Scanner";
            if (self.barcodeImage) {
                cell.imageView.image = self.barcodeImage;
            }
            
            break;
            
            
        case 3:
            cell.textLabel.text = @"Symptom";
            if (self.symptomImage) {
                cell.imageView.image = self.symptomImage;
            }
            
            break;
            
        case 4:
            cell.textLabel.text = @"Browse";
            if (self.browseImage) {
                cell.imageView.image = self.browseImage;
            }
            
            break;
            
            
        case 5:
            cell.textLabel.text = @"Enter Meal Details";
            if (self.mealDetailsImage) {
                cell.imageView.image = self.mealDetailsImage;
            }
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNumber = indexPath.row;
    
    switch (rowNumber) {
            
        case 1:
            // quick capture
            
            break;
            
        case 2:
            // barcode
            
            break;
            
            
        case 3:
            // symptom add
            
            break;
            
        case 4:
            // browse
            
            break;
            
            
        case 5:
            // meal info add
            
            break;
            
        default:
            break;
    }
}


@end
