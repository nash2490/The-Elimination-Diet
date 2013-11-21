//
//  EDSelectTagsViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 11/7/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDCoreDataTableViewController.h"


@protocol EDSelectTagsDelegate <NSObject>

- (void) addTagsToList: (NSSet *) tags;

@end

@interface EDSelectTagsViewController : EDCoreDataTableViewController

@property (nonatomic, weak) id <EDSelectTagsDelegate> delegate;

@property (nonatomic, strong) NSSet *tagsList;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)doneButtonPress:(id)sender;

@end
