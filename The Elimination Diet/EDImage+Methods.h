//
//  EDImage+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/14/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDImage.h"


#define IMAGE_ENTITY_NAME @"EDImage"


@interface EDImage (Methods)


#pragma mark - Creation methods
+ (EDImage *) createFromImage: (UIImage *) imageFile
                    inContext: (NSManagedObjectContext *) context;

+ (EDImage *) createFromImagePath:(NSString *)imagePath
                        inContext:(NSManagedObjectContext *)context;



#pragma mark - Saving and Loading UIImages

- (UIImage *) getImageFile;

+ (NSSet *) saveImages: (NSSet *) images;


@end
