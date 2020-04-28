//
//  ConsoleIO.m
//

#import "TWConsoleIO.h"

@implementation TWConsoleIO

+ (instancetype)sharedInstance {
  static TWConsoleIO *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[TWConsoleIO alloc] init];
  });
  return sharedInstance;
}

// Print the message in console
- (void) writeMessage: (NSString*) message {
  NSLog(@"%@", message);
}

// Get input message from the user.
- (NSString*) getInput {
  NSFileHandle* fileHandle = [NSFileHandle fileHandleWithStandardInput];
  NSData *data = [fileHandle availableData];
  NSString *result = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
  return [result stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

@end
