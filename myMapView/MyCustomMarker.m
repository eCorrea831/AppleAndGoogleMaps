//
//  MyCustomMarker.m
//  myMapView
//
//  Created by Aditya Narayan on 6/15/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import "MyCustomMarker.h"

@implementation MyCustomMarker

- (instancetype)initWithTitle:(NSString *)title snippet:(NSString *)snippet image:(UIImage *)image url:(NSURL *)url position:(CLLocationCoordinate2D)position map:(GMSMapView *)map {
    
    self = [super init];
    
    self.title = title;
    self.snippet = snippet;
    self.position = position;
    self.map = map;
    _image = image;
    _url = url;
    
    return self;
}

@end
