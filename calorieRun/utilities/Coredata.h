//
//  Coredata.h
//  calorieRun
//
//  Created by Gowthamraj K on 24/12/16.
//  Copyright © 2016 gowtham. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UserDetailItems.h"


@interface Coredata : NSManagedObject



+ (NSManagedObjectContext *)managedObjectContext;

+ (void)saveUserDetails:(NSString *)usertime saveUserLatitude:(NSString *)userlatitude saveUserLongitude:(NSString *)userlongitude saveUserDistance:(NSString *)userdistance saveUserCalorie:(NSString *)usercalorie saveUserLastLatitude:(NSString *)userlastlatitude saveUserLastLongitude:(NSString *)userlastlongitude;

+ (NSMutableArray *)fetchUserDetails;

+(void)deleteUserDetail:(NSInteger)index;

+(void)saveToDatabase;



@end
