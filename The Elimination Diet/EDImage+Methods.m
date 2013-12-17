//
//  EDImage+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/14/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDImage+Methods.h"

#import "EDEliminatedAPI.h"

@implementation EDImage (Methods)


#pragma mark - Creation methods
+ (EDImage *) createFromImage: (UIImage *) imageFile
                    inContext: (NSManagedObjectContext *) context
{
    if (context && imageFile) {
        
        NSString *imagePath = [[EDImage saveImages:[NSSet setWithObject:imageFile]] anyObject];
        
        if (imagePath) {
            EDImage *newEDImage = [NSEntityDescription insertNewObjectForEntityForName:IMAGE_ENTITY_NAME inManagedObjectContext:context];
            
            newEDImage.imagePath = imagePath;
            
            return newEDImage;
        }
    }
    
    return nil;
}

+ (EDImage *) createFromImagePath:(NSString *)imagePath
                        inContext:(NSManagedObjectContext *)context
{
    if (context && imagePath) {
        
        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:IMAGE_ENTITY_NAME];
        fetch.predicate = [NSPredicate predicateWithFormat:@"(imagePath BEGINSWITH %@) OR (imagePath ENDSWITH %@)", imagePath, imagePath];
        fetch.fetchLimit = 2;
        NSError *error;
        
        NSArray *imagesWithPath = [context executeFetchRequest:fetch error:&error];
        
        
        if ([imagesWithPath count]) { // there may be more than one douplicate, but that really doesn't conern us
            return imagesWithPath[0];
        }
        
        else {
            EDImage *newEDImage = [NSEntityDescription insertNewObjectForEntityForName:IMAGE_ENTITY_NAME inManagedObjectContext:context];
            
            newEDImage.imagePath = imagePath;
            
            return newEDImage;
        }
    }
    
    return nil;
}




#pragma mark - Saving and Loading UIImages




- (UIImage *) getImageFile
{
    if (self.imagePath) {
        UIImage *image = [UIImage imageWithContentsOfFile:self.imagePath];
        
        if (image) {
            return image;
        }
    }
    return nil;
}



+ (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
    
    
}




+ (NSString *) uniqueFileNameWithPrefix: (NSString *) prefixString
{
    NSString *uuidString = [[NSUUID UUID] UUIDString];
    
    NSString *uniqueFileName = [NSString stringWithFormat:@"%@-%@", prefixString, uuidString];
    
    NSLog(@"uniqueFileName: '%@'", uniqueFileName);
    
    return uniqueFileName;
}

/*!    Saves the given images to the documents folder using a unique file name
 @param images set of UIImages
 @return returns NSSet of NSString paths the images were saved to
 */
+ (NSSet *) saveImages: (NSSet *) images
{
    
    NSMutableSet *mutPathSet = [NSMutableSet set];
    
    for (UIImage *img in images) {
        
        // for each image we create a unique filename
        NSString *uniqueId = [EDImage uniqueFileNameWithPrefix:@"Image"];
        
        // create a path string using the filename
        NSURL *imageFolderURL = [EDEliminatedAPI getURLForImageFolder];
        
        NSURL *newImageURL = [imageFolderURL URLByAppendingPathComponent:uniqueId];
        
        // save the image to the disk - if sucessful then add path string to mutPathSet
        if (img) {
            NSData* data = UIImagePNGRepresentation(img);
            BOOL saved = [data writeToURL:newImageURL atomically:YES];
            
            if (saved) {
                [mutPathSet addObject:[newImageURL path]];
            }
        }
       
        
    }
    
    return [mutPathSet copy];
}

@end
