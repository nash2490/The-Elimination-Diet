//
//  EDData.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/11/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

// strings for the archiving
#define EDNameKey @"EDName"
#define EDMealsKey @"EDMeals"
#define EDEatenMealsKey @"EdEatenMeals"
#define EDContainedMealsKey @"EDContainedMeals"
#define EDIngredientsKey @"EDIngredients"
#define EDAdditionalIngredientsKey @"EDAdditionalIngredients"
#define EDIngredientTypesKey @"EDIngredientTypes"
#define EDRestaurantKey @"EDRestaurant"
#define EDRestaurantNameKey @"EDRestaurantName"
#define EDSymptomsKey @"EDSymptoms"
#define EDHadSymptomsKey @"EDHadSymptoms"
#define EDEliminatedIngredientsKey @"EDEliminatedIngredients"
#define EDEliminatedIngredientTypesKey @"EDEliminatedIngredientTypes"

#import <Foundation/Foundation.h>
#import "NSString+EatDate.h"

@class EDMeal;
@class EDIngredient;
@class EDRestaurant;
@class EDSymptom;
@class EDEliminatedFood;

@interface EDData : NSObject

@property (nonatomic, strong) NSDictionary *meals; // dictionary of EDMeal indexed by its name
@property (nonatomic, strong) NSDictionary *eatenMeals; // dictionary of array of edmal

@property (nonatomic, strong) NSDictionary *ingredients; // dictionary of EDIngredient indexed by its name
@property (nonatomic, strong) NSArray *ingredientTypes; // always alphabetical

@property (nonatomic, strong) NSDictionary *restaurants; // dictionary of EDRestaurant indexed by its name

@property (nonatomic, strong) NSSet *symptoms;
@property (nonatomic, strong) NSDictionary *hadSymptoms; //dictionary of array of EDSymptom

@property (nonatomic, strong) NSDictionary *eliminatedIngredientTypes; // string leads to EDEliminatedFood object with name
@property (nonatomic, strong) NSDictionary *eliminatedIngredients; // string leads to EDEliminatedFood object with name

+ (EDData *) eddata;

- (id)      initWithMeals: (NSDictionary *) meals
               eatenMeals: (NSDictionary *) eatenMeals
              ingredients: (NSDictionary *) ingredients
          ingredientTypes: (NSArray *) ingredientTypes // always alphabetical
              restaurants: (NSDictionary *) restaurants
                 symptoms: (NSSet *) symptoms
              hadSymptoms: (NSDictionary *) hadSymptoms
    eliminatedIngredients: (NSDictionary *) eliminatedIngredients
eliminatedIngredientTypes: (NSDictionary *) eliminatedIngredientTypes;

- (id) initWithDefaultData;


// General Methods ///////////////////////////////////////////
- (NSArray *) sortArrayOfString: (NSArray *) arrayOfString;

@end
