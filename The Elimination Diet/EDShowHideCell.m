//
//  EDShowHideCell.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/12/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDShowHideCell.h"

@implementation EDShowHideCell

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


- (void) updateShowHide
{
    if (self.cellHidden) {
        self.showHideButton.titleLabel.text = @"Hide";
    }
    else {
        self.showHideButton.titleLabel.text = @"Show";

    }
}

- (IBAction)handleShowHideButtonPress:(id)sender {
    
    [self.delegate handleShowHideButtonPress:self];
    
}

@end
