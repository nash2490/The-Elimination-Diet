//
//  MHEDDatePickerCell.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/10/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDDatePickerCell.h"

@implementation MHEDDatePickerCell

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

- (IBAction)datePickerValueChanged:(id)sender {
    [self.delegate dateActionForDatePicker:self.mhedDatePicker];
}
@end
