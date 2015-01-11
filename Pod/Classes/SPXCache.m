/*
   Copyright (c) 2015 Shaps Mohsenin. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY Shaps Mohsenin `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Shaps Mohsenin OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SPXCache.h"
#import "SnippexDefines.h"

@interface SPXResourceEntity (Private)
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, strong) NSURL *localURL;
- (id)rawResource;
@end

@interface SPXCache () <SPXResourceEntityDelegate>
@property (nonatomic, strong) NSArray *stores;
@property (nonatomic, strong) NSMutableDictionary *entityMapping;
@end

@implementation SPXCache

+ (instancetype)cacheWithStores:(NSSet *)stores
{
  for (id <SPXCacheStore> store in stores) {
    NSAssert([store conformsToProtocol:@protocol(SPXCacheStore)], @"Objects must conform to SPXCacheStore");
  }
  
  SPXCache *cache = [SPXCache new];
  cache.stores = stores.allObjects;
  
  return cache;
}

- (id)resourceForEntity:(SPXResourceEntity *)entity
{
  if (self.processCacheBlock) {
    return self.processCacheBlock;
  }
  
  return entity.rawResource;
}

- (NSMutableDictionary *)entityMapping
{
  return _entityMapping ?: (_entityMapping = [NSMutableDictionary new]);
}

- (NSArray *)entities
{
  return self.entityMapping.allValues;
}

- (BOOL)isResourceAvailableForEntity:(SPXResourceEntity *)entity
{
  return entity.isLoaded;
}

- (SPXResourceEntity *)entityForIdentifier:(id<SPXResourceIdentifier>)identifier
{
  SPXResourceEntity *entity = self.entityMapping[identifier];
  entity.delegate = self;
  return entity;
}

- (SPXResourceEntity *)addResource:(id<SPXResource>)resource
{
  SPXResourceEntity *entity = [SPXResourceEntity entityForResource:resource];
  self.entityMapping[entity.identifier] = entity;
  return entity;
}

- (SPXResourceEntity *)addResourceForURL:(NSURL *)URL
{
  SPXResourceEntity *entity = [SPXResourceEntity entityForURL:URL];
  self.entityMapping[entity.identifier] = entity;
  return entity;
}

- (SPXResourceEntity *)setResource:(id<SPXResource>)resource withIdentifier:(id<SPXResourceIdentifier>)identifier
{
  SPXResourceEntity *entity = self.entityMapping[identifier];
  
  if (!entity) {
    entity = [SPXResourceEntity entityForResource:resource identifier:identifier];
    self.entityMapping[identifier] = entity;
  }
  
  return entity;
}

- (void)removeResourceForEntity:(SPXResourceEntity *)entity
{
  NSError *error = nil;
  
  if (![[NSFileManager defaultManager] removeItemAtURL:entity.localURL error:&error]) {
    NSLog(@"%@", error);
  }
  
  self.entityMapping[entity.identifier] = nil;
}

- (void)setObject:(id<SPXResource>)resource forKeyedSubscript:(id<SPXResourceIdentifier>)identifier
{
  [self setResource:resource withIdentifier:identifier];
}

- (SPXResourceEntity *)objectForKeyedSubscript:(id<SPXResourceIdentifier>)identifier
{
  return [self entityForIdentifier:identifier];
}

- (NSString *)entityIdentifiers
{
  return [self.entities valueForKey:@"identifier"];
}

- (NSString *)description
{
  return description(@keyPath(entityIdentifiers));
}

@end

