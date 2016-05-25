//
//  TestFramework.m
//  test
//
//  Created by 兴业 on 16/5/24.
//  Copyright © 2016年 ckfear. All rights reserved.
//

#import "TestFramework.h"
#import <sqlite3.h>
#import "ServerList.h"

@interface TestFramework () {
    sqlite3 *_database;
}

@end

@implementation TestFramework

static TestFramework *shareFrameWork = nil;
+ (instancetype)shareFramework{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareFrameWork = [[TestFramework alloc] init];
    });
    return shareFrameWork;
}

+ (void)initFramework{
    NSLog(@"%@", self);
    [[self shareFramework] openDB];
}

- (NSString *)databasePath{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"docPath = %@", docPath);
    NSString *dbPath = [docPath stringByAppendingString:@"/test.db"];
    NSLog(@"dbPath = %@", dbPath);
    return dbPath;
}

- (BOOL)openDB{
    NSString *dbPath = [self databasePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDbExist = [manager fileExistsAtPath:dbPath];
    if (!isDbExist) {
        if (![manager createDirectoryAtPath:[dbPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil]) {
            NSLog(@"error:create error");
            return NO;
        }
    }
    if (sqlite3_open([dbPath UTF8String], &_database) == SQLITE_OK) {
        [self createTableList:_database];
        return YES;
    } else {
        sqlite3_close(_database);
        NSLog(@"open error");
        return NO;
    }
}

- (BOOL)createTableList:(sqlite3 *)dataBase{
    char *sql = "create table if not exists testTable(ID INTEGER PRIMARY KEY AUTOINCREMENT, serverName text, serverIP text,cerSuffix text)";
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql, -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        NSLog(@"Error:Failed prepare to create table");
        return NO;
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success != SQLITE_DONE) {
        NSLog(@"Error: failed to dehydrate:create table test");
        return NO;
    }
    NSLog(@"Create table 'testTable' successed.");
    return YES;
}

- (BOOL)insertServerLists:(NSArray<ServerList *> *)serverLists{
    if ([self openDB]) {
        char *s1 = "INSERT INTO testTable (serverName, serverIP, cerSuffix) values (?, ?, ?)";
        char *s2 = ",(?, ?, ?)";
        for (int i=1; i<serverLists.count; i++) {
            char *result = malloc(strlen(s1)+strlen(s2)+1);//+1 for the zero-terminator
            //in real code you would check for errors in malloc here
            if (result == NULL) {
                return NO;
            }
            strcpy(result, s1);
            strcat(result, s2);
            s1 = malloc(strlen(result));
            strcpy(s1, result);
            free(result);
        }
        printf("%s", s1);
        sqlite3_stmt *statement;
        NSInteger sqlReturn = sqlite3_prepare_v2(_database, s1, -1, &statement, nil);
        if (sqlReturn != SQLITE_OK) {
            sqlite3_close(_database);
            NSLog(@"Error:Failed prepare to insert data to table");
            return NO;
        }
        for (int i=0; i<serverLists.count; i++) {
            ServerList *serverList = serverLists[i];
            sqlite3_bind_text(statement, i*3+1, [serverList.serverName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, i*3+2, [serverList.serverIP UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, i*3+3, [serverList.cerSuffix UTF8String], -1, SQLITE_TRANSIENT);
        }
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success != SQLITE_DONE) {
            sqlite3_close(_database);
            NSLog(@"Error: fail insert data");
            return NO;
        } else {
            sqlite3_close(_database);
            NSLog(@"Success: insert data");
            return YES;
        }
    }
    return NO;
}

- (BOOL)insertServerList:(ServerList *)serverList{
    if ([self openDB]) {
        char *sql = "INSERT INTO testTable (serverName, serverIP, cerSuffix) values (?, ?, ?)";
        sqlite3_stmt *statement;
        NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql, -1, &statement, nil);
        if (sqlReturn != SQLITE_OK) {
            sqlite3_close(_database);
            NSLog(@"Error:Failed prepare to insert data to table");
            return NO;
        }
        sqlite3_bind_text(statement, 1, [serverList.serverName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [serverList.serverIP UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [serverList.cerSuffix UTF8String], -1, SQLITE_TRANSIENT);
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success != SQLITE_DONE) {
            sqlite3_close(_database);
            NSLog(@"Error: fail insert data");
            return NO;
        } else {
            sqlite3_close(_database);
            NSLog(@"Success: insert data");
            return YES;
        }
    }
    return NO;
}

- (BOOL)deleteServerList:(ServerList *)serverList{
    if ([self openDB]) {
        char *sql = "DELETE FROM testTable WHERE serverName = ? and serverIP = ? and cerSuffix = ?";
        sqlite3_stmt *statement;
        NSInteger result = sqlite3_prepare_v2(_database, sql, -1, &statement, nil);
        if (result != SQLITE_OK) {
            sqlite3_close(_database);
            NSLog(@"Error: fail prepare to delete data");
            return NO;
        }
        sqlite3_bind_text(statement, 1, [serverList.serverName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [serverList.serverIP UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [serverList.cerSuffix UTF8String], -1, SQLITE_TRANSIENT);
        result = sqlite3_step(statement);
        if (result != SQLITE_DONE) {
            sqlite3_close(_database);
            NSLog(@"Error: fail delete data");
            return NO;
        } else {
            sqlite3_close(_database);
            NSLog(@"Success: delete data");
            return YES;
        }
    }
    return NO;
}

- (BOOL)deleteAllData{
    if ([self openDB]) {
        sqlite3_stmt *statement;
        char *sql = "DELETE FROM testTable";
        NSUInteger result = sqlite3_prepare_v2(_database, sql, -1, &statement, nil);
        if (result != SQLITE_OK) {
            sqlite3_close(_database);
            NSLog(@"Error: fail prepare to delete data");
            return NO;
        }
        result = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (result != SQLITE_DONE) {
            sqlite3_close(_database);
            NSLog(@"Error: fail delete data");
            return NO;
        } else {
            sqlite3_close(_database);
            NSLog(@"Success: delete all data");
            return YES;
        }
    }
    return NO;
}

- (BOOL)updateServerList:(ServerList *)serverList{
    if ([self openDB]) {
        sqlite3_stmt *statement;
        char *sql = "UPDATE testTable SET serverName = ?, serverIP = ?, cerSuffix = ? WHERE ID = ?";
        NSUInteger result = sqlite3_prepare_v2(_database, sql, -1, &statement, nil);
        if (result != SQLITE_OK) {
            sqlite3_close(_database);
            NSLog(@"Error: fail prepare to update data");
            return NO;
        } else {
            sqlite3_bind_text(statement, 1, [serverList.serverName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [serverList.serverIP UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [serverList.cerSuffix UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement, 4, (int)serverList.ID);
            printf("%s", sql);
            result = sqlite3_step(statement);
            sqlite3_finalize(statement);
            if (result != SQLITE_DONE) {
                sqlite3_close(_database);
                NSLog(@"Error: fail update data");
                return NO;
            } else {
                sqlite3_close(_database);
                NSLog(@"Success: update data");
                return YES;
            }
        }
    }
    return NO;
}

- (NSArray *)searchServerListsByServerName:(NSString *)serverName{
    if ([self openDB]) {
        NSMutableArray *lists = [NSMutableArray array];
        sqlite3_stmt *statement;
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * from testTable where serverName like '%@\%%'",serverName];
        const char *sql = [querySQL UTF8String];
        printf("%s", sql);
        NSUInteger result = sqlite3_prepare_v2(_database, sql, -1, &statement, nil);
        if (result != SQLITE_OK) {
            sqlite3_close(_database);
            NSLog(@"Error");
            return nil;
        } else {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                ServerList *serverList = [[ServerList alloc] init];
                serverList.ID = atoi((const char*)sqlite3_column_text(statement, 0));
                serverList.serverName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                serverList.serverIP = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                serverList.cerSuffix = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                [lists addObject:serverList];
            }
            return lists;
        }
    }
    return nil;
}

@end
