//
//  GoogleViewController.h
//  calorieRun
//
//  Created by Gowthamraj K on 24/12/16.
//  Copyright © 2016 gowtham. All rights reserved.

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <HealthKit/HealthKit.h>



@interface GoogleViewController : UIViewController<CLLocationManagerDelegate>


#pragma mark - NSString
@property (retain, nonatomic) NSString * updateTime ;
@property (retain, nonatomic) NSString * UserLatitude ;
@property (retain, nonatomic) NSString * UserLongitude;
@property (retain, nonatomic) NSString * UserLastLatitude;
@property (retain, nonatomic) NSString * UserLastLongitude;
@property (retain, nonatomic) NSString * updatecalorie ;
@property (retain, nonatomic) NSString * updateweight ;


#pragma mark - NSInteger
@property  NSInteger userweight ;



#pragma mark - NSTimer
@property (retain,nonatomic)NSTimer * stopTimer;

#pragma mark - NSDate
@property (retain,nonatomic)NSDate * startDate;

#pragma mark - BOOL
@property  BOOL running;

#pragma mark - double
@property (nonatomic) double totalCalories;

#pragma mark - NSMutableArray
@property (retain,nonatomic)NSMutableArray * points;


#pragma mark - CLLocationManager
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

#pragma mark - UILabel
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;

#pragma mark - UIButton
@property (weak, nonatomic) IBOutlet UIButton *navigationButtion;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;

#pragma mark - UIView
@property (strong, nonatomic) IBOutlet UIView *weightView;
@property (weak, nonatomic) IBOutlet UIView *googleView;

#pragma mark - GMSMapView
@property (retain, nonatomic)  GMSMapView *mapView;


#pragma mark - ButtionAction
- (IBAction)MyLocationAction:(id)sender;
- (IBAction)weightAddAction:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)startTimerAction:(id)sender;
- (IBAction)resetTimerAction:(id)sender;
- (IBAction)saveUserDetailAction:(id)sender;
- (IBAction)closeButtonAction:(id)sender;
- (IBAction)weightAnimation:(id)sender;

#pragma mark - ButtionAction
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;












@end
