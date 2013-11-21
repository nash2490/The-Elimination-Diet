//
//  EDData+Symptoms.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/10/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDData+Symptoms.h"
#import "EDData.m"

@implementation EDData (Symptoms)

// symptoms
////////////////////////////////////////////////

- (void) newSymptom: (EDSymptom *) aSymptom {
    if (self.symptoms == nil) {
        self.symptoms = [[NSSet alloc] initWithObjects:aSymptom, nil];
    }
    else {
        NSMutableSet *mutSymptoms = [self.symptoms mutableCopy];
        [mutSymptoms addObject:aSymptom];
        self.symptoms = [mutSymptoms copy];
    }
}

- (void) removeSymptom:(EDSymptom *)aSymptom {
    NSMutableSet *mutSymptoms = [self.symptoms mutableCopy];
    [mutSymptoms removeObject:aSymptom];
    self.symptoms = [mutSymptoms copy];
}

// hadSymptoms
////////////////////////////////////////////////

- (void) hadSymptom: (EDSymptom *) aSymptom atTime: (NSString *) time {
    if (self.hadSymptoms == nil) {
        self.hadSymptoms = [[NSDictionary alloc] initWithObjectsAndKeys:aSymptom, time, nil];
    }
    else {
        NSMutableDictionary *mutHadSymptoms = [self.hadSymptoms mutableCopy];
        [mutHadSymptoms setObject:aSymptom forKey:time];
        self.hadSymptoms = [mutHadSymptoms copy];
    }
}

- (void) removeHadSymptom:(EDSymptom *)aSymptom atTime:(NSString *)time {
    
    NSMutableDictionary *mutHadSymptoms = [self.hadSymptoms mutableCopy];
    NSMutableArray *symptomsAtTime = [mutHadSymptoms objectForKey:time];
    [mutHadSymptoms removeObjectForKey:time];
    [symptomsAtTime removeObject:aSymptom];
    [mutHadSymptoms setObject:[symptomsAtTime copy] forKey:time];
    self.eatenMeals = [mutHadSymptoms copy];
    
}



@end
