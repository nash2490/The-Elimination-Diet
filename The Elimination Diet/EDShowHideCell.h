//
//  EDShowHideCell.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/12/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EDShowHideCellDelegate <NSObject>

- (void) handleShowHideButtonPress:(id) sender;

@end


@interface EDShowHideCell : UITableViewCell

@property (nonatomic) BOOL cellHidden;
@property (nonatomic) id <EDShowHideCellDelegate> delegate;

// change button to have image later
@property (weak, nonatomic) IBOutlet UIButton *showHideButton;

- (void) updateShowHide;

- (IBAction)handleShowHideButtonPress:(id)sender;

@end
