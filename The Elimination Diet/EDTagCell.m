//
//  EDTagCell.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/8/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDTagCell.h"

@implementation EDTagCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //self.tagsTextView.attributedText = [self.dataSource tagsString];
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.tagsTextView.delegate = self;
}

- (void) prepareForReuse
{
    [super prepareForReuse];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (textView == self.tagsTextView) {
        //
        [self.delegate textView:textView didSelectRange:textView.selectedRange];
    }
}

@end
