//
//  PriorityViewController.h
//  IniDice
//
//  Created by iei19100004 on 14/06/21.
//

#import <UIKit/UIKit.h>

@protocol priorityData <NSObject>

- (void) priorityData:(NSInteger) priorityInt priorityText:(NSString*_Nullable) priorityText;

@end

NS_ASSUME_NONNULL_BEGIN

@interface PriorityViewController : UIViewController

@property(nonatomic, retain) UITableView *priorityTableView;

@property(nonatomic, assign) NSString* priorityString;

@property (nonatomic, assign) NSInteger result;

@property(nonatomic, assign)id delegate;


@end

NS_ASSUME_NONNULL_END
