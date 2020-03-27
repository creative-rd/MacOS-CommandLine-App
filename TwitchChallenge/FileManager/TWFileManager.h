//
//  TWFileManager.h
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/24/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWFileManager : NSObject

// Initialize Method
+ (id) sharedManager;

- (BOOL)isValid: (NSString*) pathName;

- (void)saveImage:(NSImage*)image name:(NSString *)imageName path:(NSString*)pathName;

- (void)deleteContentOfDirectory:(NSString*) path completion:(void (^)(void))completionBlock;

@property (strong, nonatomic) NSString *pathName;

@end

NS_ASSUME_NONNULL_END
