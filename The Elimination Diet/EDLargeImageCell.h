//
//  EDLargeImageCell.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/5/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iCarousel.h"

#import "EDImageButtonCell.h"


@interface EDLargeImageCell : UITableViewCell


@property (weak, nonatomic) IBOutlet iCarousel *mhedCarousel;

@property (weak, nonatomic) IBOutlet UIButton *takeAnotherPictureButton;
@property (weak, nonatomic) IBOutlet UIButton *deletePictureButton;

@property (nonatomic, weak) id <EDImageButtonCellDelegate> delegate;

- (IBAction)handleTakeAnotherPictureButton:(id)sender;
- (IBAction)handleDeletePictureButton:(id)sender;

@end
