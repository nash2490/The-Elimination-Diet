//
//  EDEliminatedAPI+Sorting.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/25/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedAPI.h"

@interface EDEliminatedAPI (Sorting)

+ (NSSortDescriptor *) nameSortDescriptor;

+ (NSSortDescriptor *) sortDescriptorForProperty: (NSString *) property  caseInsensitive: (BOOL) caseInsensitive;

/// obj must be KVC compliant and have @property NSString name
+ (NSString *) nameFirstLetter:(id) obj;

@end
