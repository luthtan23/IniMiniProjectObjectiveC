//
//  MemberDetailViewController.h
//  IniDice
//
//  Created by iei19100004 on 03/06/21.
//

#import <UIKit/UIKit.h>
#import "MemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MemberDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageDetail;

@property (nonatomic, assign) MemberModel *memberModel;
@property (weak, nonatomic) IBOutlet UILabel *nameDetail;
@property (weak, nonatomic) IBOutlet UILabel *roleDetail;
@property (weak, nonatomic) IBOutlet UILabel *birthDetail;
@property (weak, nonatomic) IBOutlet UILabel *locationDetail;
@property (weak, nonatomic) IBOutlet UILabel *hobbyDetail;
@property (weak, nonatomic) IBOutlet UILabel *motivationDetail;

@end

NS_ASSUME_NONNULL_END
