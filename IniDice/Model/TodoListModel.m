//
//  TodoListModel.m
//  IniDice
//
//  Created by iei19100004 on 08/06/21.
//

#import "TodoListModel.h"

@implementation TodoListModel

@synthesize idTodoList, name,desc,date,time,priority,image,isEdit,indexNumber, isComplete;

- (id) initWithIdTodoList:(NSInteger)idTodoList name:(NSString *)name desc:(NSString *)desc date:(NSString *)date time:(NSString *)time priotiry:(NSInteger)priority image:(NSString *)image isEdit:(BOOL)isEdit indexNumber:(NSInteger)indexNumber isComplete:(BOOL)isComplete{
    self.idTodoList = idTodoList;
    self.name = name;
    self.desc = desc;
    self.date = date;
    self.time = time;
    self.priority = priority;
    self.image = image;
    self.isEdit = isEdit;
    self.indexNumber = indexNumber;
    self.isComplete = isComplete;
    return self;
}

@end
