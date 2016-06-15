//
//  MapKitViewController.m
//  myMapView
//
//  Created by Aditya Narayan on 6/13/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import "MapKitViewController.h"
#import "WebViewController.h"

@interface MapKitViewController ()

@end

@implementation MapKitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

#pragma mark - Set Different type of map
- (IBAction)setMap:(id)sender {
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
 
    [self setTTTPin];
    [self setMozzarelliPin];
    [self setChoptPin];
    [self setPaneraPin];
    
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"Location: %f, %f",
          userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
}

- (void)setTTTPin {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(40.741423, -73.989660);
    MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
    
    MyCustomAnnotation * tttAnnotation = [[MyCustomAnnotation alloc]initWithLocation:coordinate point:point title:@"TurnToTech" subTitle:@"Learn, Build Apps, Get Hired" imageName:@"ttt" url:[NSURL URLWithString:@"http://www.turntotech.io"]];
    
    [self.mapView addAnnotation:tttAnnotation];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 250, 250);
    [self.mapView setRegion:region animated:YES];
}

- (void)setMozzarelliPin {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(40.7403711, -73.989601);
    MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
    
    MyCustomAnnotation * mozzAnnotation = [[MyCustomAnnotation alloc]initWithLocation:coordinate point:point title:@"Mozzarelli's" subTitle:@"Gluten Free Pizza" imageName:@"mozzarelli" url:[NSURL URLWithString:@"http://www.mozzarellis.com/"]];
    
    [self.mapView addAnnotation:mozzAnnotation];
}

- (void)setChoptPin {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(40.7414436, -73.9944474);
    MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
    
    MyCustomAnnotation * choptAnnotation = [[MyCustomAnnotation alloc]initWithLocation:coordinate point:point title:@"Chop't" subTitle:@"Creative Salad" imageName:@"chopt" url:[NSURL URLWithString:@"http://choptsalad.com/"]];
    
    [self.mapView addAnnotation:choptAnnotation];
}

- (void)setPaneraPin {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(40.7425649, -73.9929699);
    MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
    
    MyCustomAnnotation * paneraAnnotation = [[MyCustomAnnotation alloc]initWithLocation:coordinate point:point title:@"Panera Bread" subTitle:@"Bakers of bread. Fresh from the oven." imageName:@"panera" url:[NSURL URLWithString:@"https://www.panerabread.com/en-us/home.html"]];
    
    [self.mapView addAnnotation:paneraAnnotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView * pinView = [[MKPinAnnotationView alloc ]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
    
    UIButton * rbutton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rbutton setTitle:annotation.title forState:UIControlStateNormal];
    pinView.rightCalloutAccessoryView = rbutton;
    
    if ([annotation respondsToSelector:@selector(image)]) {
        UIImageView * temp = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, pinView.frame.size.height - 10, pinView.frame.size.height - 10)];
        
        temp.image = [annotation performSelector:@selector(image)];
        pinView.leftCalloutAccessoryView = temp;
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    if ([view.annotation respondsToSelector:@selector(url)]) {
        
        NSURL * url = [view.annotation performSelector:@selector(url)];
        WebViewController * webVC = [WebViewController new];
        webVC.url = url;
        [self presentViewController:webVC animated:YES completion:nil];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    MKLocalSearchRequest * request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.searchBar.text;
    request.region = self.mapView.region;
    
    MKLocalSearch * localSearch = [[MKLocalSearch alloc]initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse * response, NSError * error) {
        NSLog(@"Map Items: %@", response.mapItems);
        
        if (error != nil) {
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Map Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
        
        if ([response.mapItems count] == 0) {
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"No Results" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        for (MKMapItem * item in response.mapItems) {
            
            CLLocationCoordinate2D coordinate = item.placemark.coordinate;
            MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
            
            MyCustomAnnotation * annotation = [[MyCustomAnnotation alloc]initWithLocation:coordinate point:point title:item.name subTitle:item.phoneNumber imageName:@"default" url:item.url];
            
            [self.mapView addAnnotation:annotation];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.searchBar resignFirstResponder];
    [[self view] endEditing:YES];
}

@end
