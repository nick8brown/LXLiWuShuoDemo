//
//  DBManager2.m
//  网络_06
//
//  Created by 曾令轩 on 15/11/24.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "DBManager2.h"
#import <sqlite3.h>
#import "User.h"

@implementation DBManager2

- (sqlite3 *)createSqlite {
    sqlite3 *sqlite = nil;
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/mysqlite.sqlite"];
    int success = sqlite3_open([path UTF8String], &sqlite);
    if(success != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    return sqlite;
}

- (BOOL)createTable:(NSString *)sql {
    sqlite3 *sqlite = [self createSqlite];
    int success = sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"创建数据库表失败");
        return NO;
    }
    sqlite3_close(sqlite);
    return YES;
}

- (BOOL)dealWithData:(NSString *)sql params:(NSArray *)params {
    sqlite3 *sqlite = [self createSqlite];
    sqlite3_stmt *stmt = nil;
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    for (int i = 0; i < params.count; i++) {
        if ([params[i] isKindOfClass:[NSString class]]) {
            sqlite3_bind_text(stmt, i+1, [params[i] UTF8String], -1, NULL);
        } else if ([params[i] isKindOfClass:[NSNumber class]]) {
            sqlite3_bind_int(stmt, i+1, [params[i] intValue]);
        }
    }
    int result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR) {
        NSLog(@"数据插入失败");
        return NO;
    }
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    return YES;
}

- (NSArray *)selectFrom:(NSString *)sql {
    sqlite3 *sqlite = [self createSqlite];
    sqlite3_stmt *stmt = nil;
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    int result = sqlite3_step(stmt);
    NSMutableArray *userArray = [NSMutableArray array];
    while (result == SQLITE_ROW) {
        NSString *phoneNumber = [NSString stringWithCString:(char *)sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
        NSString *password = [NSString stringWithCString:(char *)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
        User *user = [[User alloc] init];
        user.phoneNumber = phoneNumber;
        user.password = password;
        [userArray addObject:user];
        result = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    return userArray;
}

@end
