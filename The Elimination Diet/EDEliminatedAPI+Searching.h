//
//  EDEliminatedAPI+Searching.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/25/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedAPI.h"

typedef NS_ENUM(NSUInteger, MHEDSearchBarScopeType) {MHEDSearchBarScopeFoodAll, MHEDSearchBarScopeFoodMeals, MHEDSearchBarScopeFoodIngredients, MHEDSearchBarScopeFoodTypes, MHEDSearchBarScopeRestaurants, MHEDSearchBarScopeTags, MHEDSearchBarScopeFoodMedication, MHEDSearchBarScopeFoodNonMedication, MHEDSearchBarScopeSymptomsAll};

@interface EDEliminatedAPI (Searching)


#pragma mark - Search Fetches

/// search through name and tags
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
                               forSearchString:(NSString *)text;

/// search only through names for the given text
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName nameContainingText:(NSString *)text;


#pragma mark - Perform Searches

// basic searching

// returns a few possible results for the given string in the given scope
+ (NSArray *) searchResultsForString: (NSString *) text inScope: (MHEDSearchBarScopeType) scope;

//// returns a few possible results for the given string in the given scope
//+ (NSArray *) searchResultsExcludingFavoritesForString: (NSString *) text inScope: (SearchBarScope) scope ;

@end
