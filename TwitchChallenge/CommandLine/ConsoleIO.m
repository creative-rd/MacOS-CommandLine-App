//
//  ConsoleIO.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/24/20.
//

#import "ConsoleIO.h"

@implementation ConsoleIO

+ (instancetype)sharedConsoleIOInstance {
  static ConsoleIO *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[ConsoleIO alloc] init];
  });
  return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
  static ConsoleIO *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [super allocWithZone:zone];
  });
  return sharedInstance;
}

+ (id)alloc {
  return  [self allocWithZone:nil];
}
@end
