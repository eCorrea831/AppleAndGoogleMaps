//
//  MyCustomAnnotation.h
//  myMapView
//
//  Created by Aditya Narayan on 6/13/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MyCustomAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain, nonnull) MKPointAnnotation * point;
@property (nonatomic, copy, nullable) NSString * title;
@property (nonatomic, copy, nullable) NSString * subtitle;
@property (nonatomic, retain, nonnull) UIImage * image;
@property (nonatomic, retain, nonnull) NSURL * url;

- (nonnull id)initWithLocation:(CLLocationCoordinate2D)coord point:(nonnull MKPointAnnotation *)point title:(nonnull NSString *)title subTitle:(nonnull NSString *)subTitle imageName:(nonnull NSString *)imageName url:(nonnull NSURL *)url;

@end
