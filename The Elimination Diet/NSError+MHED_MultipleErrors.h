//
//  NSError+MHED_MultipleErrors.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/26/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (MHED_MultipleErrors)

+ (NSError *)errorFromOriginalError:(NSError *)originalError error:(NSError *)secondError;

@end
