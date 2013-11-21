//
//  EDViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/8/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDViewController.h"

@interface EDViewController ()

@end

@implementation EDViewController

#pragma mark - UIView methods -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(handleKeyboardWillShow:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(handleKeyboardWillHide:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateProperties];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// SUBCLASS
//// when subclassing
////    - set right and left nav bar BEFORE calling [super VDL]
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateRightNavButton];
    [self updateLeftNavButton];
    
    // create and set up the main view and add as subview
    self.topView = [self setUpTopView:[self setUpTopViewFrame]];
    
    [self.view addSubview:self.topView];
}


#pragma mark - Display Set Up methods -

// SUBCLASS - redefine the bounds
//      - gets called in viewDidLoad
- (CGRect) setUpTopViewFrame {
    return self.view.bounds;
}

- (UIView *) setUpTopView: (CGRect) frame {
    UIView *tempView = [[UIView alloc] initWithFrame:frame];
    tempView.backgroundColor = TAN_YELLOW_BACKGROUND;
    tempView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    return tempView;
}


- (void) updateProperties
{
    // override in subclass
}

- (void) updateRightNavButton
{
    if (self.rightButtonStyle == NoButton) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    else if (self.rightButtonStyle == DoneButton) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                     target:self
                                                                                     action:@selector(handleRightNavButtonPress:)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    else if (self.rightButtonStyle == AcceptButton) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Accept" style:UIBarButtonItemStyleDone target:self action:@selector(handleRightNavButtonPress:)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    else if (self.rightButtonStyle == UpdateButton) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStyleDone target:self action:@selector(handleRightNavButtonPress:)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    else if (self.rightButtonStyle == PlusButton) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                     target:self
                                                                                     action:@selector(handleRightNavButtonPress:)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    else if (self.rightButtonStyle == NextButton) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered                                                              target:self action:@selector(handleRightNavButtonPress:)];
        
        self.navigationItem.rightBarButtonItem = rightButton;
    }
}

- (void) updateLeftNavButton
{
    if (self.leftButtonStyle == NoButton) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    else if (self.leftButtonStyle == PlusButton) {
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                    target:self
                                                                                    action:@selector(handleLeftNavButtonPress:)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    else if (self.leftButtonStyle == CameraButton) {
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                    target:self
                                       
                                                                                    action:@selector(handleLeftNavButtonPress:)];
        
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    else if (self.leftButtonStyle == CancelButton) {
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(handleLeftNavButtonPress:)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    else if (self.leftButtonStyle == BackButton) {
        
    }
}


// SHOULD OVERRIDE WHEN SUBCLASSING
- (void) handleRightNavButtonPress: (id) sender {
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void) handleLeftNavButtonPress: (id) sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Default objects

/// Default label setup
- (UILabel *) defaultLabelWithFrame:(CGRect)frame andString:(NSString *)string {
    
    UILabel *label = nil;
    
    if (!CGRectIsEmpty(frame)) {
        label = [[UILabel alloc] initWithFrame:frame];
    }
    else {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.topView.bounds.size.width, 45.0f)];
    }
    
    label.text = string;
    
    return label;
}

/// Default Text Field creation

// if the user uses a textField, this launches if the user presses return, and resigns the keyboard
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// make a text field
- (UITextField *) defaultTextFieldWithFrame:(CGRect)frame
                                placeholder:(NSString *)placeholder
                                    andText:(NSString *)text
{
    CGRect textFrame = frame;
    
    if (CGRectIsEmpty(textFrame)) {
        textFrame = CGRectMake(30.0f, 5.0f, 260.0f, 31.0f);
    }
    
    UITextField * defaultTextField = [[UITextField alloc] initWithFrame:textFrame];
    
    defaultTextField.backgroundColor = DEFAULT_TEXTFIELD_BACKGROUND;
    defaultTextField.placeholder = placeholder;
    //defaultTextField.text = text;
    defaultTextField.delegate = self;
    defaultTextField.returnKeyType = UIReturnKeyDone;
    defaultTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    return defaultTextField;
}

- (UISearchBar *) defaultSearchBarWithFrame: (CGRect) frame
                                placeholder: (NSString *) placeholder
                                    andText: (NSString *) text
{
    CGRect searchFrame = frame;
    
    if (CGRectIsEmpty(searchFrame)) {
        searchFrame = CGRectMake(30.0f, 5.0f, 260.0f, 31.0f);
    }
    
    UISearchBar * defaultSearchBar = [[UISearchBar alloc] initWithFrame:searchFrame];
    
    defaultSearchBar.backgroundColor = DEFAULT_TEXTFIELD_BACKGROUND;
    defaultSearchBar.placeholder = placeholder;
    //defaultTextField.text = text;
    defaultSearchBar.delegate = self;
    defaultSearchBar.showsBookmarkButton = NO;
    defaultSearchBar.showsCancelButton = YES;

    
    return defaultSearchBar;
}

// if frame is nil then fit to title
- (UIButton *) defaultButtonWithFrame: (CGRect) frame
                                title: (NSString *) title
                         withSelector:(SEL) selector
{
    CGRect buttonFrame = frame;
    
    if (CGRectIsEmpty(buttonFrame)) {
        buttonFrame = CGRectMake(0.0f, 5.0f, 50.0f, 30.0f);
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button setFrame:buttonFrame];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


+ (NSArray *) sortArrayOfString: (NSArray *) arrayOfString
{
    return [arrayOfString sortedArrayUsingComparator:
            ^(id obj1, id obj2) {
                return [obj1 caseInsensitiveCompare:obj2];
            }];
}


#pragma mark - UITextFieldDelegate and Keyboard Methods-

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    
}

// launches when a keyboard shows on screen,
// - this is to adjust the screen to view the table
- (void) handleKeyboardWillShow: (NSNotification *) paramNotification {
    
    
    
    NSDictionary *userInfo = [paramNotification userInfo];
    
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *animationDurationObject = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *keyboardEndRectObject = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    
    NSUInteger animationCurve = 0;
    double animationDuration = 0.0f;
    CGRect keyboardEndRect = CGRectMake(0, 0, 0, 0);
    
    [animationCurveObject getValue:&animationCurve];
    [animationDurationObject getValue:&animationDuration];
    [keyboardEndRectObject getValue:&keyboardEndRect];
    
    [UIView beginAnimations:@"changeTableViewContentInset" context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    
    //CGRect intersectionOfTopViewAndKeyboardRect = CGRectIntersection(self.topView.frame, keyboardEndRect);
    
    /*
    CGFloat navBarHeight = 0.0f;
    if (self.navigationController) {
        navBarHeight = self.navigationController.navigationBar.frame.size.height;
    }
    
    CGFloat statusBarHeight = 0.0f;
    if (![UIApplication sharedApplication].statusBarHidden) {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    CGFloat tableInset = intersectionOfTopViewAndKeyboardRect.size.height + navBarHeight + statusBarHeight;
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, tableInset, 0.0f);
    */
     
     
    //NSIndexPath *indexPathOfOwnerCell = nil;
    
    // Also, make sure the selected text field is visible on the screen 
    //NSInteger numberOfCells = [self.stTableView.dataSource tableView:self.stTableView numberOfRowsInSection:0];
    
    /* So let's go through all the cells and find their accessory text fields. Once we have the reference to those text fields, we can see which one of them is the first responder (has the keyboard) and we will make a call
     to the table view to make sure that, after the keyboard is displayed, that specific cell is NOT obstructed by the keyboard */
    /*
     for (NSInteger counter = 0; counter < numberOfCells; counter++){
     
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:counter inSection:0];
     UITableViewCell *cell = [self.stTableView cellForRowAtIndexPath:indexPath];
     UITextField *textField = (UITextField *)cell.accessoryView;
     if ([textField isKindOfClass:[UITextField class]] == NO){
     continue;
     }
     if ([textField isFirstResponder]){ indexPathOfOwnerCell = indexPath;
     break;
     }
     }
     */
    
    
    [UIView commitAnimations];
    /*
     if (indexPathOfOwnerCell != nil){
     [self.stTableView scrollToRowAtIndexPath:indexPathOfOwnerCell
     atScrollPosition:UITableViewScrollPositionMiddle
     animated:YES];
     }
     */
}

- (void) handleKeyboardWillHide:(NSNotification *)paramNotification
{
    /*
    if (UIEdgeInsetsEqualToEdgeInsets(self.tableView.contentInset, UIEdgeInsetsZero)){
        // Our table view's content inset is intact so no need to reset it 
        return; }
    NSDictionary *userInfo = [paramNotification userInfo]; NSValue *animationCurveObject =
    [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey]; NSValue *animationDurationObject =
    [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey]; NSValue *keyboardEndRectObject =
    [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey]; NSUInteger animationCurve = 0;
    
    double animationDuration = 0.0f;
    CGRect keyboardEndRect = CGRectMake(0, 0, 0, 0);
    [animationCurveObject getValue:&animationCurve]; [animationDurationObject getValue:&animationDuration]; [keyboardEndRectObject getValue:&keyboardEndRect]; [UIView beginAnimations:@"changeTableViewContentInset"
                                                                                                                                                                               context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve]; self.tableView.contentInset = UIEdgeInsetsZero;
    */
    
    [UIView commitAnimations];
}
@end
