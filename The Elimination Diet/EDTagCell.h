//
//  EDTagCell.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/8/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EDTagCellDelegate <NSObject>

/// What to do when you select the range
///     - change to select the appropriate word
///     - allow user to remove word
- (void) textView:(UITextView *) textView didSelectRange: (NSRange) range;

///- (UIImage *) favoriteStarImage;

@end



@protocol EDTagCellDataSource <NSObject>

/// the string to display
///     - words hightlighted to show tag separation
///     - comma delimited
///     - remove favorite
- (NSAttributedString *) tagsString;

/// returns whether it has the favorite tag
//- (BOOL) favorite;


/// if we type in a string and end with a comma then we add the tag to the list (either creating a new one or just gettting the existing)
//- (void) enterInTagString: (NSString *) tagName;

///

@end



@interface EDTagCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, weak) id <EDTagCellDelegate> delegate;
@property (nonatomic, weak) id <EDTagCellDataSource> dataSource;

@property (nonatomic, weak) IBOutlet UIImageView *starImageView;
@property (nonatomic, weak) IBOutlet UITextView *tagsTextView;

@end
