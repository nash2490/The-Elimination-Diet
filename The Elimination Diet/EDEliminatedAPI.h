//
//  EDEliminatedAPI.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/21/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

@import Foundation;

@class NSManagedObjectContext;


typedef void (^OnContextReady) (NSManagedObjectContext *context);



@interface EDEliminatedAPI : NSObject

#pragma mark - Custom Core Data API

// generic block to perform using context
+ (void) performBlockWithContext: (OnContextReady) onContextReady;

// NEED METHODS THAT ARE BASICALLY WRAPPERS FOR WORKING WITH OBJECTS - TO SAVE AND EDIT WITHOUT HAVING TO ALWAYS ..

#pragma mark - File operations
+ (NSURL *) getURLForImageFolder;


@end
