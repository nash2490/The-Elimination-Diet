//
//  EDType+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 7/30/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//
/*
 
 Definition
 -----------
 - a fundamental category of food that groups together many ingredients, but does not overlap with other types
 
 
 - group of food category
        - mostly based on allergies and digestive disorders
 - fundamental building blocks of food
 - does not have a singular instance
        - oregano is an 'herb'
 - is not used as an ingredient
        - exception is gluten

 Explanation
 - You don't really need to add anything, but if you feel like something is missing then operate by the principle that if it can be broken down into something you also want as a type, then it shouldn't be a type, but its components should be
 
 - A EDType is basically just the name, e.g. gluten. The other properties are just the connections that are made from other objects, so they appear here from inverse relationships. So the main measure of equality is name equality.

 - primary ingredients -- ingredients that directly contains this type (as a primary type)
                       -- ingredients that are instances of this type 

 - secondary ingredients -- ingredients that contains the type but only by containing an ingredient that has it as either primary or secondary type. This is almost never set directly, it is set through a method that determines the list of secondary ingredients

 - meals -- the meals that contain the primary and/or secondary ingredients that have this type
 
 - ifEliminated -- a pointer to an instance of EDEliminatedType or nil if this type is not, or has never been, eliminated
 
 - tags -- set of tags for this type

 - context -- the context through which we add the EDType to the database
*/

#import "EDType.h"

#define TYPE_ENTITY_NAME @"EDType"

@interface EDType (Methods)

#pragma mark - Initializers
// RETURN AN EXISTING OBJECT IF ONE OF SAME NAME EXISTS


/// Complex type creation method -
///      - adds primary ingred, but needs to generate secondary and meals
///      - asks for tags or sets to empty set
+ (EDType *) createTypeWithName:(NSString *) name
             primaryIngredients:(NSSet *) primaryIngred
                           tags:(NSSet *)tags
                     forContext:(NSManagedObjectContext *) context;


/// Default type creation method for a new type-
///      - makes empty sets for relationships
///      - asks for tags or sets to empty set
+ (EDType *) createTypeWithName:(NSString *)name
                           tags:(NSSet *)tags
                     forContext:(NSManagedObjectContext *)context;


+ (void) setUpDefaultIngredientTypesWithContext: (NSManagedObjectContext *) context;


#pragma mark - Elimination Methods



#pragma mark - Fetching

+ (NSFetchRequest *) fetchAllTypes;

/// find the EDType with this uniqueID
+ (EDType *) typeForUniqueID:(NSString *) uniqueID
                  forContext:(NSManagedObjectContext *) context;

/// find the EDType with the given value for the property associated with key path
+ (EDType *) typeForValue:(id) value
                ofKeyPath:(NSString *) path
               forContext:(NSManagedObjectContext *) context;

- (NSFetchRequest *) fetchMealsWithType;


#pragma mark - Getting transient properties

// ingredients secondary
- (NSSet *) determineIngredientsSecondary;

- (NSSet *) determineMeals;


#pragma mark - Modify properties

- (void) clearValueAtKeyPath: (NSString *) path;
// make specific methods if we actually end up using

@end
