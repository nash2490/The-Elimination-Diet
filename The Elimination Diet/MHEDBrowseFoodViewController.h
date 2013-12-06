//
//  MHEDBrowseFoodViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/5/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EDEatNewMealViewController.h"

#import "EDEliminatedAPI.h"
#import "EDEliminatedAPI+Searching.h"

@interface MHEDBrowseFoodViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>


@property (nonatomic) SearchBarScope searchScope;

@property (nonatomic, weak) id <EDCreationDelegate> delegate;

@property (nonatomic, strong) EDRestaurant *restaurant;
@property (nonatomic) BOOL medicationFind;
@property (nonatomic, strong) NSArray *medicationList;
@property (nonatomic, strong) NSArray *mealsList;
@property (nonatomic, strong) NSArray *ingredientsList;


#pragma mark - UISearchBarDelegate methods -

// Editing Text
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
- (BOOL) searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;

// Clicking Buttons
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar;
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar;
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;

// Scope Button
- (void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope;

@end
