//
//  Coredata.m
//  calorieRun
//
//  Created by Gowthamraj K on 24/12/16.
//  Copyright © 2016 gowtham. All rights reserved.
//

#import "Coredata.h"


#pragma mark - DB UserDetail

#define kEntityTimer @"usertimer"
#define kEntityLongitude @"userlongitude"
#define kEntityLatitude @"userlatitude"
#define kEntityDistance @"userdistance"
#define kEntityCalorie @"usercalorie"
#define kEntityLastLatitude @"userlastlatitude"
#define kEntityLastLongitude @"userlastlongitude"





@implementation Coredata



+ (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

+(void)saveToDatabase
{
    // Save the object to persistent store
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}
+ (void)saveUserDetails:(NSString *)usertime saveUserLatitude:(NSString *)userlatitude saveUserLongitude:(NSString *)userlongitude saveUserDistance:(NSString *)userdistance saveUserCalorie:(NSString *)usercalorie saveUserLastLatitude:(NSString *)userlastlatitude saveUserLastLongitude:(NSString *)userlastlongitude
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"UserDetails" inManagedObjectContext:context];
    
    [newUser setValue:usertime forKey:kEntityTimer];
    [newUser setValue:userlatitude forKey:kEntityLatitude];
    [newUser setValue:userlongitude forKey:kEntityLongitude];
    [newUser setValue:userdistance forKey:kEntityDistance];
    [newUser setValue:usercalorie forKey:kEntityCalorie];
    [newUser setValue:userlastlatitude forKey:kEntityLastLatitude];
    [newUser setValue:userlastlongitude forKey:kEntityLastLongitude];
    
    [self saveToDatabase];
}

+ (NSMutableArray *)fetchUserDetails
{
    NSMutableArray * userDetailArray = [[NSMutableArray alloc]init];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserDetails"];
    userDetailArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
     NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    for (NSManagedObject *object in userDetailArray)
    {
        UserDetailItems *item = [[UserDetailItems alloc] init];
        item.usertimer = [object valueForKey:kEntityTimer];
        item.userlongitude = [object valueForKey:kEntityLongitude];
        item.userlatitude = [object valueForKey:kEntityLatitude];
        item.userdistance = [object valueForKey:kEntityDistance];
        item.usercalorie = [object valueForKey:kEntityCalorie];
        item.userlastlatitude = [object valueForKey:kEntityLastLatitude];
        item.userlastlongitude = [object valueForKey:kEntityLastLongitude];

        [modelArray addObject:item];
    }

    
    
    return modelArray;
}

+(void)deleteUserDetail:(NSInteger)index
{
    NSMutableArray * userDetailArray = [[NSMutableArray alloc]init];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserDetails"];
    userDetailArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];

   [managedObjectContext deleteObject:[userDetailArray objectAtIndex:index]];
         [self saveToDatabase];
}


@end
