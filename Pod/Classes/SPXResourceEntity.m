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

#import "SPXResourceEntity.h"
#import "SPXResourceIdentifier.h"
#import "SnippexDefines.h"
#import "SPXEncodingDefines.h"

@interface SPXResourceEntity ()

@property (nonatomic, strong) id <SPXResourceIdentifier> identifier;
@property (nonatomic, strong) id <SPXResource> resource;

@property (nonatomic, strong) NSURL *localURL;
@property (nonatomic, strong) NSURL *remoteURL;
@property (nonatomic, assign) BOOL isLoaded;

@end

@implementation SPXResourceEntity

+ (instancetype)entityForURL:(NSURL *)URL
{
  SPXResourceEntity *entity = [SPXResourceEntity new];
  entity.remoteURL = URL;
  entity.identifier = [NSUUID UUID].UUIDString;
  return entity;
}

+ (instancetype)entityForURL:(NSURL *)URL identifier:(id <SPXResourceIdentifier>)identifier
{
  SPXResourceEntity *entity = [SPXResourceEntity new];
  entity.remoteURL = URL;
  entity.identifier = identifier;
  return entity;
}

+ (instancetype)entityForResource:(id <SPXResource>)resource
{
  SPXResourceEntity *entity = [SPXResourceEntity new];
  entity.resource = resource;
  entity.identifier = [NSUUID UUID].UUIDString;
  return entity;
}

+ (instancetype)entityForResource:(id <SPXResource>)resource identifier:(id <SPXResourceIdentifier>)identifier
{
  SPXResourceEntity *entity = [SPXResourceEntity new];
  entity.resource = resource;
  entity.identifier = identifier;
  return entity;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super init];
  if (!self) return nil;
  
  decode(identifier);
  decode(localURL);
  decode(remoteURL);
  decode(resource);
  
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  encode(identifier);
  encode(localURL);
  encode(remoteURL);
  encode(resource);
}

- (id <SPXResource>)rawResource
{
  return _resource;
}

- (id <SPXResource>)resource
{
  id resource = _resource;
  
  if (resource && [self.delegate respondsToSelector:@selector(resourceForEntity:)]) {
    resource = [self.delegate resourceForEntity:self];
  }
  
  return resource;
}

- (NSString *)loaded
{
  return self.isLoaded ? @"YES" : @"NO";
}

- (NSString *)description
{
  return description(@keyPath(resource), @keyPath(localURL), @keyPath(remoteURL), @keyPath(loaded), @keyPath(identifier));
}

@end


