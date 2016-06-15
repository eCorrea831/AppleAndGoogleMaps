//
//  GoogleMapsViewController.m
//  myMapView
//
//  Created by Aditya Narayan on 6/14/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import "GoogleMapsViewController.h"
#import "MarkerView.h"

@interface GoogleMapsViewController ()

@end

@implementation GoogleMapsViewController

/*
 TODO:
 - add logo to pin
 - add info button to pin
 - have info button take you to webVC
 - get some restaurants from Google Places
 - utilize search bar instead
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tttCamera = [GMSCameraPosition cameraWithLatitude:40.741423 longitude:-73.989660 zoom:12];
    self.mozzarelliCamera = [GMSCameraPosition cameraWithLatitude:40.7403711 longitude:-73.989601 zoom:12];
    self.choptCamera = [GMSCameraPosition cameraWithLatitude:40.7414436 longitude:-73.9944474 zoom:12];
    self.paneraCamera = [GMSCameraPosition cameraWithLatitude:40.7425649 longitude:-73.9929699 zoom:12];

    self.mapView.camera = self.tttCamera;
    self.mapView.delegate = self;
    
    GMSCoordinateBounds * bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:self.tttCamera.target coordinate:self.tttCamera.target];
    [self.mapView moveCamera:[GMSCameraUpdate fitBounds:bounds]];
    
    [self dropHardCodedPins];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView*)mapView:(GMSMapView*)mapView markerInfoWindow:(GMSMarker *)marker {
   
    MarkerView * infoWindow = [[[NSBundle mainBundle]loadNibNamed:@"MarkerView" owner:self options:nil]objectAtIndex:0];
    
    infoWindow.markerTitle.text = marker.title;
    infoWindow.markerSubtitle.text = marker.snippet;
    infoWindow.markerImage.image= [UIImage imageNamed:@"icon_my"];
    
    return infoWindow;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    
    self.webObject = [[WebViewController alloc]initWithNibName:@"webController" bundle:nil];
    [self.navigationController pushViewController:self.webObject animated:YES];
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
    
    //ttt
    GMSMarker * tttMarker = [[GMSMarker alloc]init];
    tttMarker.position = self.tttCamera.target;
    tttMarker.title = @"Turn to Tech";
    tttMarker.snippet = @"Learn, Build Apps, Get Hired";
    tttMarker.map = self.mapView;
    
    //mozzarelli
    GMSMarker * mozzarelliMarker = [[GMSMarker alloc]init];
    mozzarelliMarker.position = self.mozzarelliCamera.target;
    mozzarelliMarker.title = @"Mozzarelli's";
    mozzarelliMarker.snippet = @"Gluten-Free Pizza";
    mozzarelliMarker.map = self.mapView;
    
    //chopt
    GMSMarker * choptMarker = [[GMSMarker alloc]init];
    choptMarker.position = self.choptCamera.target;
    choptMarker.title = @"Chop't";
    choptMarker.snippet = @"Creative Salad";
    choptMarker.map = self.mapView;
    
    //panera
    GMSMarker * paneraMarker = [[GMSMarker alloc]init];
    paneraMarker.position = self.paneraCamera.target;
    paneraMarker.title = @"Panera";
    paneraMarker.snippet = @"Bakers of Bread, Fresh from the Oven.";
    paneraMarker.map = self.mapView;

// imageName:@"ttt" url:[NSURL URLWithString:@"http://www.turntotech.io"]];
// imageName:@"mozzarelli" url:[NSURL URLWithString:@"http://www.mozzarellis.com/"]];
// imageName:@"chopt" url:[NSURL URLWithString:@"http://choptsalad.com/"]];
// imageName:@"panera" url:[NSURL URLWithString:@"https://www.panerabread.com/en-us/home.html"]];
}

@end
