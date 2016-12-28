//
//  DetailViewController.m
//  calorieRun
//
//  Created by Gowthamraj K on 25/12/16.
//  Copyright © 2016 gowtham. All rights reserved.
//

#import "DetailViewController.h"
#import "MapViewHelper.h"

@interface DetailViewController ()


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   

    _timeLabel.text = _showUserDetail.usertimer;
    _distanceLabel.text = _showUserDetail.userdistance;
    _calorieLabel.text = _showUserDetail.usercalorie;
    
    if([CLLocationManager locationServicesEnabled]){
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.activityType = CLActivityTypeOtherNavigation;
        _locationManager.allowsBackgroundLocationUpdates = YES;
        [_locationManager startUpdatingLocation];
        
    }else
    {
        
    }
    CLLocationCoordinate2D setLocation = _locationManager.location.coordinate;
    _mapView = [[MapViewHelper sharedInstance]showMapWithCoordinateInDetail:setLocation WithFrame:self.view.frame onTarget:self];
    [self fetchPolylineWithOrigin:_showUserDetail.userlatitude origin:_showUserDetail.userlongitude destinationlat:_showUserDetail.userlastlatitude destinationlong:_showUserDetail.userlastlongitude];
    
    _latitude = [_showUserDetail.userlatitude floatValue];
    _longitude = [_showUserDetail.userlongitude floatValue];
    
    _lastLatitude = [_showUserDetail.userlastlatitude floatValue];
    _lastLongitude = [_showUserDetail.userlastlongitude floatValue];
    
    
    GMSMarker *grand = [[GMSMarker alloc] init];
    grand.appearAnimation = YES;
    grand.icon = [[MapViewHelper sharedInstance] image:[UIImage imageNamed:@"bluepin"] scaledToSize:CGSizeMake(30.0f, 50.0f)];
    
    grand.position = CLLocationCoordinate2DMake(_latitude, _longitude);
    grand.map = _mapView;
    
    
    GMSMarker *endpoint = [[GMSMarker alloc] init];
    endpoint.appearAnimation = YES;
    endpoint.icon = [[MapViewHelper sharedInstance] image:[UIImage imageNamed:@"greenpin"] scaledToSize:CGSizeMake(30.0f, 50.0f)];
    
    endpoint.position = CLLocationCoordinate2DMake(_lastLatitude, _lastLongitude);
    endpoint.map = _mapView;

   
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)backAction:(id)sender {
   [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)deleteUserDetailAction:(id)sender {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Calorie Run"
                                 message:@"Do you want to Delete"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                 
                                    
                                    [Coredata deleteUserDetail:_getIndexvalue];
                                     [self performSegueWithIdentifier:@"deleteSegue" sender:self];
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

#pragma mark - GetpolylineService

- (void)fetchPolylineWithOrigin:(NSString *)originlatitude origin:(NSString * )orginlongitude destinationlat:(NSString *) destinationlatitude destinationlong:(NSString *) destinationlongitude
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
                    
                    GMSPolyline *polyline = nil;
                    if ([routesArray count] > 0)
                    {
                        NSDictionary *routeDict = [routesArray objectAtIndex:0];
                        NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                        NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                        GMSPath *path = [GMSPath pathFromEncodedPath:points];
                        polyline = [GMSPolyline polylineWithPath:path];
                    }
                    polyline.strokeWidth = 5;
                    polyline.strokeColor = [UIColor blueColor];
                    polyline.map = _mapView;
                });
                
            }] resume];
    
    
   }
#pragma mark - UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"deleteSegue"])
    {
        _controller = [segue destinationViewController];
    }
    
}

@end
