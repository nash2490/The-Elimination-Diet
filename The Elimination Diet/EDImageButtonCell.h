//
//  EDImageButtonCell.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/5/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EDImageButtonCellDelegate <NSObject>

- (void) handleDeletePictureButton: (id) sender;

@optional
- (void) handleTakeAnotherPictureButton: (id) sender;
@end


@interface EDImageButtonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *takeAnotherPictureButton;
@property (weak, nonatomic) IBOutlet UIButton *retakePictureButton;
@property (weak, nonatomic) IBOutlet UIButton *deletePictureButton;

@property (nonatomic, weak) id <EDImageButtonCellDelegate> delegate;

- (IBAction)handleTakeAnotherPictureButton:(id)sender;


@end
