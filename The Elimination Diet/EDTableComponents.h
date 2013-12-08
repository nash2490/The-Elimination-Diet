//
//  EDTableComponents.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/4/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

/// The purpose of this class is to create an object that contains the information for a basic table to display static information easily formatted into sections and their rows. Furthermore it is easy for the table to retreive the contents of a given indexPath or header. The actual why the info is displayed is left to the table view controller

/// table array --> section Arrays --> dictionaries of keys



#import <Foundation/Foundation.h>





#define mhedTitleKey      @"title"    // key for obtaining the data source item's title
#define mhedDateKey        @"date"    // key for obtaining the data source item's date value
#define mhedDetailKey     @"detail"   // key for the data source item's detail text
#define mhedCellIDKey     @"cellID"   // key for the type of cell to use

#define mhedCellStyleKey  @"cellStyle" // key for the style of the cell

#define mhedHeaderKey     @"header" // key for obtaining the header if the object is a section header

#define mhedNoHeader      @"no header" // key to tell table not to display a header for the section

#define mhedHideShowKey   @"hide/show" // key to tell boolean value of hideshow cell



@interface EDTableComponents : NSObject

#pragma mark - Creating -
- (void) setDictionary: (NSDictionary *) rowDictionary forIndexPath: (NSIndexPath *) indexPath;

- (void) addDictionary: (NSDictionary *) rowDictionary toEndOfSection: (NSInteger) section;

- (void) setSectionArray: (NSArray *)sectionArray forSection: (NSInteger) section;

- (void) addSectionArrayToEnd: (NSArray *) sectionArray;



#pragma mark - Retreiving -
- (NSString *) headerForSection: (NSInteger) section;

- (NSString *) titleForRowAtIndexPath: (NSIndexPath *) indexPath;

- (NSString *) cellIDForRowAtIndexPath: (NSIndexPath *) indexPath;

- (UITableViewCellStyle) cellStyleForRowAtIndexPath: (NSIndexPath *) indexPath;


- (UITableViewCell *) tableView:(UITableView *) tableView getCellForRowAtIndexPath: (NSIndexPath *) indexPath;

- (NSString *) detailTextForRowAtIndexPath: (NSIndexPath *) indexPath;

- (NSDate *) dateForRowAtIndexPath: (NSIndexPath *) indexPath;

- (id) objectValueForKey: (NSString *) key forRowAtIndexPath: (NSIndexPath *) indexPath;



@end
