//
//  MyCustomMarker.h
//  myMapView
//
//  Created by Aditya Narayan on 6/15/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@interface MyCustomMarker : GMSMarker

@property (nonatomic, retain) UIImage * image;
@property (nonatomic, retain) NSURL * url;

- (instancetype)initWithTitle:(NSString *)title snippet:(NSString *)snippet image:(UIImage *)image url:(NSURL *)url position:(CLLocationCoordinate2D)position map:(GMSMapView *)map;

@end
