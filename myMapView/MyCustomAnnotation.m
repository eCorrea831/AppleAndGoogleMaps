//
//  MyCustomAnnotation.m
//  myMapView
//
//  Created by Aditya Narayan on 6/13/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import "MyCustomAnnotation.h"

@implementation MyCustomAnnotation

@synthesize coordinate;

- (nonnull id)initWithLocation:(CLLocationCoordinate2D)coord point:(nonnull MKPointAnnotation *)point title:(nonnull NSString *)title subTitle:(nonnull NSString *)subTitle imageName:(nonnull NSString *)imageName url:(nonnull NSURL *)url {
    
    self = [super init];
    if (self) {
        coordinate = coord;
        _point = point;
        _title = title;
        _subtitle = subTitle;
        _image = [UIImage imageNamed:imageName];
        _url = url;

    }
    return self;
}

@end
