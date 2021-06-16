//
//  DiceViewController.h
//  IniDice
//
//  Created by iei19100004 on 16/06/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiceViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *dice1;
@property (strong, nonatomic) IBOutlet UIImageView *dice2;
@property (strong, nonatomic) IBOutlet UILabel *textDice1;
@property (strong, nonatomic) IBOutlet UILabel *textDice2;
@property (strong, nonatomic) IBOutlet UILabel *textTotal;
@property (strong, nonatomic) IBOutlet UILabel *textTitleTotal;


@end

NS_ASSUME_NONNULL_END
