//
//  EDHadSymptom.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/21/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EDEvent.h"

@class EDSymptom;

@interface EDHadSymptom : EDEvent

@property (nonatomic, retain) EDSymptom *symptom;

@end
