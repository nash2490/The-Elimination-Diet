//
//  EDEliminatedAPI+Fetching.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 10/25/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDEliminatedAPI+Fetching.h"

#import "EDEliminatedAPI+Sorting.h"

@implementation EDEliminatedAPI (Fetching)

#pragma mark - Fetching

+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                           withSortDescriptors:(NSArray *)sortDescriptors
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetch.predicate = nil;
    fetch.sortDescriptors = sortDescriptors;
    
    return fetch;
}

+ (NSFetchRequest *) fetchObjectsSortedByNameForEntityName: (NSString *) entityName
{
    return [EDEliminatedAPI fetchObjectsForEntityName:entityName withSortDescriptors:@[[EDEliminatedAPI nameSortDescriptor]]];
}

+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName
                                                   withSortDescriptors:@[[EDEliminatedAPI nameSortDescriptor]]];
    
    return fetch;
}


+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                 stringKeyPath: (NSString *) path
                                 equalToString: (NSString *) stringValue
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K like[cd] %@", path, stringValue];
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetch.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[pred]];
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:path ascending:YES]];
    
    return fetch;
}

+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                    setKeyPath: (NSString *) path
                                 containsValue: (id) value
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%@ IN %K", value, path];
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetch.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[pred]];
    
    return fetch;
}

+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
                                 withSelfInSet:(NSSet *)objects
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"self IN %@", objects];
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetch.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[pred]];
    
    return fetch;
}

+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                      withName:(NSString *) name
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName stringKeyPath:@"name" equalToString:name];
    
    fetch.sortDescriptors = @[[EDEliminatedAPI nameSortDescriptor]];
    
    return fetch;
}


+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
                                     withNames:(NSArray *) names
{
    
    //NSExpression *rhs = [NSExpression expressionWithFormat:@"name"];
    //NSExpression *lhs = [NSExpression expressionWithFormat:@"%@", foodNames];
    
    //NSPredicate *pred = [NSComparisonPredicate predicateWithLeftExpression:lhs rightExpression:rhs modifier:NSAnyPredicateModifier type:NSLikePredicateOperatorType options:NSCaseInsensitivePredicateOption];
    
    
    NSMutableArray *mutPredicates = [NSMutableArray array];
    
    for (int i=0; i<[names count]; i++) {
        [mutPredicates addObject:[NSPredicate predicateWithFormat:@"name LIKE[cd] %@", names[i]]];
        
    }
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetch.predicate = [NSCompoundPredicate orPredicateWithSubpredicates:[mutPredicates copy]];
    
    fetch.sortDescriptors = @[[EDEliminatedAPI nameSortDescriptor]];
    
    return fetch;
}


+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                      UniqueID: (NSString *) uniqueID
{
    return [EDEliminatedAPI fetchObjectsForEntityName:entityName
                               stringKeyPath:@"uniqueID"
                               equalToString:uniqueID];
}


#pragma mark - Favorites

/// fetch objects of entity that have self.favorite == YES
+ (NSFetchRequest *) fetchFavoriteObjectsForEntityName:(NSString *)entityName
{
    NSFetchRequest * fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName];
    fetch.predicate = [EDEliminatedAPI favoritePredicate];
    
    return fetch;
}

#pragma mark - Predicates

/// predicate for favorite in a food
+ (NSPredicate *) favoritePredicate
{
    return [NSPredicate predicateWithFormat:@"favorite = YES"];
}


@end
