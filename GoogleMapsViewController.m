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
    
    infoWindow.markerTitle.text = marker.title;
    infoWindow.markerSubtitle.text = marker.snippet;
    infoWindow.markerImage.image = marker.image;
    
    return infoWindow;
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(MyCustomMarker *)marker {

    //if url == "" do another nsurlsession to look up website by id # then assign url
    
    WebViewController * webVC = [WebViewController new];
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
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    CLLocationCoordinate2D location = self.mapView.camera.target;
    NSString * googleString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=1000&types=%@&name=&key=AIzaSyCtiRMJNJQSyYZ94sivn6RxY7I2uHq68FQ", location.latitude, location.longitude, searchBar.text];
    
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
        
        NSArray * places = parsedData[@"results"];

        if (places.count == 0) {
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"No Results" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }

        for (int index = 1; index < places.count; index++) {
            
            //TODO:clear array with each new search
            //TODO:change to NSURLSession
            //TODO:add another NSURLSession for the website
            NSURL * iconURL = [NSURL URLWithString:places[index][@"icon"]];
            NSData * imageData = [[NSData alloc]initWithContentsOfURL:iconURL];
            
            NSString * title = places[index][@"name"];
            NSString * snippet = [NSString stringWithFormat:@"%@", places[index][@"rating"]];
            NSString * googlePlacesID = places[index][@"id"];
            double lat = [places[index][@"geometry"][@"location"][@"lat"] floatValue];
            double lng = [places[index][@"geometry"][@"location"][@"lng"] floatValue];
            
            MyCustomMarker * newMarker = [[MyCustomMarker alloc]initWithTitle:title
                                                                      snippet:snippet
                                                                        image:[UIImage imageWithData:imageData]
                                                                          url:[NSURL URLWithString:@""]
                                                                     position:CLLocationCoordinate2DMake(lat,lng)
                                                                          map:self.mapView];
            newMarker.placeID = googlePlacesID;
            
        }
    }];
        
    [googleData resume];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self.searchBar resignFirstResponder];
//    [[self view] endEditing:YES];
//}

@end
