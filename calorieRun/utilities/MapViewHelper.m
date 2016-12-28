//
//  MapViewHelper.m
//  calorieRun
//
//  Created by Pandimani on 26/12/16.
//  Copyright © 2016 gowtham. All rights reserved.
//

#import "MapViewHelper.h"
#import "GoogleViewController.h"
#import "ViewController.h"
#import "DetailViewController.h"

#define MAPZOOM 14

@implementation MapViewHelper

+ (MapViewHelper *)sharedInstance
{
    static MapViewHelper *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[MapViewHelper alloc] init];
    });
    return model;
}
#pragma mark - Maps  methods

- (GMSMapView *)createMapWithCoordinate:(CLLocationCoordinate2D)coordinate WithFrame:(CGRect)frame onTarget:(GoogleViewController *)objectname
{
 //   _gmapView.delegate = self;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:MAPZOOM];
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _gmapView = [GMSMapView mapWithFrame:frame camera:camera];
    _gmapView.myLocationEnabled = YES;
    
   // _gmapView.delegate = self;
    [objectname.googleView addSubview:_gmapView];
    return _gmapView;
}

- (GMSMapView *)showMapWithCoordinate:(float)latitude withLong:(float)longitude WithFrame:(CGRect)frame onTarget:(ViewController *)selfObject
{
    _gmapView.delegate = self;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:8];
    frame = CGRectMake(0, 0, selfObject.view.frame.size.width, frame.size.height);
    _gmapView = [GMSMapView mapWithFrame:frame camera:camera];
    _gmapView.myLocationEnabled = NO;
    
    _gmapView.delegate = self;
    [selfObject.googleView addSubview:_gmapView];
    return _gmapView;
}

- (GMSMapView *)showMapWithCoordinateInDetail:(CLLocationCoordinate2D)coordinate WithFrame:(CGRect)frame onTarget:(DetailViewController *)objectname
{
    _gmapView.delegate = self;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:MAPZOOM];
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _gmapView = [GMSMapView mapWithFrame:frame camera:camera];
    _gmapView.myLocationEnabled = NO;
    
    _gmapView.delegate = self;
    [objectname.googleView addSubview:_gmapView];
    return _gmapView;
}


#pragma mark - Image Processing for Marker Icon

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}


@end
