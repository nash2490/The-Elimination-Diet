//
//  EDMedication+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/23/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//



/*
 - A EDMedication
 
 - ingredientsAdded -- i
 
 - ingredientsSecondary --
 
 - medicationParents -- medications contained in this medications
 
 - medicationChildren -- medication that contain this one
 
 - ifEliminated -- a pointer to an instance of EDEliminatedIngredient or nil if this ingredient is not, or has never been, eliminated
 
 - tags -- set of tags for this medication
 
 - context -- the context through which we add the EDMedication to the database
 
 
 Validation 
    - name is unique
    - medicationChild doesn't cause cycle
    - company/restaurant is company 
 */

#import "EDMedication.h"

@class EDEatenMeal, EDIngredient, EDMeal, EDRestaurant, EDType, EDTakenMedication;


#define MEDICATION_ENTITY_NAME @"EDMedication"




@interface EDMedication (Methods)

#pragma mark - Creation Methods
// to create in app, have the user supply the info fit for a creation method
// and then just ask if the user wants to give more info
//          - children

// universal method -

+ (EDMedication *) createMedicationWithName:(NSString *)name
                           ingredientsAdded:(NSSet *)added
                          medicationParents:(NSSet *)medParents
                                    company:(EDRestaurant *)company
                                       tags:(NSSet *)tags
                                 forContext:(NSManagedObjectContext *)context;

+ (void) setUpDefaultMedicationInContext:(NSManagedObjectContext *) context;


#pragma mark - Property getter and setter methods
- (NSSet *) medicationParents;
- (void) setMedicationParents: (NSSet *) values;
- (void) addMedicationParents:(NSSet *) values;
- (void) removeMedicationParents:(NSSet *) values;
- (void) addMedicationParentObject: (EDMedication *) value;
- (void) removeMedicationParentObject: (EDMedication *) value;

- (NSSet *) medicationChildren;
- (void) setMedicationChildren: (NSSet *) values;
- (void) addMedicationChildren: (NSSet *) values;
- (void) removeMedicationChildren: (NSSet *) values;
- (void) addMedicationChildObject: (EDMedication *) value;
- (void) removeMedicationChildObject: (EDMedication *) value;

- (NSSet *) timesTaken;
- (void) setTimesTaken: (NSSet *) values;
- (void) addTimesTaken: (NSSet *) values;
- (void) removeTimesTaken: (NSSet *) values;
- (void) addTimeTaken:(EDTakenMedication *) value;
- (void) removeTimeTaken: (EDTakenMedication *)  value;

#pragma mark - property helper methods

- (NSSet *) descendants;
- (NSSet *) ancestors;

- (NSSet *) addedIngredientAncestors;

#pragma mark - Getting transient properties

- (NSSet *) determineTypes;
- (NSSet *) determineIngredientsSecondary;


#pragma mark - Elimination Methods

// determines if the medication contains something that is eliminated
//      - an added ingredient
//      - a parent med
- (BOOL) isCurrentlyEliminated;


#pragma mark - Fetching

+ (NSFetchRequest *) fetchAllMedication;

/// gets meds that have the favorite tag
+ (NSFetchRequest *) fetchFavoriteMedication;

@end
