//
//  ViewController.h
//  calorieRun
//
//  Created by Gowthamraj K on 24/12/16.
//  Copyright © 2016 gowtham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coredata.h"
#import "UserDetailItems.h"
#import "GoogleViewController.h"
#import "DetailViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MapViewHelper.h"

@class DetailViewController;

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


#pragma mark - float
@property float latitude;
@property float longitude;
@property float lastLatitude;
@property float lastLongitude;

#pragma mark - UITableView
@property (weak, nonatomic) IBOutlet UITableView *DetailTableView;

#pragma mark - NSMutableArray
@property (retain,nonatomic)NSMutableArray *getUserDetailArray;
@property (retain,nonatomic)NSMutableArray *sendUserDetailArray;

#pragma mark - UIView
@property (retain,nonatomic)UIView *googleView;

#pragma mark - NSObject
@property(nonatomic,retain)UserDetailItems * getUserDetail;

#pragma mark - NSInteger
@property NSInteger sendIndexvalue;

#pragma mark - UIViewController
@property(nonatomic,retain)GoogleViewController * googlecontroller;
@property(nonatomic,retain)DetailViewController * detailController;

@property (weak, nonatomic) IBOutlet UIImageView *addListImage;


@property (retain, nonatomic)  GMSMapView *mapView;



#pragma mark - ButtonAction
- (IBAction)detailPageAction:(id)sender;

@end

