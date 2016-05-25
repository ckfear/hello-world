//
//  TestFramework.h
//  test
//
//  Created by 兴业 on 16/5/24.
//  Copyright © 2016年 ckfear. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ServerList;

@interface TestFramework : NSObject

+ (void)initFramework;

+ (instancetype)shareFramework;

/**
 *  插入一条服务器信息
 *
 *  @param serverList 服务器信息
 *
 *  @return 是否插入成功
 */
- (BOOL)insertServerList:(ServerList *)serverList;

/**
 *  插入多条服务器信息
 *
 *  @param serverList 服务器信息列表
 *
 *  @return 是否插入成功
 */
- (BOOL)insertServerLists:(NSArray<ServerList *> *)serverLists;

/**
 *  删除一条服务器信息
 *
 *  @param serverList 服务器信息
 *
 *  @return 是否删除成功
 */
- (BOOL)deleteServerList:(ServerList *)serverList;

/**
 *  删除所有数据
 *
 *  @return 是否删除成功
 */
- (BOOL)deleteAllServerLists;

/**
 *  更新数据
 *
 *  @param serverList 服务器信息
 *
 *  @return 是否更新成功
 */
- (BOOL)updateServerList:(ServerList *)serverList;


- (NSArray *)searchServerListsByServerName:(NSString *)serverName;


@end
