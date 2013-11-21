//
//  EDDocumentHandler.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/1/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OnDocumentReady) (UIManagedDocument *document);

@interface EDDocumentHandler : NSObject


@property (strong, nonatomic) UIManagedDocument *document;

+ (EDDocumentHandler *)sharedDocumentHandler;
- (void)performWithDocument:(OnDocumentReady)onDocumentReady;


/*  // code to be used in view controllers that access the document - supposedly in viewWillAppear
 
if (!self.document) {
    [[MYDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
        self.document = document;
        // Do stuff with the document, set up a fetched results controller, whatever.
    }];
}
 
*/


@end

