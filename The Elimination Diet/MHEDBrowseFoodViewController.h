//
//  MHEDBrowseFoodViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 12/6/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "MHEDBrowseViewController.h"

#import "MHEDFoodSelectionViewController.h"

#import "EDEliminatedAPI+Searching.h"




typedef NS_ENUM(NSInteger, MHEDBrowseFoodSections) {
    MHEDBrowseFoodSectionsMeals,
    MHEDBrowseFoodSectionsIngredients,
    MHEDBrowseFoodSectionsIngredientTypes,
    MHEDBrowseFoodSectionsRestaurants
};



@class EDRestaurant;

@interface MHEDBrowseFoodViewController : MHEDBrowseViewController

@property (nonatomic) MHEDBrowseFoodSections displaySection;

@property (nonatomic, strong) NSArray *foodOptions;
@property (nonatomic, strong) NSArray *mealOptions;
@property (nonatomic, strong) NSArray *ingredientOptions;
@property (nonatomic, strong) NSArray *ingredientTypeOptions;
@property (nonatomic, strong) NSArray *restaurantOptions;

@property (nonatomic) MHEDSearchBarScopeType searchScope;


@property (nonatomic, strong) EDRestaurant *restaurant;

@property (nonatomic, weak) id <MHEDFoodSelectionViewControllerDataSource> delegate;

@property (nonatomic, strong) NSString *previousBrowseControllerTitle;

//#pragma mark - UISearchBarDelegate methods -
//
//// Editing Text
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
//- (BOOL) searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar;
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
//
//// Clicking Buttons
//- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar;
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
//- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar;
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
//
//// Scope Button
//- (void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope;

@end
