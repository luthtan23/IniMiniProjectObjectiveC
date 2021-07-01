//
//  TodoListDB.h
//  IniDice
//
//  Created by iei19100004 on 29/06/21.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TodoListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TodoListDB : NSObject

@property (strong, nonatomic) NSString *strPath;
@property (nonatomic) sqlite3 *todolistDB;

-(BOOL)saveData:(TodoListModel*) data;
-(BOOL)updateData:(TodoListModel*) data;
-(BOOL)deleteData:(TodoListModel*) data;
-(NSMutableArray*)showAllData;


@property(strong,nonatomic) NSMutableArray *arrdata;
@property(strong, nonatomic) NSString *strmain;

@end

NS_ASSUME_NONNULL_END
