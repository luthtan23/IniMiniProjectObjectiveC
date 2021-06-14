//
//  MemberModel.m
//  IniDice
//
//  Created by iei19100004 on 03/06/21.
//

#import "MemberModel.h"

@implementation MemberModel

@synthesize name, role, birthPlace, address, hobby, motivation, image;

- (id) initWithName:(NSString *)name role: (NSString *) role birthPlace:(NSString *)birthPlace address:(NSString *)address hobby:(NSString *)hobby motivation:(NSString *)motivation image:(NSString *)image{
    self.name = name;
    self.role = role;
    self.birthPlace = birthPlace;
    self.address = address;
    self.hobby = hobby;
    self.motivation = motivation;
    self.image = image;
    return self;
}

@end
