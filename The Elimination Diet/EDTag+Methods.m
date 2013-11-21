//
//  EDTag+Methods.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/28/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDTag+Methods.h"

#import "EDEliminatedAPI.h"
#import "EDEliminatedAPI+Fetching.h"

#import "EDEliminatedAPI+Helpers.h"
#import "EDEliminatedAPI+Sorting.h"

@implementation EDTag (Methods)

//+ (NSString *) favoriteTag
//{
//    return FAVORITE_TAG_NAME;
//}

+ (NSString *) beverageTag
{
    return BEVERAGE_TAG_NAME;
}

+ (NSString *) dislikeTag
{
    return DISLIKE_TAG_NAME;
}


// Creation Methods
// --------------------------------------------------

+ (EDTag *) createTagWithName:(NSString *) name
                    inContext:(NSManagedObjectContext *) context
{
    if (name) {
        // check if a tag with the same name already exists
        NSPredicate *namePred = [NSPredicate predicateWithFormat:@"name like[cd] %@", name];
        
        NSFetchRequest *fetchTag = [NSFetchRequest fetchRequestWithEntityName:TAG_ENTITY_NAME];
        fetchTag.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[namePred]];
        
        NSError *error;
        NSArray *sameObjects = [context executeFetchRequest:fetchTag error:&error];
        
        // if there are not tags with this name then lets create it
        if (![sameObjects count]) {
            
            EDTag *temp = [NSEntityDescription insertNewObjectForEntityForName:TAG_ENTITY_NAME
                                                        inManagedObjectContext:context];
            
            // set tag string
            temp.name = name;
            temp.uniqueID = [EDEliminatedAPI createUniqueID];
            
            return temp;
        }
        else if ([sameObjects count] == 1){
            return sameObjects[0];
        }
        
        else { // there are more than one with this name
            // ERROR
            NSLog(@"more than one tag with name %@", name);
            return nil;
        }
    }
    else {
        return nil;
    }
}

//+ (EDTag *) getFavoriteTagInContext:(NSManagedObjectContext *) context
//{
//    EDTag *favoriteTag = [EDTag suggestTagForText:[EDTag favoriteTag] inContext:context];
//    if (!favoriteTag) {
//        return [EDTag createTagWithName:[EDTag favoriteTag] inContext:context];
//    }
//    else{
//        return favoriteTag;
//    }
//}

+ (EDTag *) getBeverageTagInContext:(NSManagedObjectContext *) context
{
    EDTag *beverageTag = [EDTag suggestTagForText:[EDTag beverageTag] inContext:context];
    if (!beverageTag) {
        return [EDTag createTagWithName:[EDTag beverageTag] inContext:context];
    }
    else{
        return beverageTag;
    }
}

+ (void) setUpDefaultTagsInContext:(NSManagedObjectContext *)context
{
    //[EDTag createTagWithName:[EDTag favoriteTag] inContext:context];
    [EDTag createTagWithName:[EDTag beverageTag] inContext:context];
    [EDTag createTagWithName:[EDTag dislikeTag] inContext:context];
}
// Fetching
// --------------------------------------------------

+ (NSFetchRequest *) fetchAllTags
{
    return [EDEliminatedAPI fetchObjectsForEntityName:TAG_ENTITY_NAME];
}

- (NSFetchRequest *) taggedEntityObjectsForName:(NSString *) entityName
{
    NSPredicate *tagPred = [NSPredicate predicateWithFormat:@"%@ IN tags", self];
    
    NSFetchRequest *fetchTag = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchTag.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[tagPred]];
    fetchTag.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    return fetchTag;
}

+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *) entityName
                                  withTag:(EDTag *) tag
{
    NSPredicate *tagPred = [NSPredicate predicateWithFormat:@"%@ IN tags", tag];
    
    NSFetchRequest *fetchTag = [NSFetchRequest fetchRequestWithEntityName:TAG_ENTITY_NAME];
    fetchTag.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[tagPred]];
    fetchTag.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    return fetchTag;
}

+ (NSFetchRequest *) fetchTagForName:(NSString *) tagName
                           inContext:(NSManagedObjectContext *) context
{
    NSPredicate *tagPred = [NSPredicate predicateWithFormat:@"name like[cd] %@", tagName];
    
    NSFetchRequest *fetchTag = [NSFetchRequest fetchRequestWithEntityName:TAG_ENTITY_NAME];
    fetchTag.predicate = tagPred;
    
    return fetchTag;
}


+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *) entityName
                                   withTagName:(NSString *) tagName
                                     inContext:(NSManagedObjectContext *) context
{
    NSFetchRequest *fetchTag = [EDTag fetchTagForName:tagName inContext:context];
    
    NSError *error;
    NSArray *tagsForName = [context executeFetchRequest:fetchTag error:&error];
    
    EDTag *tag;
    if ([tagsForName count] == 1) {
        tag = tagsForName[0];
    }
    
    return [EDTag fetchObjectsForEntityName:entityName withTag:tag];
}

+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *) entityName
                                      withTags:(NSSet *) tags
{
    
    NSArray *subpredicates = [[NSArray alloc] init];
    for (EDTag *tag in tags) {
        NSPredicate *tagPred = [NSPredicate predicateWithFormat:@" ANY tags.name like[cd] %@", tag.name];
        subpredicates = [subpredicates arrayByAddingObject:tagPred];
    }
    
    NSFetchRequest *fetchTag = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchTag.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    fetchTag.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    return fetchTag;
}


//+ (NSFetchRequest *) fetchFavoriteObjectsForEntityName:(NSString *) entityName
//                                            inContext:(NSManagedObjectContext *) context
//{
//    
//    NSFetchRequest *fetchTag = [EDTag fetchObjectsForEntityName:entityName withTagName:[EDTag favoriteTag] inContext:context];
//    
//    return fetchTag;
//}

+ (NSFetchRequest *) fetchBeverageObjectsForEntityName:(NSString *) entityName
                                             inContext:(NSManagedObjectContext *) context
{
    
    NSFetchRequest *fetchTag = [EDTag fetchObjectsForEntityName:entityName withTagName:[EDTag beverageTag] inContext:context];
    
    return fetchTag;
}

+ (NSFetchRequest *) fetchDislikeObjectsForEntityName:(NSString *) entityName
                                            inContext:(NSManagedObjectContext *) context
{
    
    NSFetchRequest *fetchTag = [EDTag fetchObjectsForEntityName:entityName withTagName:[EDTag dislikeTag] inContext:context];
    
    return fetchTag;
}


// Tag suggestion methods
//-----------------------------------------------------------

+ (NSFetchRequest *) fetchSuggestedTagsForString:(NSString *)text
{
    NSPredicate *namePred = [NSPredicate predicateWithFormat:@"name contains[cd] %@", text];
    
    NSFetchRequest *fetchTag = [NSFetchRequest fetchRequestWithEntityName:TAG_ENTITY_NAME];
    fetchTag.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[namePred]];
    fetchTag.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    return fetchTag;
}


+ (NSFetchRequest *) fetchSuggestedTagsForString:(NSString *)text
                                     withOutTags: (NSSet *) tags
{
    // get the same predicate as fetchSuggestedTagsForString:, which checks against all tag names
    NSFetchRequest *simpleSuggestionFetch = [EDTag fetchSuggestedTagsForString:text];
    NSPredicate *simpleSuggestionPredicate = simpleSuggestionFetch.predicate;
    
    // we don't want tags that are in the given set
    NSPredicate *excludeTagsPredicate = [NSPredicate predicateWithFormat:@"NOT (self IN %@)", tags];
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:TAG_ENTITY_NAME];
    fetch.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[simpleSuggestionPredicate, excludeTagsPredicate]];
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    return fetch;
}







+ (EDTag *) suggestTagForText:(NSString *)text inContext:(NSManagedObjectContext *)context
{
    
    NSFetchRequest *fetchTag = [EDTag fetchSuggestedTagsForString:text];
    
    NSError *error;
    NSArray *sameObjects = [context executeFetchRequest:fetchTag error:&error];
    
    if ([sameObjects count]) {
        if ([sameObjects count] == 1) {
            return sameObjects[0];
        }
        else {
            // ERROR - there should only be 1 tag with the same name
        }
    }
    
    return nil;
    // we should look into just creating the object if none exists
}

+ (NSString *) suggestTagNameForText:(NSString *) text
                           inContext:(NSManagedObjectContext *)context
{
    EDTag *suggestedTag = [EDTag suggestTagForText:text
                                         inContext:context];
    
    if (suggestedTag) {
        return suggestedTag.name;
    }
    
    return nil;
}



#pragma mark - Other Methods -
// --------------------------------------------------

+ (NSString *) convertIntoString:(NSSet *) tags
{
    NSString *tagString = @"";
    NSSet *tagNames = [tags valueForKey:@"name"];
    NSArray *orderedTagNames = [tagNames allObjects];
    orderedTagNames = [orderedTagNames sortedArrayUsingComparator:
                                 ^(id obj1, id obj2) {
                                     return [obj1 caseInsensitiveCompare:obj2];
                                 }];
    tagString = [orderedTagNames componentsJoinedByString:@", "];
    
    return tagString;
}

+ (NSString *) convertArrayIntoString: (NSArray *) tags
{
    NSString *tagString = @"";
    NSArray *tagNames = [tags valueForKey:@"name"];
    tagString = [tagNames componentsJoinedByString:@", "];
    
    return tagString;
}

+ (NSString *) convertTagNamesIntoString:(NSSet *)tagNames
{
    NSString *tagString = @"";
    NSArray *orderedTagNames = [tagNames allObjects];
    orderedTagNames = [orderedTagNames sortedArrayUsingComparator:
                       ^(id obj1, id obj2) {
                           return [obj1 caseInsensitiveCompare:obj2];
                       }];
    tagString = [orderedTagNames componentsJoinedByString:@", "];
    
    return tagString;
}

+ (NSAttributedString *) convertIntoAttributedString:(NSArray *)tags
{
    UIFont *titleLabelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    
    NSString *tagString = [EDTag convertArrayIntoString:tags];
    
    NSMutableAttributedString *attributedTagString = [[NSMutableAttributedString alloc] initWithString:tagString attributes:@{ NSFontAttributeName : titleLabelFont}];
    
    NSArray *tagNames = [tags valueForKey:@"name"];
    
    for (NSString *name in tagNames) {
        NSRange searchTextRange = [tagString rangeOfString:name options:NSCaseInsensitiveSearch];
        
        [attributedTagString setAttributes:@{ NSFontAttributeName : titleLabelFont, NSBackgroundColorAttributeName : [UIColor yellowColor]} range:searchTextRange];
        
    }
    return [attributedTagString copy];
}

//+ (NSString *) convertIntoStringWithoutFavorite:(NSSet *)tags
//{
//    NSSet *tagNames = [tags valueForKey:@"name"];
//    NSMutableSet *mutTagNames = [tagNames mutableCopy];
//    [mutTagNames removeObject:FAVORITE_TAG_NAME];
//    
//    return [EDTag convertTagNamesIntoString:[mutTagNames copy]];
//}

//+ (NSString *) convertArrayIntoStringWithoutFavorite: (NSArray *) tags
//{
//    NSArray *tagNames = [tags valueForKey:@"name"];
//    NSMutableArray *mutTags = [tagNames mutableCopy];
//    [mutTags removeObject:FAVORITE_TAG_NAME];
//    
//    return [mutTags componentsJoinedByString:@", "];
//}



//+ (NSAttributedString *) convertIntoAttributedStringWithoutFavorite:(NSArray *)tags
//{
//    UIFont *titleLabelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
//    
//    NSString *tagString = [EDTag convertArrayIntoStringWithoutFavorite:tags];
//    
//    NSMutableAttributedString *attributedTagString = [[NSMutableAttributedString alloc] initWithString:tagString attributes:@{ NSFontAttributeName : titleLabelFont}];
//    
//    NSArray *tagNames = [tags valueForKey:@"name"];
//    
//    for (NSString *name in tagNames) {
//        NSRange searchTextRange = [tagString rangeOfString:name options:NSCaseInsensitiveSearch];
//        
//        [attributedTagString setAttributes:@{ NSFontAttributeName : titleLabelFont, NSBackgroundColorAttributeName : [UIColor yellowColor]} range:searchTextRange];
//        
//    }
//    return [attributedTagString copy];
//}


+ (NSRange) rangeForWordInString:(NSString *) string forRange:(NSRange)range
{
    
    // we get the range of the first @", " - commaRange
    // if it is less than the given range, then we delete those prior to commaRange, and add the commaRange.length + commaRange.location to counter
    // we do until it is no longer true.
    // then we get the location of the next comma and return the range from 0 to the comma
    
    NSRange commaRange, deleteRange;
    commaRange.location = 0;
    commaRange.length = 0;
    
    deleteRange.location = 0;
    deleteRange.length = 0;
    
    NSInteger startOfRange = 0;
    
    NSMutableString *mutString = [string mutableCopy];
    
    if (range.length + range.location >= [string length] ||
        range.length + range.location == 0) {
        return NSMakeRange(0, 0);
    }
    if (range.location == NSNotFound || range.length == NSNotFound) {
        return NSMakeRange(0, 0);
    }
    
    
    while (startOfRange < range.location) {
        
        commaRange.location = 0;
        commaRange.length = 0;
        
        deleteRange.location = 0;
        deleteRange.length = 0;
        
        // find range of the separator @", "
        commaRange = [mutString rangeOfString:@", " options:NSCaseInsensitiveSearch];
        
        if (commaRange.location == NSNotFound || commaRange.length == NSNotFound) {
            return NSMakeRange(0, 0);
        }
        
        // delete the characters before the next word
        deleteRange.length = commaRange.length + commaRange.location;
        deleteRange.location = 0;
        [mutString deleteCharactersInRange:deleteRange];
        
        // add the location and length to running counter to determine the start of the next word
        startOfRange = startOfRange + deleteRange.length;
    }
    
    // now we want to determine when the word ends, so we find the @", " after
    commaRange = [mutString rangeOfString:@", " options:NSCaseInsensitiveSearch];
    
    NSRange wordRange;
    wordRange.location = startOfRange;
    wordRange.length = commaRange.location;
    
    return wordRange;
}


- (NSString *) nameFirstLetter
{
    return [EDEliminatedAPI nameFirstLetter:self.name];
}

#pragma mark - Validation

// Validation Helpers
//---------------------------------------------------------------



// Validation methods
//---------------------------------------------------------------

- (BOOL)validateForInsert:(NSError **)error
{
    BOOL propertiesValid = [super validateForInsert:error];
    if (!propertiesValid) {
        
        NSLog(@"%@", [*error localizedDescription]);
        NSLog(@"error event");
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
/// - We need to check
//      -
//      - that there are NO cycles of parentMedicationDosages
- (BOOL)validateConsistency:(NSError **)error
{
    //  do cycles in parent/children exist
    BOOL valid = YES;
    
    //
    if (!valid)
    {
        
    }
    
    return valid;
}




@end
