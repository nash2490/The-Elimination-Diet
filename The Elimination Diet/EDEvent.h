//
//  EDEvent.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/6/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EDEvent : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * uniqueID;

@end
