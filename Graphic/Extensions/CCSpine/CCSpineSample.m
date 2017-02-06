/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 Ricardo Quesada
 * Copyright (c) 2011 Zynga Inc.
 * Copyright (c) 2013-2014 Cocos2D Authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "CCSpineSample.h"

// ----------------------------------------------------------------------------------------------

@implementation CCSpineSample

// ----------------------------------------------------------------------------------------------

+ (instancetype)sampleWithDictionary:(NSDictionary *)dict andType:(CCSpineSampleType)type
{
    return([[CCSpineSample alloc] initDictionary:dict andType:type]);
}

// ----------------------------------------------------------------------------------------------

- (instancetype)initDictionary:(NSDictionary *)dict andType:(CCSpineSampleType)type
{
    self = [super init];
    
    _time = [dict readFloat:@"time" def:0];
    _type = type;
    _data = (CCSpineBoneData){ { 0, 0 }, 0, { 1, 1 } };
    switch (type)
    {
        case CCSpineSampleTypeRotate:
            _data.rotation = [dict readFloat:@"angle" def:0];
            while (_data.rotation < -180) _data.rotation += 360;
            while (_data.rotation > 180) _data.rotation -= 360;
            break;
            
        case CCSpineSampleTypeTranslate:
            _data.position.x = [dict readFloat:@"x" def:0];
            _data.position.y = [dict readFloat:@"y" def:0];
            break;
            
        case CCSpineSampleTypeScale:
            _data.scale.x = [dict readFloat:@"x" def:1];
            _data.scale.y = [dict readFloat:@"y" def:1];
            break;
            
        case CCSpineSampleTypeColor:
        {
            CCColor *color = [dict readColor:@"" def:[CCColor whiteColor]];
            _data.color = (ccColor4F){color.red, color.green, color.blue, color.alpha};
            break;
        }
    }
    
    // load curve
    _curve = [CCSpineCurve bezierCurveWithDictionary:dict];
    
    // done
    return(self);
}

// ----------------------------------------------------------------------------------------------

@end










































