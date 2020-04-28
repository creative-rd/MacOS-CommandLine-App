//
//  AvatarModel.m
//

#import "TWAvatarModel.h"

@implementation TWAvatarModel

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
