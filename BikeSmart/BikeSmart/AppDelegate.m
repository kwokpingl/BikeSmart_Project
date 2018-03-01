//
//  AppDelegate.m
//  BikeSmart
//
//  Created by Jimmy on 2017/7/2.
//  Copyright © 2017年 Jimmy. All rights reserved.
//


#import "AppDelegate.h"
#import "MainVC.h"
#import "Definitions.h"
#import "Constants.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Realm/Realm.h>
//#import "BikeModel.h"
#import "UserDefaults.h"
#import "LaunchVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
#pragma mark - ADDITIONAL METHODs
- (void) resetLanguage {
    // Force the App Language to En So Google can fetch English Name
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_AppleLanguages];
    
    int indexForZh = 100000;
    int indexForEn = 100000;
    
    for (int i = 0; i < languages.count; i ++) {
        if ([languages[i] containsString:@"zh"] && i < indexForZh ) {
            indexForZh = i;
        } else if ([languages[i] containsString:@"en"] && i < indexForEn) {
            indexForEn = i;
        }
    }
    
    if (indexForZh < indexForEn) {
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:UserDefault_DisplayLanguages];
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:UserDefault_DisplayLanguages];
    }
        
//    if (![[languages firstObject] containsString:@"en"]) {
//        
//        if ([[languages firstObject] containsString:@"zh"]) {
//            [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:UserDefault_DisplayLanguages];
//        } else {
//            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:UserDefault_DisplayLanguages];
//        }
//        
//        [[NSUserDefaults standardUserDefaults] setObject:@[@"en"] forKey:UserDefault_AppleLanguages];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    else
//    {
//        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:UserDefault_DisplayLanguages];
//    }
    
    
    
}

- (void)setupUserDefaults {
    
    // Setup the Default Bike Types if nothing has been set yet
    [UserDefaults setSelectedBikeTypes:nil];
    
    // SET DEFAULT RANGE of Longtitude Latitude
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UserDefault_DeltaLat] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@(0.125) forKey:UserDefault_DeltaLat];
    }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UserDefault_DeltaLng] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@(0.15) forKey:UserDefault_DeltaLng];
    }
}

- (void)prepareRealm {
    // REMOVE REALM DATABASE
    BOOL shouldRemoveRealmFile = true;
    if (shouldRemoveRealmFile)
    {
        @autoreleasepool {
            // all Realm usage here
        }
        NSFileManager *manager = [NSFileManager defaultManager];
        RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
        NSArray<NSURL *> *realmFileURLs = @[
                                            config.fileURL,
                                            [config.fileURL URLByAppendingPathExtension:@"lock"],
                                            [config.fileURL URLByAppendingPathExtension:@"note"],
                                            [config.fileURL URLByAppendingPathExtension:@"management"]
                                            ];
        for (NSURL *URL in realmFileURLs) {
            NSError *error = nil;
            [manager removeItemAtURL:URL error:&error];
            if (error) {
                // handle error
            }
        }
        
    }
}

#pragma mark - LIFE CYCLE

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIViewController * launchVC = [LaunchVC new];
        
    _window.rootViewController = launchVC;
    
    [GMSServices provideAPIKey:Google_APIKey]; // Must setup the GMSServices before presenting UI
    
    [_window makeKeyAndVisible];
    
    [self resetLanguage];
    
//    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_AppleLanguages];
    
    [self setupUserDefaults];
    [self prepareRealm];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
