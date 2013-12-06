//
//  EDViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/8/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//


/*  NOTES FOR SUBCLASSING
 
 (A) before interface
 
 (B) initWith....
        (1) reuse identifiers if using a table
 
 (C) viewDidLoad
        (1) set up left and right nav buttons and their handler methods
        (2) call [super viewDidLoad];
        (3) set up table view if there is one 
                - self.tableView = [self setUpTableView:[self setUpTableViewFrame]];
                - [self.topView addSubview:self.tableView];
        (4) set the data to be displayed
                - fetch requests / objects for table
                - call [self updateProperties];
                - etc.
    
 (D) viewWillAppear 
        (1) [super viewWillAppear: animated];
        (2) if there isn't a MOC then create one by using EDDocumentHandler etc.
                - within block [self updateTable] in main thread
 
 
*/

#define TAN_YELLOW_BACKGROUND [[UIColor alloc] initWithRed:0.99f green:0.99f blue:0.8f alpha:1.0f]
#define TAN_BACKGROUND [[UIColor alloc] initWithRed:0.99f green:1.0f blue:0.92f alpha:1.0f]
#define DEFAULT_TEXTFIELD_BACKGROUND [[UIColor alloc] initWithRed:0.99f green:1.0f blue:0.92f alpha:01.0f]
#define BROWN_SEPARATOR_COLOR [[UIColor alloc] initWithRed:0.78f green:0.56f blue:0.06f alpha:0.5f]
#define BROWN_NAVBAR_COLOR [[UIColor alloc] initWithRed:0.78f green:0.56f blue:0.06f alpha:1.0f]

#define DEFAULT_VIEW_BORDER 5


typedef enum {NoButton = 0, DoneButton, AcceptButton, NextButton, CancelButton, BackButton, UpdateButton, CameraButton, PlusButton} NavButtonStyle;


#import <UIKit/UIKit.h>
#import "UIView+MHED_AdjustView.h"


@interface EDViewController : UIViewController <UITextFieldDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic) NavButtonStyle rightButtonStyle;
@property (nonatomic) NavButtonStyle leftButtonStyle;

- (CGRect) setUpTopViewFrame;
- (UIView *) setUpTopView: (CGRect) frame;

- (UILabel *) defaultLabelWithFrame: (CGRect) frame
                        andString: (NSString *) string;

- (UITextField *) defaultTextFieldWithFrame: (CGRect) frame
                                placeholder: (NSString *) placeholder
                                    andText: (NSString *) text;

- (UISearchBar *) defaultSearchBarWithFrame: (CGRect) frame
                                placeholder: (NSString *) placeholder
                                    andText: (NSString *) text;

// if frame is nil then fit to title
- (UIButton *) defaultButtonWithFrame: (CGRect) frame
                                title: (NSString *) title
                         withSelector:(SEL) selector;

- (void) updateProperties;

- (void) updateRightNavButton;
- (void) updateLeftNavButton;

- (void) handleLeftNavButtonPress: (id) sender;
- (void) handleRightNavButtonPress: (id) sender;

+ (NSArray *) sortArrayOfString: (NSArray *) arrayOfString;

@end
