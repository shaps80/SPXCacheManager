/*
   Copyright (c) 2014 Francesco Petrungaro. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY Francesco Petrungaro `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Francesco Petrungaro OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef __SNIPPEX_DEFINES
#define __SNIPPEX_DEFINES

#import <objc/runtime.h>

/**
 *  Use these in your code
 */

#define keyPath(keyPath) _keyPath(self, keyPath)
#define keyPathT(target, keyPath) _keyPath(target, keyPath)
#define keyPathI(ivar) _keyPathI(ivar)
#define keyValue(target, keyPath) _keyValue(target, keyPath)
#define keyValueI(ivar) _keyValueI(ivar)
#define description(...) _descriptionT(self, ##__VA_ARGS__)
#define descriptionT(target, ...) _descriptionT(target, ##__VA_ARGS__)


/**
 *  These are intended for internal use only!
 */

#define _OBJC_STRINGIFY(x) @#x
#define _STRINGIFY(x) #x


#define _keyPath(target_, keyPath_) \
(((void)(NO && ((void)target_.keyPath_, NO)), _STRINGIFY(keyPath_)))

#define _keyPathI(ivar_) \
(((void)(NO && ((void)ivar_, NO)), _OBJC_STRINGIFY(ivar_)))

#define _keyValue(target_, keyPath_) \
_OBJC_STRINGIFY(keyPath_) : (target_.keyPath_) ?: @"nil"

#define _keyValueI(ivar_) \
_OBJC_STRINGIFY(ivar_) : (ivar_) ?: @"nil"

#define _descriptionT(target_, ...) [super.description stringByAppendingFormat:@"%@", [[target_ dictionaryWithValuesForKeys:@[ __VA_ARGS__ ]] description]]



/**
 *  This function determines if the specified object is a meta class or an actual instance
 *
 *  @param objOrClass The object or class to test
 *
 *  @return YES if the object is a meta class, NO otherwise
 */
static inline BOOL isMetaClass(id objOrClass)
{
  Class theClass = object_getClass(objOrClass);
  return class_isMetaClass(theClass);
}


#endif


