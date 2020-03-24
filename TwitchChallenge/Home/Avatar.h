//
//  Avatar.h
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/23/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Avatar : NSObject

// Initialize Method
- (instancetype)initWithPath:(NSString *)path;

// Method / Functions
- (void)validateGivenPathName;
- (void)loadGameAndAvatars;

// Properties
@property (strong, nonatomic) NSString *pathName;

@end

NS_ASSUME_NONNULL_END
