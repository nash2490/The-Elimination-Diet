//
//  EDMealAndMedicationSegmentedControlCell.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/8/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EDMealAndMedicationSegmentedControlDelegate <NSObject>

- (void) handleMealAndMedicationSegmentedControl: (id) sender;

@end

@interface EDMealAndMedicationSegmentedControlCell : UITableViewCell

@property (nonatomic, weak) id <EDMealAndMedicationSegmentedControlDelegate> delegate;

@property (nonatomic, weak) IBOutlet UISegmentedControl *segControl;

- (IBAction)segControlChanged:(id)sender;


@end
