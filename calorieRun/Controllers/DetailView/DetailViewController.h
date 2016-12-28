//
//  DetailViewController.h
//  calorieRun
//
//  Created by Gowthamraj K on 25/12/16.
//  Copyright © 2016 gowtham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetailItems.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "Coredata.h"
#import "ViewController.h"

@class ViewController;
@interface DetailViewController : UIViewController


#pragma mark - float
@property float latitude;
@property float longitude;
@property float lastLatitude;
@property float lastLongitude;

#pragma mark - NSInteger
@property NSInteger getIndexvalue;

#pragma mark - UILabel
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;

#pragma mark - UILabel



@property(nonatomic,retain)ViewController * controller;


@property (weak, nonatomic)  GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *googleView;

@property (retain, nonatomic) GMSPath *path12;

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@property (retain, nonatomic)  NSMutableArray *showUserDetailArray;
@property(nonatomic,retain)UserDetailItems * showUserDetail;




- (IBAction)backAction:(id)sender;
- (IBAction)deleteUserDetailAction:(id)sender;


@end
