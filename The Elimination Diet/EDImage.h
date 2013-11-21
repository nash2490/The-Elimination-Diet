//
//  EDImage.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/13/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EDFood;

@interface EDImage : NSManagedObject

@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) EDFood *food;

@end
