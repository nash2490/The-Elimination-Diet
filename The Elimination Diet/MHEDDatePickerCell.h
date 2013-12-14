//
//  MHEDDatePickerCell.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/10/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHEDDatePickerCellDelegate <NSObject>

- (void) dateActionForDatePicker:(UIDatePicker *) datePicker;

@end


@interface MHEDDatePickerCell : UITableViewCell

@property (nonatomic, weak) id <MHEDDatePickerCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIDatePicker *mhedDatePicker;
- (IBAction)datePickerValueChanged:(id)sender;

@end
