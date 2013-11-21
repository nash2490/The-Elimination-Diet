//
//  EDImageAndNameCell.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/8/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDImageAndNameCell.h"

@implementation EDImageAndNameCell

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.nameTextView.delegate = self;
    self.nameTextView.textColor = [UIColor grayColor];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        
        [self.delegate textEnter:textView];
        
        return NO;
    }
    
    return YES;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.nameTextView.delegate = self;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    return [self.delegate textViewShouldBeginEditing];
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    
    if (self.nameTextView == textView) {
        if ([self.delegate textViewShouldClear]) {
            self.nameTextView.text = @"";
            self.nameTextView.textColor = [UIColor blackColor];
        }
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    if (self.nameTextView == textView) {
        if ([self.nameTextView.text isEqualToString:@""]) {
            self.nameTextView.textColor = [UIColor grayColor];
        }
    }
}

- (BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}


- (BOOL) loadImageView
{
    UIImage *image = [self.delegate imageForThumbnail];
    
    if (image) {
        CGRect rect = self.foodImageView.bounds;
        
        UIGraphicsBeginImageContext(rect.size);
        [image drawInRect:rect];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.foodImageView.image = img;
        
        if (self.foodImageView.image) {
            
            [self.foodImageView setNeedsDisplay];
            
            return YES;
        }
    }

    return NO;
}

@end
