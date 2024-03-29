//
//  EDLocation.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/14/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EDRestaurant;

@interface EDLocation : NSManagedObject

@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) EDRestaurant *restaurant;

@end
