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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.myLocationEnabled = YES;
    
    self.mainCamera = [GMSCameraPosition cameraWithLatitude:40.741423 longitude:-73.989660 zoom:12];

    self.mapView.camera = self.mainCamera;
    self.mapView.delegate = self;
    
    GMSCoordinateBounds * bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:self.mainCamera.target coordinate:self.mainCamera.target];
    [self.mapView moveCamera:[GMSCameraUpdate fitBounds:bounds]];
    
    [self dropHardCodedPins];
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(MyCustomMarker *)marker {
   
    MarkerView * infoWindow = [[[NSBundle mainBundle]loadNibNamed:@"MarkerView" owner:self options:nil]objectAtIndex:0];
    
    if (marker.image == nil) {
        
        NSURL * URL = [NSURL URLWithString:marker.iconWebString];
        NSURLRequest * request = [NSURLRequest requestWithURL:URL];
        
        NSURLSession * session = [NSURLSession sharedSession];
        NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse *response, NSError * error) {
        
            if (error != nil) {
                NSLog(@"%@", error.localizedDescription);
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage * image = [UIImage imageWithData:data];
                marker.image = image;
                infoWindow.markerImage.image = marker.image;
            });
        }];
        
        [task resume];
    }
    
    infoWindow.markerTitle.text = marker.title;
    infoWindow.markerSubtitle.text = marker.snippet;
    infoWindow.markerImage.image = marker.image;

    return infoWindow;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(MyCustomMarker *)marker {
    WebViewController * webVC = [WebViewController new];

    if (marker.url == nil) {
        
        NSString * urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=AIzaSyCtiRMJNJQSyYZ94sivn6RxY7I2uHq68FQ", marker.placeID];
        
        NSURL * URL = [NSURL URLWithString:urlString];
        NSURLRequest * request = [NSURLRequest requestWithURL:URL];
        
        NSURLSession * session = [NSURLSession sharedSession];
        NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse *response, NSError * error) {
            
            if (error != nil) {
                NSLog(@"%@", error.localizedDescription);
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                
                NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                NSError * jsonError;
                NSDictionary * parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jsonError];
                NSString * string = parsedData[@"result"][@"website"];
                
                NSURL * url = [NSURL URLWithString:string];
                marker.url = url;
                webVC.url = marker.url;
            });
        }];
        
        [task resume];
    }
    
    webVC.url = marker.url;
    [self presentViewController:webVC animated:YES completion:nil];
}

- (void)dropHardCodedPins {

    __unused MyCustomMarker * tttMarker = [[MyCustomMarker alloc]initWithTitle:@"Turn to Tech"
                                                                       snippet:@"Learn, Build Apps, Get Hired"
                                                                         image:[UIImage imageNamed:@"ttt"]
                                                                           url:[NSURL URLWithString:@"http://www.turntotech.io"]
                                                                      position:self.mainCamera.target
                                                                           map:self.mapView];
    
    __unused MyCustomMarker * mozzarelliMarker = [[MyCustomMarker alloc]initWithTitle:@"Mozzarelli's"
                                                                              snippet:@"Gluten-Free Pizza"
                                                                                image:[UIImage imageNamed:@"mozzarelli"]
                                                                                  url:[NSURL URLWithString:@"http://www.mozzarellis.com/"]
                                                                             position:CLLocationCoordinate2DMake(40.7403711, -73.989601)
                                                                                  map:self.mapView];

    __unused MyCustomMarker * choptMarker = [[MyCustomMarker alloc]initWithTitle:@"Chop't"
                                                                         snippet:@"Creative Salad"
                                                                           image:[UIImage imageNamed:@"chopt"]
                                                                             url:[NSURL URLWithString:@"http://choptsalad.com/"]
                                                                        position:CLLocationCoordinate2DMake(40.7414436, -73.9944474)
                                                                             map:self.mapView];
    
    __unused MyCustomMarker * paneraMarker = [[MyCustomMarker alloc]initWithTitle:@"Panera"
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
    
    [self.searchBar resignFirstResponder];
    [[self view] endEditing:YES];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    CLLocationCoordinate2D location = self.mapView.camera.target;
    NSString * googleString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=1000&name=%@&sensor=true&key=AIzaSyCtiRMJNJQSyYZ94sivn6RxY7I2uHq68FQ", location.latitude, location.longitude, searchBar.text];
    
    NSURLSessionDataTask * googleData = [session dataTaskWithURL:[NSURL URLWithString:googleString] completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        
        if (error != nil) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Map Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
            
        }
        
        NSString * jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * jsonError;
        NSDictionary * parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jsonError];
        
        self.places = nil;
        self.places = parsedData[@"results"];

        if (self.places.count == 0) {
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"No Results" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView clear];
            for (int index = 0; index < self.places.count; index++) {

                NSString * title = self.places[index][@"name"];
                NSString * snippet = [NSString stringWithFormat:@"%@", self.places[index][@"rating"]];
                NSString * googlePlacesID = self.places[index][@"place_id"];
                NSString * icon = self.places[index][@"icon"];
                double lat = [self.places[index][@"geometry"][@"location"][@"lat"] floatValue];
                double lng = [self.places[index][@"geometry"][@"location"][@"lng"] floatValue];
                
                MyCustomMarker * newMarker = [[MyCustomMarker alloc]init];
                newMarker.title = title;
                newMarker.snippet = snippet;
                newMarker.position = CLLocationCoordinate2DMake(lat, lng);
                newMarker.placeID = googlePlacesID;
                newMarker.iconWebString = icon;
                newMarker.map = self.mapView;
            }
        });
    }];
        
    [googleData resume];
}

@end
