//
//  UIImage+MHED_fixOrientation.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/12/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MHED_fixOrientation)

- (UIImage *)fixOrientation;

+ (UIImage *) newImageFrom: (UIImage *) image toFitHeight: (double) fitHeight;

+ (UIImage *) newImageFrom: (UIImage *) image toFitWidth: (double) fitWidth;

+ (UIImage *) newImageFrom:(UIImage *)image scaledToFitHeight:(double)fitHeight andWidth: (double) fitWidth;

- (UIImage *)scaleImageToSize:(CGSize)newSize;


@end
