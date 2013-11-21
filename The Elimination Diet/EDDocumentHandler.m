//
//  EDDocumentHandler.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/1/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDDocumentHandler.h"

@interface EDDocumentHandler ()
- (void)objectsDidChange:(NSNotification *)notification;
- (void)contextDidSave:(NSNotification *)notification;
@end;

@implementation EDDocumentHandler


static EDDocumentHandler *_sharedInstance;

+ (EDDocumentHandler *)sharedDocumentHandler
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Diet_Database.md"];
        
        self.document = [[UIManagedDocument alloc] initWithFileURL:url];
        
        // Set our document up for automatic migrations
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                                 NSInferMappingModelAutomaticallyOption: @YES};
        self.document.persistentStoreOptions = options;
        
        // Register for notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(objectsDidChange:)
                                                     name:NSManagedObjectContextObjectsDidChangeNotification
                                                   object:self.document.managedObjectContext];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:self.document.managedObjectContext];
    }
    return self;
}

- (void)performWithDocument:(OnDocumentReady)onDocumentReady
{
    void (^OnDocumentDidLoad)(BOOL) = ^(BOOL success) {
        if (success) {
            onDocumentReady(self.document);
        }
        else {
            // handle error
            NSLog(@"error bitch");
        }
    };
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]) {
        [self.document saveToURL:self.document.fileURL
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:OnDocumentDidLoad];
    }
    else if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:OnDocumentDidLoad];
    }
    else if (self.document.documentState == UIDocumentStateNormal) {
        OnDocumentDidLoad(YES);
        NSLog(@"doc did load");
    }
    else {
        NSLog(@"Doc state = %d", self.document.documentState);
    }
}

- (void)objectsDidChange:(NSNotification *)notification
{
#ifdef DEBUG
    NSLog(@"NSManagedObjects did change.");
    NSLog(@"there are %i", [[self.document.managedObjectContext registeredObjects] count]);
#endif
}

- (void)contextDidSave:(NSNotification *)notification
{
#ifdef DEBUG
    NSLog(@"NSManagedContext did save.");
    NSLog(@"there are %i", [[self.document.managedObjectContext registeredObjects] count]);

#endif
}



@end
