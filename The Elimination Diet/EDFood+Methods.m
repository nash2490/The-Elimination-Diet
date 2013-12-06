//
//  EDFood+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/28/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDFood+Methods.h"

#import "EDEliminatedAPI+Fetching.h"
#import "EDEliminatedAPI+Searching.h"
#import "EDEliminatedAPI+Sorting.h"

#import "EDTag+Methods.h"
#import "EDEliminatedFood+Methods.h"

#import "EDImage+Methods.h"


#import "NSError+MHED_MultipleErrors.h"
#import "NSString+EatDate.h"



@implementation EDFood (Methods)

#pragma mark - Property Creation
// --------------------------------------------------

-(NSString *) createUniqueID
{
    return [NSString createUniqueID];
}


#pragma mark - Images

- (void) addUIImagesToFood:(NSSet *)images error:(NSError *__autoreleasing *)error
{
    if (images) {
        
        for (UIImage *img in images) {
            
            EDImage *edImage = [EDImage createFromImage:img inContext:self.managedObjectContext];
            
            [self addImagesObject:edImage];
        }
    }
}

#pragma mark - Elimination Methods

- (EDEliminatedFood *) eliminateFromStartTime:(NSDate *)start
                                     stopTime:(NSDate *)stop
{
    return [EDEliminatedFood createWithFood:self
                                  startTime:start
                                   stopTime:stop
                                 forContext:self.managedObjectContext];
}

- (EDEliminatedFood *) eliminateNow
{
    return [EDEliminatedFood createWithFood:self
                                  startTime:[NSDate date]
                                   stopTime:[NSDate distantFuture]
                                 forContext:self.managedObjectContext];
}

// determines if the type is currently on the elimination list
- (BOOL) isCurrentlyEliminated
{
    if (self.whenEliminated) {
        for (EDEliminatedFood *elim in self.whenEliminated) {
            if ([elim isCurrent]) {
                return TRUE;
            }
        }
    }
    return FALSE;
}

// returns last date the type was on the elimination list (can be in the future)
- (NSDate *) whenNotEliminated
{
    NSDate *latest = [NSDate distantPast];
    if (self.whenEliminated) {
        // finds the EDEliminatedIngredient with latest stop time (or no stop time)
        for (EDEliminatedFood *elim in self.whenEliminated) {
            
            if (elim.stop) {
                latest = [latest laterDate:elim.stop];
            }
            
            // if elim.stop not defined then it is forever
            else {
                return [NSDate distantFuture];
            }
        }
        
        return latest;
    }
    
    
    return nil;
}


#pragma mark - Fetching

+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName];
    
    fetch.sortDescriptors = @[[EDEliminatedAPI nameSortDescriptor]];
    
    return fetch;
}



+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                            stringKeyPath: (NSString *) path
                            equalToString: (NSString *) stringValue
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName stringKeyPath:path equalToString:stringValue];
    
    return fetch;
}

+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                               setKeyPath: (NSString *) path
                            containsValue: (id) value
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName setKeyPath:path containsValue:value];
    
    return fetch;
}

+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
                                 withSelfInSet:(NSSet *)objects
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName withSelfInSet:objects];
    return fetch;
}

+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                  withFoodName:(NSString *)foodName
{
    return [EDEliminatedAPI fetchObjectsForEntityName:entityName withName:foodName];
}


+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
                                 withfoodNames:(NSArray *) foodNames
{
    
    //NSExpression *rhs = [NSExpression expressionWithFormat:@"name"];
    //NSExpression *lhs = [NSExpression expressionWithFormat:@"%@", foodNames];
    
    //NSPredicate *pred = [NSComparisonPredicate predicateWithLeftExpression:lhs rightExpression:rhs modifier:NSAnyPredicateModifier type:NSLikePredicateOperatorType options:NSCaseInsensitivePredicateOption];
    
    
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName withNames:foodNames];
    
    return fetch;
}


+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                 UniqueID: (NSString *) uniqueID
{
    return [EDEliminatedAPI fetchObjectsForEntityName:entityName UniqueID:uniqueID];
}


#pragma mark - Tag And Favorite Fetching -

+ (NSFetchRequest *) fetchObjectsForEntityName: (NSString *) entityName
                                     Tags: (NSSet *) tags
{
    return [EDTag fetchObjectsForEntityName:entityName withTags:tags];
}

+ (NSFetchRequest *) fetchFavoriteObjectsForEntityName:(NSString *)entityName
{
    return [EDEliminatedAPI fetchFavoriteObjectsForEntityName:entityName];
}


#pragma mark - Searching -

//---------
// search through name and tags
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName forSearchString:(NSString *)text
{
    
    
    return [EDEliminatedAPI fetchObjectsForEntityName:entityName forSearchString:text];
}


//+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName
//                               forSearchString:(NSString *)text
//                                  exludingTags:(NSSet *) tags
//{
//    NSFetchRequest *fetchObjects = [NSFetchRequest fetchRequestWithEntityName:entityName];
//    
//    NSPredicate *nameSearchPred = [NSPredicate predicateWithFormat:@"name contains[cd] %@", text];
//    NSPredicate *tagSearchPred = [NSPredicate predicateWithFormat:@"ANY tags.name contains[cd] %@", text];
//    
//    fetchObjects.predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[nameSearchPred, tagSearchPred]];
//    
//    fetchObjects.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
//    
//    return fetchObjects;
//}


// only searches through the names
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *)entityName foodNameContainingText:(NSString *)text
{
    NSFetchRequest *fetch = [EDEliminatedAPI fetchObjectsForEntityName:entityName nameContainingText:text];
    
    fetch.sortDescriptors = @[[EDEliminatedAPI nameSortDescriptor]];
    
    return fetch;
}

#pragma mark - Tags and Favorites
//- (BOOL) isFavorite
//{
//    EDTag *starTag = [EDTag getFavoriteTagInContext:self.managedObjectContext];
//    if ([self.tags containsObject:starTag]) {
//        return TRUE;
//    }
//    return FALSE;
//}

- (BOOL) isFavorite
{
    return [self.favorite boolValue];
}

- (NSString *) tagsAsString
{
    return [EDTag convertIntoString:self.tags];
}


#pragma mark - Validation methods

- (BOOL)validateForInsert:(NSError **)error
{
    BOOL propertiesValid = [super validateForInsert:error];
    if (!propertiesValid) {
        
        NSLog(@"%@", [*error localizedDescription]);
        return FALSE;
    }
    
    BOOL consistencyValid = [self validateConsistency:error];
    return (propertiesValid && consistencyValid);
}

- (BOOL)validateForUpdate:(NSError **)error
{
    BOOL propertiesValid = [super validateForUpdate:error];
    if (!propertiesValid) {
        
        NSLog(@"%@", [*error localizedDescription]);
        return FALSE;
    }
    
    BOOL consistencyValid = [self validateConsistency:error];
    return (propertiesValid && consistencyValid);
}





// **** CENTRAL VALIDATION METHOD ****
/// - We need to check whether or not there are overlapping eliminatedObject
- (BOOL)validateConsistency:(NSError **)error
{
    BOOL valid = TRUE;
    
    NSArray *elimOfFood = [self.whenEliminated allObjects];
    
    NSSet *overlappingElim = [[NSSet alloc] init]; // return in error 
    
    for (int i=0; i<[elimOfFood count]; i++) {
        for (int j=i+1; j<[elimOfFood count]; j++) {
            EDEliminatedFood *ithElim = elimOfFood[i];
            EDEliminatedFood *jthElim = elimOfFood[j];
            valid = ![ithElim overlapWithEliminatedFood:jthElim];
            if (!valid) {
                overlappingElim = [overlappingElim setByAddingObject:ithElim];
                overlappingElim = [overlappingElim setByAddingObject:jthElim];
                break;
            }
        }
        if (!valid) {
            break;
        }
    }
    
    if (!valid && error != NULL) {
        // a food cannot have elimination intervals that overlap
        /// To deal with in UI
        //      - show the user the most recent occurence (past, current, future)
        //          - if the adjust the START TIME and it now overlaps
        NSString *eliminationOverlapString = @"An eliminated object cannot have elimination intervals that overlap";
        NSMutableDictionary *eliminationOverlapInfo = [NSMutableDictionary dictionary];
        eliminationOverlapInfo[NSLocalizedFailureReasonErrorKey] = eliminationOverlapString;
        eliminationOverlapInfo[NSValidationObjectErrorKey] = overlappingElim;
        
        NSError *eliminationOverlapError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                               code:NSManagedObjectValidationError
                                                           userInfo:eliminationOverlapInfo];
        
        // if there was no previous error, return the new error
        if (*error == nil) {
            *error = eliminationOverlapError;
        }
        // if there was a previous error, combine it with the existing one
        else {
            *error = [NSError errorFromOriginalError:*error error:eliminationOverlapError];
        }
        
        NSLog(@"%@", [*error localizedDescription]);
    
    }
    
    return valid;
}

/// Other Methods
//---------------------------------------------------------------

- (NSString *) nameFirstLetter
{
    if ([self.name length]) {
        return [self.name substringToIndex:1];
    }
    
    return @"";
    
}

@end
