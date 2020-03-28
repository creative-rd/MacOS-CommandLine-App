//
//  TWAvatarHome.h
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/23/20.
//

#import <Foundation/Foundation.h>
#import "TWFileManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TWAvatarHome : NSObject

-(instancetype)initWithPath:(NSString *) pathName;

// Method / Functions
- (void)loadGameAndAvatars;

- (void)listGamesAndAvatars;

- (void)loadRandomAvatars: (NSString*) game;

- (void)downloadAvatarsToDirectory;

- (void)processSelectedAvatar: (NSString*) selectedAvatar;

@property (nonatomic, strong) NSMutableDictionary *gameMapperDictionary;

@end

NS_ASSUME_NONNULL_END
