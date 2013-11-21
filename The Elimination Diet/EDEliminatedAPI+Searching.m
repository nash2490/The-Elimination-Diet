//
//  EDEliminatedAPI+Searching.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/25/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedAPI+Searching.h"

#import "EDFood+Methods.h"
#import "EDMeal+Methods.h"
#import "EDIngredient+Methods.h"
#import "EDType+Methods.h"
#import "EDRestaurant+Methods.h"
#import "EDTag+Methods.h"

#import "EDMedication+Methods.h"

@implementation EDEliminatedAPI (Searching)

#pragma mark - Search Fetches

// search through name and tags
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
                               forSearchString:(NSString *)text
{
    
    
    NSFetchRequest *fetchObjects = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    NSPredicate *nameSearchPred = [NSPredicate predicateWithFormat:@"name contains[cd] %@", text];
    NSPredicate *tagSearchPred = [NSPredicate predicateWithFormat:@"ANY tags.name contains[cd] %@", text];
    
    fetchObjects.predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[nameSearchPred, tagSearchPred]];
    
    fetchObjects.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    return fetchObjects;
    
}

// only searches through the names
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
                            nameContainingText:(NSString *)text
{
    NSPredicate *namePred = [NSPredicate predicateWithFormat:@"name contains[cd] %@", text];
    
    NSFetchRequest *fetchObjects = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    fetchObjects.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[namePred]];
    
    fetchObjects.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    return fetchObjects;
}


#pragma mark - Perform Searches

+ (double) searchPercentageForString: (NSString *) original withSearchString: (NSString *) searchString
{
    if ([original rangeOfString:searchString].length) {
        return (double)[searchString length]/(double)[original length];
    }
    
    return 0;
}


+ (NSArray *) searchResultsForString:(NSString *)text inScope:(SearchBarScope)scope;
{
    __block NSArray *fetchResults = [[NSArray alloc] init];
    
    if (text && ![text isEqualToString:@""]) {
        
        [EDEliminatedAPI performBlockWithContext:^(NSManagedObjectContext *context) {
            
            NSFetchRequest *searchFetch;
            
            if (scope == SearchScopeAll)
            {
                searchFetch = [EDFood fetchObjectsForEntityName:FOOD_ENTITY_NAME forSearchString:text];
            }
            
            else if (scope == SearchScopeMeals)
            {
                searchFetch = [EDMeal fetchObjectsForEntityName:MEAL_ENTITY_NAME forSearchString:text];

            }
            
            else if (scope == SearchScopeIngredients)
            {
                searchFetch = [EDIngredient fetchObjectsForEntityName:INGREDIENT_ENTITY_NAME forSearchString:text];
            }
            
            else if (scope == SearchScopeTypes)
            {
                searchFetch = [EDType fetchObjectsForEntityName:TYPE_ENTITY_NAME forSearchString:text];
                
            }
            
            else if (scope == SearchScopeRestaurants)
            {
                searchFetch = [EDRestaurant fetchObjectsForEntityName:RESTAURANT_ENTITY_NAME forSearchString:text];
                
            }
            
            else if (scope == SearchScopeTags)
            {
                searchFetch = [EDEliminatedAPI fetchObjectsForEntityName:TAG_ENTITY_NAME nameContainingText:text];
            }
            
            else if (scope == SearchScopeMedication)
            {
                // nothing just yet
                
                // search through the food for objects that have tag @"medication" and also have the search string
                
                searchFetch = [EDEliminatedAPI fetchObjectsForEntityName:MEDICATION_ENTITY_NAME forSearchString:text];
            }
            
            fetchResults = [context executeFetchRequest:searchFetch error:nil];
        }];
        
        
        
    }
    
    return [NSArray arrayWithArray:fetchResults];
    
}

//+ (NSArray *) searchResultsExcludingFavoritesForString:(NSString *)text inScope:(SearchBarScope)scope
//{
//    __block NSArray *fetchResults = [[NSArray alloc] init];
//    
//    if (text && ![text isEqualToString:@""]) {
//        
//        [EDEliminatedAPI performBlockWithContext:^(NSManagedObjectContext *context) {
//            
//            NSFetchRequest *searchFetch;
//            
//            if (scope == SearchScopeAll)
//            {
//                searchFetch = [EDFood fetchObjectsForEntityName:FOOD_ENTITY_NAME forSearchString:text];
//            }
//            
//            else if (scope == SearchScopeMeals)
//            {
//                searchFetch = [EDFood fetchObjectsForEntityName:MEAL_ENTITY_NAME forSearchString:text];
//            }
//            
//            else if (scope == SearchScopeIngredients)
//            {
//                searchFetch = [EDFood fetchObjectsForEntityName:INGREDIENT_ENTITY_NAME forSearchString:text];
//            }
//            
//            else if (scope == SearchScopeTypes)
//            {
//                searchFetch = [EDFood fetchObjectsForEntityName:TYPE_ENTITY_NAME forSearchString:text];
//                
//            }
//            
//            else if (scope == SearchScopeRestaurants)
//            {
//                searchFetch = [EDFood fetchObjectsForEntityName:RESTAURANT_ENTITY_NAME forSearchString:text];
//                
//            }
//            
//            else if (scope == SearchScopeTags)
//            {
//                searchFetch = [EDTag fetchSuggestedTagsForString:text];
//            }
//            
//            else if (scope == SearchScopeMedication)
//            {
//                searchFetch = [EDFood fetchObjectsForEntityName:MEDICATION_ENTITY_NAME forSearchString:text];
//            }
//            
//            else if (scope == SearchScopeNonMedication)
//            {
//                searchFetch = [EDFood fetchObjectsForEntityName:FOOD_ENTITY_NAME forSearchString:text];
//            }
//            
//            fetchResults = [context executeFetchRequest:searchFetch error:nil];
//            
//            
//            if (scope == SearchScopeNonMedication) { // we need to remove all medication after the fetch
//                
//                NSIndexSet *indexSet = [fetchResults indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//                    if ([obj isKindOfClass:[EDMedication class]]) {
//                        return NO;
//                    }
//                    else {
//                        return YES;
//                    }
//                }];
//                
//                fetchResults = [fetchResults objectsAtIndexes:indexSet];
//            }
//            
//            //            if (excludeTags) {
//            //
//            //                NSArray *subpredicates = [[NSArray alloc] init];
//            //                for (EDTag *tag in excludeTags) {
//            //                    //NSPredicate *tagPred = [NSPredicate predicateWithFormat:@"%@ IN tags.name", tag.name];
//            //                    //NSPredicate *notTagPred = [NSCompoundPredicate notPredicateWithSubpredicate:tagPred];
//            //
//            //                    NSPredicate *tagPred = [NSPredicate predicateWithFormat:@"ANY tags.name like[cd] %@", tag.name];
//            //                    NSPredicate *notTagPred = [NSCompoundPredicate notPredicateWithSubpredicate:tagPred];
//            //                    subpredicates = [subpredicates arrayByAddingObject:notTagPred];
//            //                }
//            //
//            //                NSPredicate *excludeTagPred = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
//            //
//            //            }
//            
//            NSIndexSet *indexSet = [fetchResults indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//                if ([obj isKindOfClass:[EDFood class]]) {
//                    return ![[(EDFood *)obj tags] containsObject:[EDTag getFavoriteTagInContext:context]];
//                }
//                else {
//                    return YES;
//                }
//            }];
//            
//            fetchResults = [fetchResults objectsAtIndexes:indexSet];
//        }];
//        
//        
//        
//    }
//    
//    return [NSArray arrayWithArray:fetchResults];
//}

@end
