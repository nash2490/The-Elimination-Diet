//
//  EDTag+Methods.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 8/28/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDTag.h"

#define TAG_ENTITY_NAME @"EDTag"

//#define FAVORITE_TAG_NAME @"Favorite"
#define BEVERAGE_TAG_NAME @"Beverage"
#define DISLIKE_TAG_NAME @"Dislike"


@interface EDTag (Methods)

//+ (NSString *) favoriteTag;
+ (NSString *) beverageTag;
+ (NSString *) dislikeTag;


#pragma mark - Creation Methods
// --------------------------------------------------

/*! Create a new EDTag object in the context, or return a tag with specified name if there is only one
 @param name the name of the new tag
 @param context the mananged object context to create the EDTag
 @returns The EDTag object in the context that is associated to the given name. Returns nil if name is nil or there was more than 1 EDTag in context with the name
 */
+ (EDTag *) createTagWithName:(NSString *) name
                    inContext:(NSManagedObjectContext *) context;


/*! Create the tag to be used for favorite/favorite foods. If none already exists, it creates the tag.
 @param context the context to retrieve the tag from
 @returns The EDTag object associated with favorite/favorite
 */
//+ (EDTag *) getFavoriteTagInContext:(NSManagedObjectContext *) context;

/*! Create the tag to be used for beverage foods. If none already exists, it creates the tag.
 @param context the context to retrieve the tag from
 @returns The EDTag object associated with beverages
 */
+ (EDTag *) getBeverageTagInContext:(NSManagedObjectContext *) context;

/*! Initializes the default tags for favorite and beverages
 @param context the context to create the default tags
 */
+ (void) setUpDefaultTagsInContext:(NSManagedObjectContext *) context;


#pragma mark - Fetching
// --------------------------------------------------

+ (NSFetchRequest *) fetchAllTags;

// returns a fetch request that gets objects of a certain entity that have this tag

/*! Creates a fetch request that returns the objects of class entityName that have the receiving EDTag as a tag
 @param entityName the name of the entity class to fetch objects from
 @returns A fetch request
 */
- (NSFetchRequest *) taggedEntityObjectsForName:(NSString *) entityName;

/*! Creates a fetch request that returns the objects of class entityName that have the given EDTag as a tag
 @param entityName the name of the entity class to fetch objects from
 @returns A fetch request
 */
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *) entityName
                                       withTag:(EDTag *) tag;

/*! Creates a fetch request to get the tags that have the given name
 @param tagName the name of the tag to search for
 @param context
 @returns A fetch request
 */
+ (NSFetchRequest *) fetchTagForName:(NSString *) tagName
                           inContext:(NSManagedObjectContext *) context;
/*! Creates a fetch request to get the entity objects with a tag that has the given name
 @param entityName the name of the entity class to fetch objects from
 @param tagName the name of the tag to get objects with
 @param context
 @returns A fetch request
 */
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *) entityName
                                   withTagName:(NSString *) tagName
                                     inContext:(NSManagedObjectContext *) context;

// returns a fetch request that gets objects of a certain entity that the tags listed
/*! Creates a fetch request to
 @param
 @returns
 */
+ (NSFetchRequest *) fetchObjectsForEntityName:(NSString *) entityName
                                      withTags:(NSSet *) tags;

//+ (NSFetchRequest *) fetchFavoriteObjectsForEntityName:(NSString *) entityName
//                                            inContext:(NSManagedObjectContext *) context;

+ (NSFetchRequest *) fetchBeverageObjectsForEntityName:(NSString *) entityName
                                             inContext:(NSManagedObjectContext *) context;

+ (NSFetchRequest *) fetchDislikeObjectsForEntityName:(NSString *) entityName
                                            inContext:(NSManagedObjectContext *) context;


// Tag Suggestion Methods
//---------------

+ (NSFetchRequest *) fetchSuggestedTagsForString: (NSString *) text;

+ (NSFetchRequest *) fetchSuggestedTagsForString:(NSString *)text
                                     withOutTags: (NSSet *) tags;

// find the tag for the given string
+ (EDTag *) suggestTagForText:(NSString *)text
             inContext:(NSManagedObjectContext *)context;

// suggests a tag name for the text typed
+ (NSString *) suggestTagNameForText:(NSString *) text
                           inContext:(NSManagedObjectContext *)context;

#pragma mark - Other methods
// --------------------------------------------------

// convert a set of tags into a string
+ (NSString *) convertIntoString:(NSSet *) tags;

+ (NSString *) convertArrayIntoString: (NSArray *) tags;

+ (NSAttributedString *) convertIntoAttributedString:(NSArray *)tags;


//+ (NSString *) convertIntoStringWithoutFavorite:(NSSet *)tags;

//+ (NSString *) convertArrayIntoStringWithoutFavorite: (NSArray *) tags;


//+ (NSAttributedString *) convertIntoAttributedStringWithoutFavorite:(NSArray *) tags;

+ (NSString *) convertTagNamesIntoString: (NSSet *) tagNames;


/// For the given range we want to find the word that most associates to it
///     - returns the range of word
+ (NSRange) rangeForWordInString:(NSString *) string forRange:(NSRange)range;

- (NSString *) nameFirstLetter;
@end
