//
//  MemberModel.h
//  IniDice
//
//  Created by iei19100004 on 03/06/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemberModel : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *role;
@property (nonatomic, retain) NSString *birthPlace;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *hobby;
@property (nonatomic, retain) NSString *motivation;
@property (nonatomic, retain) NSString *image;

-(id) initWithName: (NSString*) name
              role: (NSString*) role
        birthPlace: (NSString*) birthPlace
           address: (NSString*) address
             hobby: (NSString*) hobby
        motivation: (NSString*) motivation
             image: (NSString*) image;

@end

NS_ASSUME_NONNULL_END
