//
//  EDMapViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/14/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDViewController.h"

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface EDMapViewController : EDViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) UISearchBar *mySearchBar;

@property (nonatomic, strong) MKMapView *myMapView;

@property (nonatomic, strong) CLLocationManager *myLocationManager;

@end
