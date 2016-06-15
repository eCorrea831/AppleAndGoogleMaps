//
//  GoogleMapsViewController.m
//  myMapView
//
//  Created by Aditya Narayan on 6/14/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import "GoogleMapsViewController.h"
#import "MarkerView.h"
#import "MyCustomMarker.h"

@interface GoogleMapsViewController ()

@end

@implementation GoogleMapsViewController

/*
 TODO:
 - get some restaurants from Google Places
 - utilize search bar instead
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainCamera = [GMSCameraPosition cameraWithLatitude:40.741423 longitude:-73.989660 zoom:12];

    self.mapView.camera = self.mainCamera;
    self.mapView.delegate = self;
    
    GMSCoordinateBounds * bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:self.mainCamera.target coordinate:self.mainCamera.target];
    [self.mapView moveCamera:[GMSCameraUpdate fitBounds:bounds]];
    
    [self dropHardCodedPins];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(MyCustomMarker *)marker {
   
    MarkerView * infoWindow = [[[NSBundle mainBundle]loadNibNamed:@"MarkerView" owner:self options:nil]objectAtIndex:0];
    
    infoWindow.markerTitle.text = marker.title;
    infoWindow.markerSubtitle.text = marker.snippet;
    infoWindow.markerImage.image = marker.image;
    
    return infoWindow;
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {

    WebViewController * webVC = [WebViewController new];
    webVC.url = [NSURL URLWithString:@"http://www.google.com"];
    [self presentViewController:webVC animated:YES completion:nil];
}

- (IBAction)setMap:(id)sender {
    
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = kGMSTypeNormal;
            break;
        case 1:
            self.mapView.mapType = kGMSTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = kGMSTypeHybrid;
            break;
        default:
            break;
    }
}

- (void)dropHardCodedPins {

    MyCustomMarker * tttMarker = [[MyCustomMarker alloc]initWithTitle:@"Turn to Tech"
                                                              snippet:@"Learn, Build Apps, Get Hired"
                                                                image:[UIImage imageNamed:@"ttt"]
                                                                  url:[NSURL URLWithString:@"http://www.turntotech.io"]
                                                             position:self.mainCamera.target
                                                                  map:self.mapView];
    
    MyCustomMarker * mozzarelliMarker = [[MyCustomMarker alloc]initWithTitle:@"Mozzarelli's"
                                                                     snippet:@"Gluten-Free Pizza"
                                                                       image:[UIImage imageNamed:@"mozzerelli"]
                                                                         url:[NSURL URLWithString:@"http://www.mozzarellis.com/"]
                                                                    position:CLLocationCoordinate2DMake(40.7403711, -73.989601)
                                                                         map:self.mapView];

    MyCustomMarker * choptMarker = [[MyCustomMarker alloc]initWithTitle:@"Chop't"
                                                                snippet:@"Creative Salad"
                                                                  image:[UIImage imageNamed:@"chopt"]
                                                                    url:[NSURL URLWithString:@"http://choptsalad.com/"]
                                                               position:CLLocationCoordinate2DMake(40.7414436, -73.9944474)
                                                                    map:self.mapView];
    
    MyCustomMarker * paneraMarker = [[MyCustomMarker alloc]initWithTitle:@"Panera"
                                                                 snippet:@"Bakers of Bread, Fresh from the Oven."
                                                                   image:[UIImage imageNamed:@"panera"]
                                                                     url:[NSURL URLWithString:@"https://www.panerabread.com/en-us/home.html"]
                                                                position:CLLocationCoordinate2DMake(40.7425649, -73.9929699)
                                                                     map:self.mapView];
}

@end
