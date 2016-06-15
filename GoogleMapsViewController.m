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

//TODO:get some restaurants from Google Places
//TODO:utilize search bar instead

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

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(MyCustomMarker *)marker {

    WebViewController * webVC = [WebViewController new];
    webVC.url = marker.url;
    [self presentViewController:webVC animated:YES completion:nil];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSString * googleString = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670,151.1957&radius=500&types=food&name=cruise&key=AIzaSyB3T80fXQmEsfGIzlP5KBnKYUqXi3nXXoE";
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * googleData = [session dataTaskWithURL:[NSURL URLWithString:googleString] completionHandler:^(NSData * data, NSURLResponse *response, NSError * error) {
        
        NSString * csv = [[NSString alloc] initWithData:googleData encoding:NSUTF8StringEncoding];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [companyVC.collectionView reloadData];
//        });
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.searchBar resignFirstResponder];
    [[self view] endEditing:YES];
}


@end
