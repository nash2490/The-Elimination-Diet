//
//  EDMenuViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/17/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDTableViewController.h"

@interface MHEDMenuViewController : EDTableViewController

@property (nonatomic, strong) NSArray *options;

- (id) initWithOptions:(NSArray *) options;

@end
