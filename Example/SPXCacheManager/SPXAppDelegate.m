//
//  SPXAppDelegate.m
//  SPXCacheManager
//
//  Created by CocoaPods on 01/11/2015.
//  Copyright (c) 2014 Shaps Mohsenin. All rights reserved.
//

#import "SPXAppDelegate.h"
#import "SPXCacheManager.h"

static NSString * const MemoryCache = @"MemoryCache";

@implementation SPXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self setResource];
  [self getResource];
  [self simple];
  
  return YES;
}

- (void)contexts
{
  id context = nil;
  SPXCache *cache = [SPXCacheManager cacheNamed:@"Contexts"];
  
  cache[@"story1234"] = context;
  context = cache[@"story1234"];
}

- (void)networkResource
{
  SPXCache *cache = [SPXCacheManager cacheNamed:@"Contexts"];
  cache = [SPXCache cacheWithStores:[NSSet setWithObjects:[SPXCache new], nil]];
}

- (void)setResource
{
  SPXCache *cache = [SPXCacheManager defaultCache];
  SPXResourceEntity *entity = nil;
  
  NSString *identifier = @"http://google.com";
  UIImage *image = [UIImage imageNamed:@"image"];
  
  entity = [cache addResource:image];
  entity = [cache setResource:image withIdentifier:identifier];
  
  entity = cache[identifier];
  cache[identifier] = image;
}

- (void)getResource
{
  SPXCache *cache = [SPXCacheManager defaultCache];
  SPXResourceEntity *entity = nil;
  
  id <SPXResource> image = nil;
  NSString *identifier = @"http://google.com";
  
  entity = [cache entityForIdentifier:identifier];
  image = entity.resource;
}

- (void)simple
{
  NSString *identifier = @"http://google.com";
  
  SPXCache *cache = [SPXCacheManager defaultCache];
  
  cache[identifier] = [UIImage imageNamed:@"image"];
  SPXResourceEntity *entity = cache[identifier];
  NSLog(@"%@", entity);
  
  [cache setProcessCacheBlock:^(SPXResourceEntity *entity) {
    NSLog(@"%@", entity);
  }];
}

@end

