//
//  GoogleMapsViewController.h
//  myMapView
//
//  Created by Aditya Narayan on 6/14/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"

@import GoogleMaps;

@interface GoogleMapsViewController : UIViewController <GMSMapViewDelegate>

@property (strong, nonatomic) WebViewController * webObject;
@property (weak, nonatomic) IBOutlet GMSMapView * mapView;
@property (weak, nonatomic) IBOutlet UISearchBar * searchBar;
@property (nonatomic, retain) GMSCameraPosition * tttCamera;
@property (nonatomic, retain) GMSCameraPosition * mozzarelliCamera;
@property (nonatomic, retain) GMSCameraPosition * choptCamera;
@property (nonatomic, retain) GMSCameraPosition * paneraCamera;

- (IBAction)setMap:(id)sender;


@end
