//
//  ImageDownloaderService.h
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/27/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageDownloaderService : NSObject

- (NSURLSessionTask *)imageWithURL:(NSURL *)url
                           success:(void (^)(NSImage *image))success
                           failure:(void (^)(NSError *error))failure;

@property(nonatomic, strong) NSURLSession *imageSession;

@end

NS_ASSUME_NONNULL_END
