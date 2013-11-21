//
//  EDCreateRestaurantViewController.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/18/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDCreateRestaurantViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface EDCreateRestaurantViewController ()

@end

@implementation EDCreateRestaurantViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Map";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    self.rightButtonStyle = DoneButton;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    // Core Location --------
    if ([CLLocationManager locationServicesEnabled]) {
        [self startStandardUpdates];
    }
    
    else {
        /* Location services are not enabled.
         Take appropriate action: for instance, prompt the user to enable location services */
        NSLog(@"Location services are not enabled");
    }
    
    
    // Set Map View -------
    
}

- (BOOL) shouldAutorotate
{
    return YES;
}


- (CGRect) setUpTopViewFrame
{
    return [super setUpTopViewFrame];
}

- (UIView *) setUpTopView:(CGRect)frame
{
    UIView *tempView = [[UIView alloc] initWithFrame:frame];
    //NSLog(@"values (%f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    tempView.backgroundColor = TAN_BACKGROUND;
    tempView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // set up name text field
    CGFloat width = CGRectGetWidth(tempView.frame);
    CGRect textRect = CGRectMake(5.0, 5.0, width - 5.0, 30.0);
    self.nameTextField = [self defaultTextFieldWithFrame:textRect placeholder:@"name" andText:nil];
    [tempView addSubview:self.nameTextField];
    
    // set up search bar field
    CGRect searchBarRect = CGRectMake( 0.0, 35.0, width, 40.0);
    self.mySearchBar = [self defaultSearchBarWithFrame:searchBarRect placeholder:@"search" andText:nil];
    [tempView addSubview:self.mySearchBar];
    
    
    // set up map view
    CGRect mapRect = CGRectMake(CGRectGetMinX(tempView.bounds),
                                CGRectGetMaxY(searchBarRect),
                                CGRectGetMaxX(tempView.bounds),
                                CGRectGetMaxY(tempView.bounds) - CGRectGetMaxY(searchBarRect));
    
    self.myMapView = [[MKMapView alloc] initWithFrame:mapRect];
    
    // set the map type to satellite
    self.myMapView.mapType = MKMapTypeStandard;
    
    self.myMapView.delegate = self;
    
    self.myMapView.showsUserLocation = YES;
    
    self.myMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // add it to view
    [tempView addSubview:self.myMapView];
    
    CGRect trackRect = CGRectMake( 0.0, 200.0, 50.0, 40.0);
    
    UIButton *trackButton = [self defaultButtonWithFrame:trackRect title:@"track" withSelector:@selector(moveToCurrentLocation:)];
    [tempView addSubview:trackButton];
    return tempView;
}

- (void) moveToCurrentLocation: (id) sender
{
    [self.myLocationManager startUpdatingLocation];
}

#pragma mark - CLLocationManager and Delegate -

// standard location service
- (void) startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (self.myLocationManager == nil)
    {
        self.myLocationManager = [[CLLocationManager alloc] init];
        self.myLocationManager.delegate = self;
        
    }
    
    self.myLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    self.myLocationManager.distanceFilter = 500;
    
    [self.myLocationManager startUpdatingLocation];
}

// significant change location service
- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (self.myLocationManager == nil)
    {
        self.myLocationManager = [[CLLocationManager alloc] init];
    }
    
    self.myLocationManager.delegate = self;
    [self.myLocationManager startMonitoringSignificantLocationChanges];
}

- (void) locationManager:(CLLocationManager *)manager
      didUpdateLocations:(NSArray *)locations
{
    // If it's a relatively recent event, turn off updates to save power
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 1.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
        
        // check accuracy
        CLLocationAccuracy vertical = location.verticalAccuracy;
        CLLocationAccuracy horizontal = location.horizontalAccuracy;
        
        double radius = sqrt(vertical*vertical + horizontal*horizontal);
        
        NSLog(@"radius of accuracy is %f meters", radius);
        
        
        // update Map by setting region
        // make MKCoordinateRegion
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 5000.0, 5000.0);
        
        MKCoordinateRegion fittedRegion = [self.myMapView regionThatFits:region];
        
        [self.myMapView setRegion:fittedRegion animated:YES];
    }
    [manager stopUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager
        didFailWithError:(NSError *)error
{
    
}



#pragma mark - MKMapViewDelegate -

- (void) mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    
}

- (void) mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    
}


#pragma mark - Searching Methods -

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *s = searchBar.text;
    [searchBar resignFirstResponder];
    
    CLGeocoder *geo = [CLGeocoder new];
    
    [geo geocodeAddressString:s
            completionHandler:^(NSArray *placemarks, NSError *error) {
                
                if (placemarks == nil) {
                    NSLog(@"%@", error.localizedDescription);
                    return;
                }
                
                CLPlacemark *p = placemarks[0];
                MKPlacemark *mp = [[MKPlacemark alloc] initWithPlacemark:p];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.myMapView removeAnnotations:self.myMapView.annotations];
                    [self.myMapView addAnnotation:mp];
                    [self.myMapView setRegion:MKCoordinateRegionMakeWithDistance(mp.coordinate, 1000.0, 1000.0) animated:YES];
                });
            }];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


#pragma mark - Other Methods -

- (CLLocationCoordinate2D) getCurrentLocation
{
    return self.myLocationManager.location.coordinate;
}

@end
