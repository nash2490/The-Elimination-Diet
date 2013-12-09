//
//  EDImageAndNameCell.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/8/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EDImageAndNameDelegate <NSObject>

- (NSString *) defaultTextForNameTextView;
- (BOOL) textViewShouldClear;
- (void) setNameAs: (NSString *) newName;
- (BOOL) textViewShouldBeginEditing;
- (void) textEnter: (UITextView *) textView;

@optional
- (UIImage *) imageForThumbnail;

@end

@interface EDImageAndNameCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, weak) id <EDImageAndNameDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIImageView *foodImageView;
@property (nonatomic, weak) IBOutlet UITextView *nameTextView;

- (BOOL) loadImageView;


@end
