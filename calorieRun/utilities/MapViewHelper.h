//
//  MapViewHelper.h
//  calorieRun
//
//  Created by Pandimani on 26/12/16.
//  Copyright © 2016 gowtham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "ViewController.h"

@interface MapViewHelper : NSObject <GMSMapViewDelegate>

@property (nonatomic, strong) GMSMapView *gmapView;

+ (MapViewHelper *)sharedInstance;


- (GMSMapView *)createMapWithCoordinate:(CLLocationCoordinate2D)coordinate WithFrame:(CGRect)frame onTarget:(UIViewController *)selfObject;

- (GMSMapView *)showMapWithCoordinate:(float)latitude withLong:(float)longitude WithFrame:(CGRect)frame onTarget:(UIViewController *)selfObject;

- (GMSMapView *)showMapWithCoordinateInDetail:(CLLocationCoordinate2D)coordinate WithFrame:(CGRect)frame onTarget:(UIViewController *)selfObject;

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size;


@end
