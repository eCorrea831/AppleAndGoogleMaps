//
//  MapKitViewController.h
//  myMapView
//
//  Created by Aditya Narayan on 6/13/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyCustomAnnotation.h"

@interface MapKitViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, retain) IBOutlet MKMapView * mapView;
@property (weak, nonatomic) IBOutlet UISearchBar * searchBar;

- (IBAction)setMap:(id)sender;

@end

