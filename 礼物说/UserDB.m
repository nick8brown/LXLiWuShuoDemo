//
//  UserDB.m
//  网络_06
//
//  Created by 曾令轩 on 15/11/24.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "UserDB.h"

@implementation UserDB

- (void)createTable {
    NSString *createStr = @"create table if not exists users (phoneNumber int primary key not null unique, password text)";
    [self createTable:createStr];
}

- (void)addUserWithParams:(NSArray *)params {
    NSString *insertStr = @"insert into users (phoneNumber,password) values(?,?)";
    BOOL success = [self dealWithData:insertStr params:params];
    if (success) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
}

- (void)deleteUsers:(NSArray *)users {
    NSString *deleteStr = nil;
    if (users) {
        for (NSArray *user in users) {
            deleteStr = [NSString stringWithFormat:@"delete from users where phoneNumber = '%@'", user];
            [self deleteUser:deleteStr];
        }
    } else {
        deleteStr = @"delete from users";
        [self deleteUser:deleteStr];
    }
}
- (void)deleteUser:(NSString *)deleteStr {
    BOOL success = [self dealWithData:deleteStr params:nil];
    if (success) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

- (NSArray *)selectUser:(NSArray *)users {
    NSString *selectStr = nil;
    if (users) {
        NSMutableArray *modelArray = [NSMutableArray array];
        for (NSString *user in users) {
            selectStr = [NSString stringWithFormat:@"select * from users where phoneNumber = '%@'", user];
            if ([[self selectFrom:selectStr] count]) {
                [modelArray addObject:[[self selectFrom:selectStr] lastObject]];
            }
        }
        return modelArray;
    } else {
        selectStr = @"select * from users";
        return [self selectFrom:selectStr];
    }
}

@end
