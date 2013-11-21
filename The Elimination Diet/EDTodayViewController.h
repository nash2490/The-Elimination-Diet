//
//  EDTodayViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/3/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDViewController.h"
#import "EDDateView.h"

@interface EDTodayViewController : EDViewController <UITableViewDataSource, UITableViewDelegate, EDDateProtocol>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) EDDateView *dateHeader;

@property (nonatomic, strong) NSDictionary *fetchRequests;

@property (nonatomic, strong) NSDictionary *fetchedObjects;

@end
