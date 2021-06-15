//
//  TodoListModel.h
//  IniDice
//
//  Created by iei19100004 on 08/06/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TodoListModel : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *time;
@property (nonatomic) NSInteger *priority;
@property (nonatomic, retain) NSString *image;
@property (assign) BOOL isEdit;
@property (nonatomic) NSInteger indexNumber;
@property (assign) BOOL isComplete;

-(id) initWithName: (NSString*) name
              desc: (NSString*) desc
              date: (NSString*) date
              time: (NSString*) time
          priotiry: (NSInteger*) priority
             image: (NSString*) image
            isEdit: (BOOL) isEdit
       indexNumber: (NSInteger) indexNumber
        isComplete: (BOOL) isComplete;

@end

NS_ASSUME_NONNULL_END
