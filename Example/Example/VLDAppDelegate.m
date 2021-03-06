//
//  VLDAppDelegate.m
//  Example
//
//  Created by Vladimir Angelov on 11/9/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import "VLDAppDelegate.h"
#import "VLDLocalNotificationsScheduler.h"

@interface VLDAppDelegate ()

@property (strong, nonatomic) VLDLocalNotificationsScheduler *scheduler;

@end

@implementation VLDAppDelegate

- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.scheduler = [[VLDLocalNotificationsScheduler alloc] init];
    
    if ([UIApplication instancesRespondToSelector: @selector(registerUserNotificationSettings:)] &&
        !([UIApplication sharedApplication].currentUserNotificationSettings.types & UIUserNotificationTypeAlert)) {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeAlert
                                                                                 categories: nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings: settings];
        
    }
    else {
        [self scheduleTestLocalNotification];
    }
    
    return YES;
}

- (void) scheduleTestLocalNotification {
    [self.scheduler executeTransaction: ^(VLDLocalNotificationsTransaction *transaction) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval: 10];
        localNotification.alertBody = @"Test message";
        
        [transaction addLocalNotification: localNotification
                                 withType: @"test"];
    }];
}

- (void) application: (UIApplication *) application didRegisterUserNotificationSettings: (UIUserNotificationSettings *) notificationSettings {
    [self scheduleTestLocalNotification];
}

- (void)applicationDidBecomeActive: (UIApplication *) application {
    [self.scheduler reschedule];
}

@end
