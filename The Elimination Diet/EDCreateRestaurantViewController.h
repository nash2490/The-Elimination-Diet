//
//  EDCreateRestaurantViewController.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 9/18/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDViewController.h"
#import <MapKit/MapKit.h>

@class MKMapView, CLLocationManager;

@interface EDCreateRestaurantViewController : EDViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UISearchBar *mySearchBar;

@property (nonatomic, strong) MKMapView *myMapView;

@property (nonatomic, strong) CLLocationManager *myLocationManager;

@end
