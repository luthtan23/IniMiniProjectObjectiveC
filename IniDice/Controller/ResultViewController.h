//
//  ResultViewController.h
//  IniDice
//
//  Created by iei19100004 on 27/05/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResultViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *textTotal;
@property (nonatomic, assign) int result;

@end

NS_ASSUME_NONNULL_END
