//
//  EDMealAndMedicationSegmentedControlCell.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/8/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDMealAndMedicationSegmentedControlCell.h"

@implementation EDMealAndMedicationSegmentedControlCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)segControlChanged:(id)sender {
    
    [self.delegate handleMealAndMedicationSegmentedControl:sender];
    
}
@end
