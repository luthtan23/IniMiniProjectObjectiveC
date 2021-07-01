//
//  TodoListDB.m
//  IniDice
//
//  Created by iei19100004 on 29/06/21.
//

#import "TodoListDB.h"
#import "TodoListModel.h"

@implementation TodoListDB

@synthesize strPath;
@synthesize arrdata,strmain;


-(id)init{
    
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *strStrongPath = [arrayPath objectAtIndex:0];
    
    strPath = [strStrongPath stringByAppendingPathComponent:@"todolist.db"];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:strPath]) {
        
        const char *dbPath = [strPath UTF8String];
        
        if (sqlite3_open(dbPath, &_todolistDB) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS TODOLIST (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, DESC TEXT, DATE TEXT, TIME TEXT, PRIORITY INTEGER, IMAGE TEXT, ISEDIT INTEGER, INDEXNUMBER INTEGER, ISCOMPLETE INTEGER)";
            
            if (sqlite3_exec(_todolistDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"FAILED TO CREATE DATABASE");
            }
            sqlite3_close(_todolistDB);
        } else {
            NSLog(@"FAILED TO OPEN DATABASE");
        }
        
    }
    
    NSLog(@"%@",strPath);
    
    return self;
}

-(NSMutableArray *)showAllData{
    NSMutableArray *retArr = [[NSMutableArray alloc]init];
    sqlite3_stmt *statement;
    const char *dbPath = [strPath UTF8String];
    
    if (sqlite3_open(dbPath, &_todolistDB) == SQLITE_OK) {
        NSString *strShow = [[NSString alloc]initWithFormat:@"select * from TODOLIST"];
        
        const char *query_stmt = [strShow UTF8String];
        
        if (sqlite3_prepare_v2(_todolistDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                TodoListModel *todoList = [[TodoListModel alloc] init];
                todoList.idTodoList = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)] intValue];
                todoList.name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)];
                todoList.desc = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)];
                todoList.date = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 3)];
                todoList.time = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 4)];
                todoList.priority = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 5)] intValue];
                todoList.image = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 6)];
                todoList.isEdit = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 7)] boolValue];
                todoList.indexNumber = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 8)] intValue];
                todoList.isComplete = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 9)] boolValue];
                [retArr addObject:todoList];
                todoList = nil;
                NSLog(@"SHOW, %@", retArr);
            }
        } else {  NSLog( @"ERROR GET DATA" );  }
        
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(_todolistDB);

    
    return retArr;
    
}

-(BOOL)saveData:(TodoListModel*) data{
    BOOL statusSave = NO;
    sqlite3_stmt *statement;
    const char *dbPath = [strPath UTF8String];
    
    if (sqlite3_open(dbPath, &_todolistDB) == SQLITE_OK) {
        NSString *insertData = [[NSString alloc] initWithFormat:@"INSERT INTO TODOLIST (name, desc, date, time, priority, image, isedit, indexnumber, iscomplete) VALUES ('%@', '%@', '%@', '%@', '%ld', '%@', '%ld', '%ld', '%ld')", data.name, data.desc, data.date, data.time, (long)data.priority, data.image, @(data.isEdit).integerValue, (long)data.indexNumber, (long)@(data.isComplete).integerValue];
        
        const char *insert_stmt = [insertData UTF8String];
        sqlite3_prepare_v2(_todolistDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"SAVE SUCCESS");
            statusSave = YES;
        } else {
            NSLog(@"SAVE FAILED");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_todolistDB);
    }
    return statusSave;
}

-(BOOL)updateData:(TodoListModel*) data{
    BOOL statusSave = NO;
    sqlite3_stmt *statement;
    const char *dbPath = [strPath UTF8String];
    
    if (sqlite3_open(dbPath, &_todolistDB) == SQLITE_OK) {
        NSString *insertData = [[NSString alloc] initWithFormat:@"UPDATE TODOLIST set name = '%@', desc = '%@', date = '%@', time = '%@', priority = '%ld', image = '%@', isedit = '%ld', indexnumber = '%ld', iscomplete = '%ld' where id = '%ld'", data.name, data.desc, data.date, data.time, (long)data.priority, data.image, @(data.isEdit).integerValue, (long)data.indexNumber, (long)@(data.isComplete).integerValue, data.idTodoList];
        
        const char *insert_stmt = [insertData UTF8String];
        sqlite3_prepare_v2(_todolistDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"UPDATE SUCCESS");
            statusSave = YES;
        } else {
            NSLog(@"UPDATE FAILED");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_todolistDB);
    }
    return statusSave;
}

-(BOOL)deleteData:(TodoListModel*)data{
    
    BOOL statusDelete = NO;
        sqlite3_stmt *statement;
        const char *dbPath = [strPath UTF8String];
        
        if (sqlite3_open(dbPath, &_todolistDB) == SQLITE_OK) {
            NSString *deleteData = [[NSString alloc]initWithFormat:@"delete from TODOLIST where id = '%ld'", (long)data.idTodoList];
            
            const char *delete_stmt = [deleteData UTF8String];
            sqlite3_prepare_v2(_todolistDB, delete_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"DELETE SUCCESS");
                statusDelete = YES;
            } else {
                NSLog(@"DELETE FAILED");
            }
            sqlite3_finalize(statement);
            sqlite3_close(_todolistDB);
        }
        return statusDelete;
}

@end
