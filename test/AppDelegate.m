//
//  AppDelegate.m
//  test
//
//  Created by 王广峰 on 2018/2/5.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "AppDelegate.h"
#import "ModuleManager+mainTab.h"
#import "ViewController.h"
#import "NSMutableDictionary+Hook.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[ModuleManager shardInstance] mainTabViewController];
    [self.window makeKeyAndVisible];
    
    NSLog(@"1.........%ld", [NSURLCache sharedURLCache].diskCapacity);
    NSLog(@"2.........%ld", [NSURLCache sharedURLCache].memoryCapacity);
    
    // json string conver object ****************************************
//    NSString * jsonString = @"{\"title\":}";
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
//    if (err) {
//        NSLog(@"err......%@",err);
//    } else {
//        NSLog(@"dict.....%@",dict);
//    }
    
    //objec convert json string ****************************************
//    NSDictionary * dict = @{@"title":@"xf"};
//    NSError * err;
//    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&err];
//    if (err) {
//        NSLog(@"err......%@",err);
//    } else {
//        NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"str.....%@",str);
//    }
    
    id val = nil;
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:val forKey:@"title"];
    NSLog(@"dict......%@",dict);
    
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
