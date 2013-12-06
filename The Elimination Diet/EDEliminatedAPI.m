//
//  EDEliminatedAPI.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/21/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedAPI.h"

#import "EDEliminatedAPI+Fetching.h"
#import "EDEliminatedAPI+Helpers.h"
#include "EDEliminatedAPI+Searching.h"
#import "EDEliminatedAPI+Sorting.h"


#import "EDDocumentHandler.h"

#import "EDTag+Methods.h"
#import "EDEvent+Methods.h"

#import "EDLocation+Methods.h"

#import "EDMeal+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDFood+Methods.h"
#import "EDRestaurant+Methods.h"
#import "EDType+Methods.h"
#import "EDEatenMeal+Methods.h"
#import "EDEliminatedFood+Methods.h"

#import "NSError+MHED_MultipleErrors.h"
#import "NSSet+MHED_MoreSetOperations.h"
#import "NSString+EatDate.h"
#import "UIView+EDAdjustView.h"
#import "NSArray+MHEDMethods.h"

@import CoreData;

@implementation EDEliminatedAPI

#pragma mark - Custom Core Data API

+ (void) performBlockWithContext:(OnContextReady)onContextReady
{
    [[EDDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
        onContextReady(document.managedObjectContext);
    }];
}



#pragma mark - File operations

+(NSURL *) getURLForImageFolder
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSError *error = nil;
    
    NSURL* suppurl = [fm URLForDirectory:NSApplicationSupportDirectory
                                inDomain:NSUserDomainMask appropriateForURL:nil
                                  create:YES error:&error];
    
    NSURL* myfolderURL = [suppurl URLByAppendingPathComponent:@"TakenPictures"];
    
    BOOL ok = [fm createDirectoryAtURL:myfolderURL
           withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (ok) {
        return myfolderURL;
    }
    
    return nil;
}

@end
