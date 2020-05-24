//
//  LuckyWheel.m
//  转盘Demo
//
//  Created by JackX on 2020/5/21.
//  Copyright © 2020 App. All rights reserved.
//

#import "LuckyWheel.h"
#define perSection    M_PI*2/12
@interface LuckyWheel()<CAAnimationDelegate>
@property(nonatomic,strong)UIImageView *wheelImgV;
@property(nonatomic,strong)CADisplayLink *playLink;
@property(nonatomic,strong)NSArray    *Anglearr;
@property(nonatomic,assign)CGFloat     circleAngle;
@property(nonatomic,assign)NSInteger Index;
//是否正在抽奖中
@property(nonatomic,assign)BOOL IsAnimation;
@end
@implementation LuckyWheel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self SetupView];
    }
    return self;
}

- (NSArray*)Anglearr{
    if (!_Anglearr) {
        _Anglearr = @[@"狮子",
                      @"巨蟹",
                      @"双子",
                      @"金牛",
                      @"白羊",
                      @"双鱼",
                      @"水瓶",@"摩羯",@"射手",@"天蝎",@"天枰",@"处女"];
    }
    return _Anglearr;
}

-(void)SetupView{
    //设置有多少个选择
    int number = 12;

    UIImageView *Imagview = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,
self.frame.size.height)];
    
    Imagview.image = [UIImage imageNamed:@"LuckyRotateWheel"];
    
    Imagview.userInteractionEnabled = YES;
    
    [self addSubview:Imagview];
    
     CGFloat angle = M_PI / (number / 2);
    
    //怎么根据角度算出每个之前差距的距离
     CGFloat BtnW = (M_PI*(Imagview.frame.size.height-30) - (15*number))/number;
    
     CGFloat BtnH = (Imagview.frame.size.height-30)/2;
    
    // 取得星座图片总图
    UIImage *sumImage = [UIImage imageNamed:@"LuckyAstrology"];
        
//    UIImage *sumImageSelected = [UIImage imageNamed:@"LuckyAstrologyPressed"];
    
    CGFloat conImageWidth = sumImage.size.width / number * 2;
     
    CGFloat conImageHeight = sumImage.size.height * 2;
    
    CGFloat conImageX,conImageY = 0;
    
    for (int i = 0; i < number ; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(0, 0 , BtnW, BtnH);
//
        btn.layer.anchorPoint = CGPointMake(0.5, 1);
         
        btn.center = CGPointMake(Imagview.center.x, Imagview.center.y);
        
//        btn.backgroundColor = UIColor.greenColor;
        
        //使用CoreGraphic分割图片,等到独立的星座小图
        conImageX = i * conImageWidth;
        //分割后的图片
        UIImage *conImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(sumImage.CGImage, CGRectMake(conImageX, conImageY, conImageWidth, conImageHeight))];
        
        [btn setImage:conImage forState:UIControlStateNormal];
        
        btn.imageEdgeInsets = UIEdgeInsetsMake(20,
                                               15,
                                               20+btn.imageView.frame.size.height,
                                               15);
        
        btn.transform = CGAffineTransformMakeRotation(angle * i);
        
        [Imagview addSubview:btn];

    }
    
    //设置选中按钮
     UIButton *centerbtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    
     centerbtn.frame = CGRectMake(0,
                                  0,
                                  Imagview.frame.size.width*.16,
                                  Imagview.frame.size.height*.24);
    
     centerbtn.center = Imagview.center;
    
     [centerbtn setBackgroundImage:[UIImage imageNamed:@"LuckyCenterButton"] forState:UIControlStateNormal];
    
    [centerbtn addTarget:self
               action:@selector(startChoose)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:centerbtn];
    
    self.wheelImgV = Imagview;
    
}

//开启定时器
-(void)StartRotation{
if (self.playLink)return;
   self.playLink = [CADisplayLink displayLinkWithTarget:self          selector:@selector(luckyWheelRotate)];
   [self.playLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}


//释放定时器，结束旋转
-(void)StopRotation{
    [self.playLink invalidate];
     self.playLink = nil;
}


//旋转方法
-(void)luckyWheelRotate{
    self.wheelImgV.transform = CGAffineTransformRotate(self.wheelImgV.transform,M_PI_4/200);
//    NSLog(@"%lf",self.wheelImgV.transform.a);
}



-(void)startChoose{
    //如果为YES，那么则返回
    if (self.IsAnimation) {
        return;
    }
    
      self.IsAnimation = YES;
    
      [self StopRotation];
    
    //self.Index   为后台传入的奖品下标,根据项目需求改
      self.Index = arc4random()%12;
    
    CGFloat  currentwhellRoate = atan2f(self.wheelImgV.transform.b, self.wheelImgV.transform.a);
    
    CGFloat roateangle = M_PI * 2 -  currentwhellRoate;
     
    //4 是圈数 可以根据项目需求改
    self.circleAngle = roateangle + M_PI * 2 * 4 + currentwhellRoate + perSection * self.Index;
    
    CABasicAnimation *anim = [[CABasicAnimation alloc]init];
    anim.keyPath =@"transform.rotation";
    anim.toValue = @(self.circleAngle);
    anim.delegate = self;
    anim.duration = 5.0;
        //由快变慢
    anim.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.wheelImgV.layer addAnimation:anim forKey:nil];
}

 
//动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
        NSLog(@"当前选中%@",self.Anglearr[self.Index]);
    
     self.wheelImgV.transform = CGAffineTransformMakeRotation(self.circleAngle);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
         self.IsAnimation = NO;
        
        [self StartRotation];
        
    });
//
    
    
}


@end
