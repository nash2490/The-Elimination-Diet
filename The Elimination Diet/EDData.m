//
//  EDData.m
//  The Elimination Diet
//
//  Created by JuEDIn Kahn on 6/11/13.
//  Copyright (c) 2013 JuEDIn Kahn. All rights reserved.
//

#import "EDData.h"
#import "EDData+Meal.h"
#import "EDData+Ingredients.h"
#import "EDData+Restaurants.h"
#import "EDData+Symptoms.h"

#import "EDMeal.h"
#import "EDIngredient.h"
#import "EDRestaurant.h"
#import "EDSymptom.h"
#import "EDEliminatedFood.h"

@implementation EDData


- (NSDictionary *) meals {
    if (!_meals) {
        _meals = [[NSDictionary alloc] init];
    }
    return _meals;
}

- (NSDictionary *) eatenMeals {
    if (!_eatenMeals) {
        _eatenMeals = [[NSDictionary alloc] init];
    }
    return  _eatenMeals;
}

- (NSSet *) symptoms {
    if (!_symptoms) {
        _symptoms = [[NSSet alloc] init];
    }
    return _symptoms;
}

- (NSDictionary *) hadSymptoms {
    if (!_hadSymptoms) {
        _hadSymptoms = [[NSDictionary alloc] init];
    }
    return  _hadSymptoms;
}

- (NSDictionary *) ingredients {
    if (!_ingredients) {
        _ingredients = [[NSDictionary alloc] init];
    }
    return _ingredients;
}

- (NSArray *) ingredientTypes {
    if (!_ingredientTypes) {
        _ingredientTypes = [[NSArray alloc] init];
    }
    return _ingredientTypes;
}

- (NSDictionary *) restaurants {
    if (!_restaurants) {
        _restaurants = [[NSDictionary alloc] init];
    }
    return _restaurants;
}

- (NSDictionary *) eliminatedIngredients {
    if (!_eliminatedIngredients) {
        _eliminatedIngredients = [[NSDictionary alloc] init];
    }
    return _eliminatedIngredients;
}

- (NSDictionary *) eliminatedIngredientTypes {
    if (!_eliminatedIngredientTypes) {
        _eliminatedIngredientTypes = [[NSDictionary alloc] init];
    }
    return _eliminatedIngredientTypes;
}

+ (EDData *) eddata {
    
    static EDData *eddata = nil;
    
    @synchronized(self) {
        if (!eddata) {
            eddata = [[EDData alloc] init];
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
            
            if ([urls count]) {
                NSURL *documentsFolder = [urls objectAtIndex:0];
                NSString *filePath = [[documentsFolder path] stringByAppendingString:@"TheEliminationDietData.archive"];
                eddata = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
                if (!eddata) {
                    eddata = [[EDData alloc] initWithDefaultData];
                }
            }
        }
    }
    return eddata;
}


- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ingredients forKey:EDIngredientsKey];
    [aCoder encodeObject:self.ingredientTypes forKey:EDIngredientTypesKey];
    [aCoder encodeObject:self.meals forKey:EDMealsKey];
    [aCoder encodeObject:self.restaurants forKey:EDRestaurantNameKey];
    [aCoder encodeObject:self.eatenMeals forKey:EDEatenMealsKey];
    [aCoder encodeObject:self.symptoms forKey:EDSymptomsKey];
    [aCoder encodeObject:self.hadSymptoms forKey:EDHadSymptomsKey];
    
    [aCoder encodeObject:self.eliminatedIngredients forKey:EDEliminatedIngredientsKey];
    [aCoder encodeObject:self.eliminatedIngredientTypes forKey:EDEliminatedIngredientTypesKey];
}


- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _ingredients = [aDecoder decodeObjectForKey:EDIngredientsKey];
        _ingredientTypes = [aDecoder decodeObjectForKey:EDIngredientTypesKey];
        _meals = [aDecoder decodeObjectForKey:EDMealsKey];
        _restaurants = [aDecoder decodeObjectForKey:EDRestaurantNameKey];
        _eatenMeals = [aDecoder decodeObjectForKey:EDEatenMealsKey];
        _symptoms = [aDecoder decodeObjectForKey:EDSymptomsKey];
        _hadSymptoms = [aDecoder decodeObjectForKey:EDHadSymptomsKey];
        
        _eliminatedIngredients = [aDecoder decodeObjectForKey:EDEliminatedIngredientsKey];
        _eliminatedIngredientTypes = [aDecoder decodeObjectForKey:EDEliminatedIngredientTypesKey];
    }
    return self;
}


- (id)      initWithMeals: (NSDictionary *) meals
               eatenMeals: (NSDictionary *) eatenMeals
              ingredients: (NSDictionary *) ingredients
          ingredientTypes: (NSArray *) ingredientTypes // always alphabetical
              restaurants: (NSDictionary *) restaurants
                 symptoms: (NSSet *) symptoms
              hadSymptoms: (NSDictionary *) hadSymptoms
    eliminatedIngredients: (NSDictionary *) eliminatedIngredients
eliminatedIngredientTypes: (NSDictionary *) eliminatedIngredientTypes
{    
    self = [super init];
    
    if (self) {
        self.meals = meals;
        self.eatenMeals = eatenMeals;
        self.ingredients = ingredients;
        self.ingredientTypes = ingredientTypes;
        self.restaurants = restaurants;
        self.symptoms = symptoms;
        self.hadSymptoms = hadSymptoms;
        self.eliminatedIngredients = eliminatedIngredients;
        self.eliminatedIngredientTypes = eliminatedIngredientTypes;
    }
    
    return self;
}


- (id) initWithDefaultData
{
    NSArray *iTypes = @[@"Dairy", @"Soy", @"Tree Nuts", @"Gluten", @"Eggs", @"Fish", @"Shellfish", @"Poultry", @"Beef", @"Pork", @"Grains (gluten-free)", @"Fruit", @"Vegetables", @"Beans", @"Other"]; // Starches??
    iTypes = [self sortArrayOfString:iTypes];
    
    self = [self initWithMeals:nil
                    eatenMeals:nil
                   ingredients:[self makeDefaultDataIngredients]
               ingredientTypes:iTypes
                   restaurants:nil
                      symptoms:nil
                   hadSymptoms:nil
         eliminatedIngredients:nil
     eliminatedIngredientTypes:nil];
    
    return self;
}

- (NSDictionary *) makeDefaultDataIngredients
{
    NSMutableDictionary *defaultIngredients = [[NSMutableDictionary alloc] init];
    
    NSArray *iTypes = @[@"Dairy", @"Soy", @"Tree Nuts", @"Gluten", @"Eggs", @"Fish", @"Shellfish", @"Poultry", @"Beef", @"Pork", @"Grains (gluten-free)", @"Fruit", @"Vegetables", @"Beans", @"Other"]; // Starches??
    iTypes = [self sortArrayOfString:iTypes];
    
    NSArray *glutenIngrNames = @[@"Wheat", @"Rye", @"Barley", @"Spelt", @"Oats (gluten)"];
    NSArray *nutsIngrNames = @[@"Tree nuts", @"Almonds", @"Pecans", @"Brazil nuts", @"Cashews", @"Chestnuts", @"Hazelnuts", @"Macadamia", @"Pine nuts", @"Pistachios"];
    NSArray *dairyIngrNames = @[@"Milk", @"Cheese", @"Yogurt", @"Butter", @"Casein"];
    NSArray *soyIngrNames = @[@"Tofu", @"Soynuts", @"Soybeans", @"Soy milk"]; // soy milk??
    NSArray *eggsIngrNames = @[@"Eggs"];
    NSArray *fishIngrNames = @[@"Salmon", @"Tuna", @"Pollock", @"Eel", @"Snapper", @"Tilapia"];
    NSArray *shellfishIngrNames = @[@"Crab", @"Lobster", @"Crayfish", @"Shrimp", @"Prawn", @"Mussels", @"Oysters", @"Scallops", @"Clams"];
    NSArray *poultryIngrNames = @[@"Chicken", @"Duck", @"Turkey"];
    NSArray *beefIngrNames = @[@"Beef"]; /// What else?
    NSArray *porkIngrNames = @[@"Ham", @"Bacon", @"Pork"];
    NSArray *grainsIngrNames = @[@"Millet", @"Quinoa", @"Rice", @"Corn", @"Buckwheat", @"Oats (gluten-free)", @"Sorghum", @"Teff"];
    NSArray *fruitIngrNames = @[@"Apple", @"Grape", @"Lemon", @"Lime", @"Orange", @"Peach", @"Nectarine", @"Pear", @"Plum", @"Strawberry", @"Cherry", @"Rasberry", @"Blackberry", @"Blueberry", @"Melon", @"Watermelon", @"Avacado"]; // Tomato
    NSArray *vegetablesIngrNames = @[@"Potato", @"Celery", @"Carrots", @"Parsley", @"Peppers", @"Caraway", @"Coriander", @"Squash", @"Broccoli", @"Asparagus", @"Cucumber", @"Eggplant", @"Mushrooms", @"Onions", @"Spinach", @"Sweet Potatoes"];
    NSArray *beansIngrNames = @[@"Peanut", @"Black beans", @"Kidney beans", @"Lima beans", @"Mung beans", @"Navy beans", @"Pinto beans", @"String beans"];
    NSArray *otherIngrNames = @[@"Tapioca", @"Xanthan gum", @"Guar gum"];
    
    for (NSString *typeName in iTypes) {
        NSArray *ingrNames = [[NSArray alloc] init];
        
        if ([typeName isEqualToString:@"Dairy"]) {
            ingrNames = dairyIngrNames;
        }
        else if ([typeName isEqualToString:@"Soy"]) {
            ingrNames = soyIngrNames;
        }
        else if ([typeName isEqualToString:@"Tree Nuts"]) {
            ingrNames = nutsIngrNames;
        }
        else if ([typeName isEqualToString:@"Gluten"]) {
            ingrNames = glutenIngrNames;
        }
        else if ([typeName isEqualToString:@"Eggs"]) {
            ingrNames = eggsIngrNames;
        }
        else if ([typeName isEqualToString:@"Fish"]) {
            ingrNames = fishIngrNames;
        }
        else if ([typeName isEqualToString:@"Crustaceans & Shellfish"]) {
            ingrNames = shellfishIngrNames;
        }
        else if ([typeName isEqualToString:@"Poultry"]) {
            ingrNames = poultryIngrNames;
        }
        else if ([typeName isEqualToString:@"Beef"]) {
            ingrNames = beefIngrNames;
        }
        else if ([typeName isEqualToString:@"Pork"]) {
            ingrNames = porkIngrNames;
        }
        else if ([typeName isEqualToString:@"Grains (gluten-free)"]) {
            ingrNames = grainsIngrNames;
        }
        else if ([typeName isEqualToString:@"Fruit"]) {
            ingrNames = fruitIngrNames;
        }
        else if ([typeName isEqualToString:@"Vegetables"]) {
            ingrNames = vegetablesIngrNames;
        }
        else if ([typeName isEqualToString:@"Beans (non-soy)"]) {
            ingrNames = beansIngrNames;
        }
        else if ([typeName isEqualToString:@"Other"]) {
            ingrNames = otherIngrNames;
        }
        
        for (NSString *ingrName in ingrNames) {
            EDIngredient *ingr = [[EDIngredient alloc] initWithName:ingrName
                                               containedIngredients:[[NSSet alloc] init]
                                                           andTypes:[NSSet setWithObject:typeName]];
            
            [defaultIngredients setObject:ingr forKey:ingrName];
        }
    }
    return [defaultIngredients copy];
}




// General Methods
///////////////////////////////////////////////////////

- (NSArray *) sortArrayOfString: (NSArray *) arrayOfString
{
    return [arrayOfString sortedArrayUsingComparator:
            ^(id obj1, id obj2) {
                return [obj1 caseInsensitiveCompare:obj2];
            }];
}



@end
