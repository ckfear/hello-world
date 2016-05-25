//
//  AppDelegate.m
//  test
//
//  Created by 兴业 on 16/3/31.
//  Copyright © 2016年 ckfear. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDB.h"
#import <sqlite3.h>
#import "TestFramework.h"


//#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef DEBUG
    [TestFramework initFramework];
#endif
//    NSString *dbPath = @"/tmp/test.db";
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [fileManager removeItemAtPath:dbPath error:nil];
//    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//    NSLog(@"is SQLite complied with it's thread safe options turned on? %@!", [FMDatabase isSQLiteThreadSafe] ? @"YES" : @"NO");
//    {
//        FMDBQuickCheck([db executeQuery:@"select *from table"] == nil);
//        NSLog(@"%d: %@", [db lastErrorCode], [db lastErrorMessage]);
//    }
//    
//    NSString *printDbpath = [NSHomeDirectory() stringByAppendingString:@"/tmp/test.db"];
//    NSLog(@"dbPath = %@", printDbpath);
//    
//    if (![db open]) {
//        NSLog(@"could not open db.");
//        return 0;
//    }
//    
//    [db setShouldCacheStatements:YES];
//    [db executeUpdate:@"blah blah blah"];
//    
//    FMDBQuickCheck([db hadError]);
//    
//    if ([db hadError]) {
//        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
//    }
//    
//    NSError *err = 0x00;
//    FMDBQuickCheck(![db executeUpdate:@"blah blah blah" withErrorAndBindings:&err]);
//    FMDBQuickCheck(err != nil);
//    FMDBQuickCheck([err code] == SQLITE_ERROR);
//    NSLog(@"err: '%@'", err);
//    
//    FMDBQuickCheck(([db boolForQuery:@"SELECT ? not NULL", @""]));
//    
//    FMDBQuickCheck(([db boolForQuery:@"SELECT ? not NULL", [NSMutableData data]]));
//    
//    FMDBQuickCheck(([db boolForQuery:@"SELECT ? not NULL", [NSData data]]));
//    
//    FMResultSet *ps = [db executeQuery:@"pragma journal_mode=delete"];
//    FMDBQuickCheck(![db hadError]);
//    FMDBQuickCheck(ps);
//    FMDBQuickCheck([ps next]);
//    [ps close];
//    
//    [db executeUpdate:@"pragma page_size=2048"];
//    FMDBQuickCheck(![db hadError]);
//    FMDBQuickCheck(![db hadError]);
//    
//    [db executeUpdate:@"create table test (a text, b text, c integer, d double, e double)"];
//    [db beginTransaction];
//    
//    
//    int i = 0;
//    while (i++ < 20) {
//        [db executeUpdate:@"insert into test (a, b, c, d, e) values (?, ?, ?, ?, ?)",
//         @"hi again'",
//         [NSString stringWithFormat:@"number %d", i],
//         [NSNumber numberWithInt:i],
//         [NSDate date],
//         [NSNumber numberWithFloat:2.2]];
//    }
//    [db commit];
//    
//    FMResultSet *rs = [db executeQuery:@"select rowid,* from test where a = ?", @"hi"];
//    while ([rs next]) {
//        NSLog(@"%d %@ %@ %@ %@ %f %f",
//              [rs intForColumn:@"c"],
//              [rs stringForColumn:@"b"],
//              [rs stringForColumn:@"a"],
//              [rs stringForColumn:@"rowid"],
//              [rs dateForColumn:@"d"],
//              [rs doubleForColumn:@"d"],
//              [rs doubleForColumn:@"e"]);
//        if (![[rs columnNameForIndex:0] isEqualToString:@"rowid"] && [[rs columnNameForIndex:1] isEqualToString:@"a"]) {
//            NSLog(@"WHOA THRER BUDDY, columnName");
//        }
//    }
//    
    
    
    //    // IOS8
//    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
//        //        1.创建消息上面要添加的动作(按钮的形式显示出来)
//        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
//        action.identifier = @"action";//按钮的标示
//        action.title=@"Accept";//按钮的标题
//        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
//        //    action.authenticationRequired = YES;
//        //    action.destructive = YES;
//        
//        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
//        action2.identifier = @"action2";
//        action2.title=@"Reject";
//        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action.destructive = YES;
//        //        2.创建动作(按钮)的类别集合
//        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
//        categorys.identifier = @"alert";//这组动作的唯一标示
//        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
//        //        3.创建UIUserNotificationSettings，并设置消息的显示类类型
//        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys,nil]];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    } else {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
//    }
//    application.applicationIconBadgeNumber = 0;//消息提示数字
    
    // Override point for customization after application launch.
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken{
    NSString *deviceTokenString2 = [[[[pToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"方式2：%@", deviceTokenString2);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"userInfo == %@",userInfo);
    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"Regist fail%@",error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
