//
//  EDTableComponents.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/4/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDTableComponents.h"

@interface EDTableComponents ()

@property (nonatomic, strong) NSArray *tableArray;

@end

@implementation EDTableComponents


- (NSArray *) tableArray
{
    if (!_tableArray) {
        _tableArray = [[NSArray alloc] init];
    }
    return _tableArray;
}

#pragma mark - Creating -

- (NSDictionary *) dictionaryForIndexPath: (NSIndexPath *) indexPath
{
    if ([self.tableArray count] >= indexPath.section) {
        NSArray *sectionArray = self.tableArray[indexPath.section];
        
        if ([sectionArray count] >= indexPath.row) {
            return (NSDictionary *)sectionArray[indexPath.row];
        }
    }
    return nil;
}

- (void) setDictionary: (NSDictionary *) rowDictionary forIndexPath: (NSIndexPath *) indexPath
{
    if (rowDictionary) {
        
        if ([self.tableArray count] >= indexPath.section) {
            NSArray *sectionArray = self.tableArray[indexPath.section];
            
            if ([sectionArray count] >= (indexPath.row - 1)) {
                NSArray *newSectionArray;
                if ([sectionArray count] == (indexPath.row -1)) {
                    newSectionArray = [sectionArray arrayByAddingObject:rowDictionary];
                }
                else {
                    NSMutableArray *mutSectionArray = [sectionArray mutableCopy];
                    [mutSectionArray insertObject:rowDictionary atIndex:(NSUInteger)indexPath.row];
                    newSectionArray = [mutSectionArray copy];
                }
                
                [self setSectionArray:newSectionArray forSection:indexPath.section];
                
            }
        }
    }
}

- (void) addDictionary: (NSDictionary *) rowDictionary toEndOfSection: (NSInteger) section
{
    NSArray *sectionArray = self.tableArray[section];
    NSInteger row = [sectionArray count] + 1;
    
    [self setDictionary:rowDictionary forIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
}


- (void) setSectionArray: (NSArray *)sectionArray forSection: (NSInteger) section
{
    // section can be 1 more than the current length
    /// if the section already exists then we replace it,
    /// if it is one more than we add it to the end
    
    if (sectionArray) {
        if ([self.tableArray count] >= (section - 1)) {
            NSArray *newTableArray;
            if ([self.tableArray count] == (section -1)) {
                newTableArray = [self.tableArray arrayByAddingObject:sectionArray];
            }
            else {
                NSMutableArray *mutTableArray = [self.tableArray mutableCopy];
                [mutTableArray insertObject:sectionArray atIndex:(NSUInteger)section];
                newTableArray = [mutTableArray copy];
            }
            
            self.tableArray = newTableArray;
            
        }
    }
    
}

- (void) addSectionArrayToEnd: (NSArray *) sectionArray
{
    [self setSectionArray:sectionArray forSection:[self.tableArray count] +1];
}





#pragma mark - Retreiving -

/// helper method to create an index path that has the given section and row 0, which is the row a header is to be stored
+ (NSIndexPath *) headerRowForSection: (NSInteger) section
{
    NSIndexPath *headerIndex = [NSIndexPath indexPathForRow:0 inSection:section];
    return headerIndex;
}

- (NSString *) headerForSection: (NSInteger) section
{
    NSIndexPath *headerIndexPath = [EDTableComponents headerRowForSection:section];
    
    NSString *headerString = [self objectValueForKey:edHeaderKey forRowAtIndexPath:headerIndexPath];
    
    if (headerString) {
        return headerString;
    }
    else {
        return @"";
    }
}

- (NSString *) titleForRowAtIndexPath: (NSIndexPath *) indexPath
{
    NSString *titleString = [self objectValueForKey:edTitleKey forRowAtIndexPath:indexPath];
    
    if (titleString) {
        return titleString;
    }
    else {
        return @"";
    }
}


- (NSString *) cellIDForRowAtIndexPath: (NSIndexPath *) indexPath
{
    NSString *string = [self objectValueForKey:edCellIDKey forRowAtIndexPath:indexPath];
    
    if (string) {
        return string;
    }
    else {
        return @"";
    }
}

- (UITableViewCellStyle) cellStyleForRowAtIndexPath: (NSIndexPath *) indexPath
{
    
    NSNumber *cellStyleNumber = [self objectValueForKey:edCellStyleKey forRowAtIndexPath:indexPath];
    
    if (cellStyleNumber) {
        UITableViewCellStyle cellStyle = [cellStyleNumber integerValue];
        return cellStyle;
    }
    else {
        return UITableViewCellStyleDefault;
    }
}



- (UITableViewCell *) tableView:(UITableView *) tableView getCellForRowAtIndexPath: (NSIndexPath *) indexPath;
{
    NSString *cellID = [self cellIDForRowAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        UITableViewCellStyle cellStyle = [self cellStyleForRowAtIndexPath:indexPath];
        
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellID];
    }
    
    return cell;
}


- (NSString *) detailTextForRowAtIndexPath: (NSIndexPath *) indexPath
{
    NSString *string = [self objectValueForKey:edDetailKey forRowAtIndexPath:indexPath];
    
    if (string) {
        return string;
    }
    else {
        return @"";
    }
}


- (NSDate *) dateForRowAtIndexPath: (NSIndexPath *) indexPath
{
    NSDate *date = [self objectValueForKey:edDateKey forRowAtIndexPath:indexPath];
    
    if (date) {
        return date;
    }
    else {
        return nil;
    }
}


- (id) objectValueForKey: (NSString *) key forRowAtIndexPath: (NSIndexPath *) indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if ([self.tableArray count] >= section) {
        NSArray *sectionArray = self.tableArray[section];
        
        if ([key isEqualToString:edHeaderKey]) { // then the index is unadjusted
            
        }
        
        else { // then we adjust the index because ith row in the table is the i+1 th row in the array
            
            row++;
        }
        
        if ([sectionArray count] >= row) {
            NSDictionary *dictForRow = sectionArray[row];
            
            return dictForRow[key];
        }
    }
    
    return nil;
}

@end
