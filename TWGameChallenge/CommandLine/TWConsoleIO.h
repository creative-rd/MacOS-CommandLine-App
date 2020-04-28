//
//  ConsoleIO.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWConsoleIO : NSObject

// Singleton Initializer
+ (instancetype)sharedInstance;

// Write on console with message as NSString.

- (void) writeMessage: (NSString*) message;

// Get Input from the user as NSString.
- (NSString*) getInput;

@end

NS_ASSUME_NONNULL_END
