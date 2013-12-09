//
//  EDImageButtonCell.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/5/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDImageButtonCell.h"

@implementation EDImageButtonCell

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

- (IBAction)handleTakeAnotherPictureButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleTakeAnotherPictureButton:)]) {
        [self.delegate handleTakeAnotherPictureButton:sender];
    }
}
@end
