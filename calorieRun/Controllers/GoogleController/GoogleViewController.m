//
//  GoogleViewController.m
//  GMASA
//
//  Created by Gowthamraj K on 01/09/15.
//  Copyright (c) 2015 Gowthamraj K. All rights reserved.
//

#import "GoogleViewController.h"
#import "MapViewHelper.h"



@interface GoogleViewController ()
{
    float latitude ,longitude , lastlatitude,lastlongitude ;
    NSString *GoogleMapDistance;

}

@end

@implementation GoogleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _running = FALSE;
    _startDate = [NSDate date];
    
    
    _weightView.hidden = YES;
    
    
    if([CLLocationManager locationServicesEnabled]){
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.activityType = CLActivityTypeOtherNavigation;
       // _locationManager.allowsBackgroundLocationUpdates = YES;
         _locationManager.delegate = self;
       
        
        CLLocationCoordinate2D setLocation = _locationManager.location.coordinate;
        _mapView = [[MapViewHelper sharedInstance]createMapWithCoordinate:setLocation WithFrame:self.view.frame onTarget:self];
        [_mapView addSubview:_navigationButtion];
      
        
        
        
    }else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Calorie Run"
                                     message:@"TLocation services are disabled."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                        
                                        
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    if (newLocation.horizontalAccuracy > 10 || newLocation.horizontalAccuracy <= 0) {
        return;
    }
    
    double oldAltitude = oldLocation.altitude;
    double currentAltitude = newLocation.altitude;
    double metersTraveled = [newLocation distanceFromLocation:oldLocation];
    
    double grade = (fabs((currentAltitude - oldAltitude)) / metersTraveled);
    if (isnan(grade) || isinf(grade)) {
        grade = 0;
    }
    if  (isnan(metersTraveled)){
        metersTraveled = 0;
    }
    double timeDifference = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
    if (timeDifference <= 0 || isnan(timeDifference) || isinf(timeDifference)) {
        return;
    }
    
    double metersPerMinute = (metersTraveled / timeDifference) * 60;
    double milesPerHour = (1/26.8224) * metersPerMinute;
    double milesPerMinute = milesPerHour / 60;
    double minutesPerMile = 1/milesPerMinute;
    if (isnan(minutesPerMile) || isinf(minutesPerMile)) {
        minutesPerMile = 0;
    }
    
    
    double VO = (3.5 + ((metersPerMinute * 0.2) + (metersPerMinute * grade * 0.9)));
    double METS = VO / 3.5;
    _userweight = [[[NSUserDefaults standardUserDefaults]valueForKey:@"weight"]integerValue];
    double caloriesPerHour = METS *( _userweight * 0.453592);
    
    double caloriesPerSecond = ((caloriesPerHour / 60) / 60);
    
    
    self.totalCalories += (timeDifference * caloriesPerSecond);
   
    
   self.calorieLabel.text = [NSString stringWithFormat:@"%d", (int) self.totalCalories];


        
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTimer{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:_startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    _timerLabel.text = timeString;
}


#pragma mark - UIButtonAction

- (IBAction)MyLocationAction:(id)sender {
    
    [_mapView animateToLocation:_locationManager.location.coordinate];
}

- (IBAction)weightAddAction:(id)sender {
    
    _updateweight = _weightTextField.text;
    
    if(_updateweight.length == 0)
    {
        
    }else
    {
        [[NSUserDefaults standardUserDefaults]setValue:_updateweight forKey:@"weight"];
        [_weightTextField resignFirstResponder];
        _weightView.hidden = YES;
    }
    
    
}

- (IBAction)backAction:(id)sender {
    
  
    [self.navigationController popViewControllerAnimated:YES];

}


- (IBAction)startTimerAction:(id)sender {
    if(!_running){
        _userweight = [[[NSUserDefaults standardUserDefaults]valueForKey:@"weight"]integerValue];
        if(_userweight == 0)
        {
            _weightView.hidden = NO;
            
            [UIView animateWithDuration:0.9 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _weightView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 120);
            }
                             completion:^(BOOL finished)
             {
                 
             }];

        }else
        {
        
        latitude = _locationManager.location.coordinate.latitude;
        longitude = _locationManager.location.coordinate.longitude;
        
         [self.locationManager startUpdatingLocation];
        _resetButton.userInteractionEnabled = NO;
        _running = TRUE;
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        if (_stopTimer == nil) {
            _stopTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                          target:self
                                                        selector:@selector(updateTimer)
                                                        userInfo:nil
                                                         repeats:YES];
        }
        }
    }else{
        
        lastlatitude = _locationManager.location.coordinate.latitude;
        lastlongitude = _locationManager.location.coordinate.longitude;
        
        [self.locationManager stopUpdatingLocation];
        _resetButton.userInteractionEnabled = YES;
        _running = FALSE;
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        [_stopTimer invalidate];
        _stopTimer = nil;
    }
}

- (IBAction)resetTimerAction:(id)sender {
    
    
    
    [_stopTimer invalidate];
    _stopTimer = nil;
    _startDate = [NSDate date];
    _timerLabel.text = @"00:00:00";
    _running = FALSE;
    _calorieLabel.text = @"0";
}

- (IBAction)saveUserDetailAction:(id)sender {
    _updateTime = _timerLabel.text;
    
    if(latitude == 0 && longitude == 0 && [_updateTime isEqualToString:@"00:00:00"])
    {
        
    }else
    {
        if(lastlatitude == 0 && lastlatitude == 0)
        {
        lastlatitude = _locationManager.location.coordinate.latitude;
        lastlongitude = _locationManager.location.coordinate.longitude;
        }
        
        [_stopTimer invalidate];
        _stopTimer = nil;
        _running = FALSE;
        
         [self.locationManager stopUpdatingLocation];
        
     
     _UserLatitude = [NSString stringWithFormat:@"%f",latitude];
     _UserLongitude = [NSString stringWithFormat:@"%f",longitude];
     _UserLastLatitude = [NSString stringWithFormat:@"%f",lastlatitude];
     _UserLastLongitude = [NSString stringWithFormat:@"%f",lastlongitude];
     _updatecalorie = _calorieLabel.text;
        
          [self fetchDistance:_UserLatitude origin:_UserLongitude destinationlat:_UserLastLatitude destinationlong:_UserLastLongitude];
        
    

    }

    
}

- (IBAction)closeButtonAction:(id)sender {
    
    [_weightTextField resignFirstResponder];
    _weightView.hidden = YES;
}

- (IBAction)weightAnimation:(id)sender {
    
  _userweight = [[[NSUserDefaults standardUserDefaults]valueForKey:@"weight"]integerValue];
if(_userweight !=0)
{
    _weightTextField.text = [NSString stringWithFormat:@"%ld",(long)_userweight];
}
    _weightView.hidden = NO;
    
    [UIView animateWithDuration:0.9 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _weightView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 120);
    }
                     completion:^(BOOL finished)
     {
         
     }];
    

}

#pragma mark - getDistanceService

- (void)fetchDistance:(NSString *)originlatitude origin:(NSString * )orginlongitude destinationlat:(NSString *) destinationlatitude destinationlong:(NSString *) destinationlongitude
{
    NSString *originString = [NSString stringWithFormat:@"%@,%@",originlatitude, orginlongitude];
    NSString *destinationString = [NSString stringWithFormat:@"%@,%@", destinationlatitude, destinationlongitude];
    
    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
    NSString *directionsUrlString = [NSString stringWithFormat:@"%@&origin=%@&destination=%@&mode=driving", directionsAPI, originString, destinationString];
    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:directionsUrl
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                if(error)
                {
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *routesArray = [json objectForKey:@"routes"];
                    
                    NSMutableArray *ForDistance =  [[[[routesArray objectAtIndex:0]valueForKey:@"legs"]objectAtIndex:0]valueForKey:@"distance"];

                            GoogleMapDistance = [ForDistance valueForKey:@"text"];
                    
                     [Coredata saveUserDetails:_updateTime saveUserLatitude:_UserLatitude saveUserLongitude:_UserLongitude saveUserDistance:GoogleMapDistance saveUserCalorie:_updatecalorie saveUserLastLatitude:_UserLastLatitude saveUserLastLongitude:_UserLastLongitude];
                    
                    [self.navigationController popViewControllerAnimated:YES];

                    
                });
                
            }] resume];
    
    
}





@end
