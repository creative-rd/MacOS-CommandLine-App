//
//  AvatarModel.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/23/20.
//

#import "AvatarModel.h"

@implementation AvatarModel

@synthesize name = _name;
@synthesize url = _url;

- (instancetype) initWithAvatarData: (NSString *)name andURL: (NSString *)url {
  self = [super init];
  if (self) {
    _name = name;
    _url = url;
  }
  return self;
}


@end
