//
//  EDData+Symptoms.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/10/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDData.h"

@interface EDData (Symptoms)

// Symptoms ////////////////////////////////////////////////
- (void) newSymptom: (EDSymptom *) aSymptom;
- (void) removeSymptom: (EDSymptom *) aSymptom;

- (void) hadSymptom: (EDSymptom *) aSymptom atTime: (NSString *) time;
- (void) removeHadSymptom: (EDSymptom *) aSymptom atTime: (NSString *) time;


@end
