//
//  HKFilterManager.m
//  Hankai
//
//  Created by 韩凯 on 3/24/14.
//  Copyright (c) 2014 Hankai. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the “Software”), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "HKFilterManager.h"
#import "UIImage+LangExt.h"

//内建的滤镜都是通过CoreImage实现的
@interface GICoreImageFilter : NSObject <HKFilterComponent> {
    CIVector *      _rv;
    CIVector *      _gv;
    CIVector *      _bv;
    CIVector *      _av;
    NSArray *       _supportedFilterNames;
}

@end

@implementation GICoreImageFilter

@synthesize filterName = _filterName;//定义在接口中的property不能自动生成getter & setter

- (id)init {
    self = [super init];
    if (self != nil) {
        /*
         Filter.Bronze          古铜色
         Filter.Film            胶片
         Filter.Grayscale       黑白
         Filter.OldTime         老照片
         Filter.Impress         印象
         Filter.Japanese        日系
         Filter.Treasure        阿宝
         Filter.WhiteDelicate   粉嫩
         Filter.Wormwood        苦艾
         */
        _supportedFilterNames = @[@"Filter.Bronze", @"Filter.Film", @"Filter.Grayscale", @"Filter.OldTime",
                                  @"Filter.Impress", @"Filter.Japanese", @"Filter.Treasure", @"Filter.WhiteDelicate",
                                  @"Filter.Wormwood"];
    }
    return self;
}

- (void)bronze {
    _rv = [CIVector vectorWithString:@"[1.108343655086 -0.126891509287854 0.281708072736996 0.02]"];
    _gv = [CIVector vectorWithString:@"[-0.0114357545765432 1.10237866901967 0.0538144235962147 0.07]"];
    _bv = [CIVector vectorWithString:@"[-0.249436187281331 0.651223412063502 0.91821277521783 0.112]"];
    _av = [CIVector vectorWithString:@"[0 0 0 1]"];
}

- (void)film {
    _rv = [CIVector vectorWithString:@"[0.798129878219817 -0.036923752252823 0.138793874033006 0]"];
    _gv = [CIVector vectorWithString:@"[0.0505087867919643 0.881030573130298 -0.0315393599222624 0.01]"];
    _bv = [CIVector vectorWithString:@"[-0.0803003854445344 0.164212931938782 0.816087453505752 0.08]"];
    _av = [CIVector vectorWithString:@"[0 0 0 1]"];
}

- (void)grayscale {
    _rv = [CIVector vectorWithString:@"[0.3 0.59 0.11 0]"];
    _gv = [CIVector vectorWithString:@"[0.3 0.59 0.11 0]"];
    _bv = [CIVector vectorWithString:@"[0.3 0.59 0.11 0]"];
    _av = [CIVector vectorWithString:@"[0 0 0 1]"];
}

- (void)oldTime {
    _rv = [CIVector vectorWithString:@"[0.55059 0.59611 0.0033 0]"];
    _gv = [CIVector vectorWithString:@"[0.30059 0.74611 0 -0.04]"];
    _bv = [CIVector vectorWithString:@"[0.00059 0.59611 0.3033 -0.05]"];
    _av = [CIVector vectorWithString:@"[0 0 0 1]"];
}

- (void)impress {
    _rv = [CIVector vectorWithString:@"[1.3327396603539 -0.505208015190274 0.0724683548363732 0]"];
    _gv = [CIVector vectorWithString:@"[-0.187398764181987 1.18116473638179 -0.0937659721998039 0]"];
    _bv = [CIVector vectorWithString:@"[-0.315060138371619 -0.30891149358686 1.52397163195848 0]"];
    _av = [CIVector vectorWithString:@"[0 0 0 1]"];
}

- (void)japanese {
    _rv = [CIVector vectorWithString:@"[1.17650356463966 0.0789393757447161 0.0854429403843784 0]"];
    _gv = [CIVector vectorWithString:@"[0.0123519064208443 1.04591650606976 -0.0264354003510805 0.05]"];
    _bv = [CIVector vectorWithString:@"[0.0035662247797971 0.0631712991121841 1.14960507433239 0.04]"];
    _av = [CIVector vectorWithString:@"[0 0 0 1]"];
}

- (void)treasure {
    _rv = [CIVector vectorWithString:@"[0.413976437525616 0.186772148598797 1.57720428892682 0]"];
    _gv = [CIVector vectorWithString:@"[0.401716321597331 0.900141098043673 -0.251857419641004 0]"];
    _bv = [CIVector vectorWithString:@"[-0.365028012810659 1.82703494236592 0.112006929555263 0.01]"];
    _av = [CIVector vectorWithString:@"[0 0 0 1]"];
}

- (void)whiteDelicate {
    _rv = [CIVector vectorWithString:@"[0.885295577413144 0.0754633680341095 0.159241054552747 0]"];
    _gv = [CIVector vectorWithString:@"[0.109984815932407 1.02741600176475 -0.017400817697161 0]"];
    _bv = [CIVector vectorWithString:@"[-0.0256691404609986 0.284049559047626 0.861619581413372 0]"];
    _av = [CIVector vectorWithString:@"[0 0 0 1]"];
}

- (void)wormwood {
    _rv = [CIVector vectorWithString:@"[0.8 0 0 0.05]"];
    _gv = [CIVector vectorWithString:@"[0.05 0.95 0 0.008]"];
    _bv = [CIVector vectorWithString:@"[0.07 0.3 0.8 0]"];
    _av = [CIVector vectorWithString:@"[0 0 0 1]"];
}

- (void)setupParamsAccordingToFilterName {
    if ([_filterName isEqualToString:@"Filter.Bronze"]) {
        [self bronze];
    } else if ([_filterName isEqualToString:@"Filter.Film"]) {
        [self film];
    } else if ([_filterName isEqualToString:@"Filter.Grayscale"]) {
        [self grayscale];
    } else if ([_filterName isEqualToString:@"Filter.OldTime"]) {
        [self oldTime];
    } else if ([_filterName isEqualToString:@"Filter.Impress"]) {
        [self impress];
    } else if ([_filterName isEqualToString:@"Filter.Japanese"]) {
        [self japanese];
    } else if ([_filterName isEqualToString:@"Filter.Treasure"]) {
        [self treasure];
    } else if ([_filterName isEqualToString:@"Filter.WhiteDelicate"]) {
        [self whiteDelicate];
    } else if ([_filterName isEqualToString:@"Filter.Wormwood"]) {
        [self wormwood];
    } else {
        assert(NO);
    }
}

- (UIImage *)filterImage:(UIImage *)srcImage {
    [self setupParamsAccordingToFilterName];
    CIFilter * filter = [CIFilter filterWithName:@"CIColorMatrix"
                                   keysAndValues:kCIInputImageKey, [srcImage toCIImage],
                                                 @"inputRVector", _rv,
                                                 @"inputGVector", _gv,
                                                 @"inputBVector", _bv,
                                                 @"inputAVector", _av, nil];
    CIContext * context = [CIContext contextWithOptions:NULL];
    CIImage * outputImage = filter.outputImage;
    CGRect imgRect = [outputImage extent];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:imgRect];
    UIImage * retImage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    return retImage;
}

- (NSArray *)supportedFilters {
    return _supportedFilterNames;
}

- (BOOL)canProcessImageWithFilterNamed:(NSString *)name {
    return [_supportedFilterNames containsObject:name];
}

@end


#define SAFECOLOR(color) MIN(255,MAX(0,color))

@interface GILomoFilter : NSObject <HKFilterComponent>

@end

@implementation GILomoFilter

- (UIImage *)filterImage:(UIImage *)srcImage {
    CIImage * inputImage = [srcImage toCIImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef inImage = [context createCGImage:inputImage fromRect:[inputImage extent]];
    CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    
    int length = (int)CFDataGetLength(m_DataRef);
    CFMutableDataRef m_DataRefEdit = CFDataCreateMutableCopy(NULL, length, m_DataRef);
    UInt8 *m_PixelBuf = (UInt8 *) CFDataGetMutableBytePtr(m_DataRefEdit);
    
    /***************************************************/
    size_t width = CGImageGetWidth(inImage);
    size_t height = CGImageGetHeight(inImage);
    size_t bytesPerRow = CGImageGetBytesPerRow(inImage);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(inImage);
    size_t BitsPerComponent = CGImageGetBitsPerComponent(inImage);
    size_t bytesPerPixel = bitsPerPixel / BitsPerComponent;
    
    int ratio = (int)(width > height ? height * 32768 / width : width * 32768 / height);
    
    int cx = (int)(width >> 1);
    int cy = (int)(height >> 1);
    int max = cx * cx + cy * cy;
    int min = (int) (max * 0.2);
    int diff = max - min;
    
    int ri, gi, bi;
    int dx, dy, distSq, v;
    
    int R, G, B;
    int newR, newG, newB;
    
    int value;
    
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int offset = (int)(y * bytesPerRow + x * bytesPerPixel);
            R = m_PixelBuf[offset];
            G = m_PixelBuf[offset + 1];
            B = m_PixelBuf[offset + 2];
            
            value = R < 128 ? R : 256 - R;
            newR = (value * value * value) / 64 / 256;
            newR = (R < 128 ? newR : 255 - newR);
            
            value = G < 128 ? G : 256 - G;
            newG = (value * value) / 128;
            newG = (G < 128 ? newG : 255 - newG);
            
            newB = (B >> 1) + 0x25;
            
            /* Edge Mark */
            dx = cx - x;
            dy = cy - y;
            if (width > height) {
                dx = (dx * ratio) >> 15;
            } else {
                dy = (dy * ratio) >> 15;
            }
            
            distSq = dx * dx + dy * dy;
            
            if (distSq > min) {
                v = ((max - distSq) << 8) / diff;
                v *= v;
                
                ri = (newR * v) >> 16;
                gi = (newG * v) >> 16;
                bi = (newB * v) >> 16;
                
                newR = SAFECOLOR(ri);
                newG = SAFECOLOR(gi);
                newB = SAFECOLOR(bi);
            }
            
            m_PixelBuf[offset] = newR;
            m_PixelBuf[offset + 1] = newG;
            m_PixelBuf[offset + 2] = newB;
        }
    }
    
    /***************************************************/
    
    CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,
                                             
                                             CGImageGetWidth(inImage),
                                             
                                             CGImageGetHeight(inImage),
                                             
                                             CGImageGetBitsPerComponent(inImage),
                                             CGImageGetBytesPerRow(inImage),
                                             
                                             CGImageGetColorSpace(inImage),
                                             
                                             CGImageGetBitmapInfo(inImage)
                                             );
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    
    CGContextRelease(ctx);
    CIImage *finalImage = [CIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGImageRelease(inImage);
    CFRelease(m_DataRef);
    CFRelease(m_DataRefEdit);
    
    CGRect imgRect = [finalImage extent];
    CGImageRef cgimg = [context createCGImage:finalImage fromRect:imgRect];
    UIImage * retImage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    return retImage;
}

- (NSArray *)supportedFilters {
    //Filter.Lomo            LOMO风格
    return @[@"Filter.Lomo"];
}

- (BOOL)canProcessImageWithFilterNamed:(NSString *)name {
    return [name isEqualToString:@"Filter.Lomo"];
}

@end




@implementation HKFilterManager


+ (id)sharedManager {
    static HKFilterManager * fm = nil;
    
    if (fm == nil) {
        fm = [HKFilterManager new];
        fm->_filters = [NSMutableArray array];
        
        //添加内建的滤镜效果
        [fm->_filters addObject:[GICoreImageFilter new]];
        [fm->_filters addObject:[GILomoFilter new]];
    }
    
    return fm;
}

+ (NSArray *)availableFilterNames {
    NSMutableArray * names = [NSMutableArray array];
    HKFilterManager * manager = [HKFilterManager sharedManager];
    for (id<HKFilterComponent> filter in manager->_filters) {
        [names addObjectsFromArray:[filter supportedFilters]];
    }
    return names;
}

+ (BOOL)isFilterAvailable:(NSString *)name {
    HKFilterManager * manager = [HKFilterManager sharedManager];
    for (id<HKFilterComponent> filter in manager->_filters) {
        if ([filter canProcessImageWithFilterNamed:name]) {
            return YES;
        }
    }
    
    return NO;
}

+ (void)registerFilter:(id<HKFilterComponent>)filter {
    assert([filter conformsToProtocol:@protocol(HKFilterComponent)]);
    HKFilterManager * manager = [HKFilterManager sharedManager];
    [manager->_filters addObject:filter];
}

+ (void)removeFilter:(id<HKFilterComponent>)filter {
    assert([filter conformsToProtocol:@protocol(HKFilterComponent)]);
    HKFilterManager * manager = [HKFilterManager sharedManager];
    [manager->_filters removeObject:filter];
}

+ (UIImage *)processImage:(UIImage *)srcImage withFilterNamed:(NSString *)filterName {
    HKFilterManager * manager = [HKFilterManager sharedManager];
    for (id<HKFilterComponent> filter in manager->_filters) {
        if ([filter canProcessImageWithFilterNamed:filterName]) {
            if ([filter respondsToSelector:@selector(setFilterName:)]) {
                [filter setFilterName:filterName];
            }
            return [filter filterImage:srcImage];
        }
    }
    
    return nil;
}


@end
