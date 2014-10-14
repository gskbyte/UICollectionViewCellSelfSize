#import "XNGTextCollectionViewController.h"

#import "XNGChiquitoIpsum.h"
#import <Masonry/Masonry.h>

#import <objc/runtime.h>

const static NSUInteger XNGNumTextCells = 10000;

@interface XNGTextCell : UICollectionViewCell

@property (nonatomic) UILabel * textLabel;

+ (CGSize)sizeForText:(NSString*)text;

@end

@interface XNGTextCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSMutableArray * texts;

@end

@implementation XNGTextCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:XNGTextCell.class
            forCellWithReuseIdentifier:NSStringFromClass(XNGTextCell.class)];
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    if([flow respondsToSelector:@selector(setEstimatedItemSize:)]) {
        flow.estimatedItemSize = CGSizeMake(100, 50); // if collectionView:layout:sizeForItemAtIndexPath is implemented, does not do anything
    }
    flow.minimumInteritemSpacing = 2;
    flow.minimumLineSpacing = 2;

    self.texts = [NSMutableArray arrayWithCapacity:XNGNumTextCells];
    for(NSUInteger i=0; i<XNGNumTextCells; ++i) {
        NSUInteger numWords = 1 + arc4random_uniform(13);
        [self.texts addObject:[XNGChiquitoIpsum stringWithWordCount:numWords]];
    }

    NSLog(@"End of text generation");
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return XNGNumTextCells;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XNGTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(XNGTextCell.class)
                                                                  forIndexPath:indexPath];
    cell.textLabel.text = self.texts[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.texts[indexPath.row];
    return [XNGTextCell sizeForText:text];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if([UIDevice.currentDevice.systemVersion hasPrefix:@"8"] &&
       aSelector == @selector(collectionView:layout:sizeForItemAtIndexPath:)) {
        return NO;
    }

    return [super respondsToSelector:aSelector];
}


@end


@implementation XNGTextCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        // should NEVER be visible
        self.backgroundColor = [UIColor greenColor];

        // content view
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.greaterThanOrEqualTo(@50);
            make.width.lessThanOrEqualTo(@120);
        }];
        self.contentView.backgroundColor = [UIColor yellowColor];

        // text label, dynamic
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.numberOfLines = 10;
        self.textLabel.font = [UIFont systemFontOfSize:10];
        self.textLabel.backgroundColor = [UIColor orangeColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(8, 8, 8, 8));
        }];
    }
    return self;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *size = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];

    // computed size can be changed here, but should not be necessary

    return size;
}

// called for cells with autolayout
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize {
    CGSize size = [super systemLayoutSizeFittingSize:targetSize];

    return size;
}

// called if no autolayout is used
- (CGSize)sizeThatFits:(CGSize)targetSize {
    CGSize size = [super sizeThatFits:targetSize];

    return size;
}

+ (CGSize)sizeForText:(NSString*)text {
    static XNGTextCell * cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[XNGTextCell alloc] initWithFrame:CGRectZero];
    });
    cell.textLabel.text = text;
    [cell layoutSubviews];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size;
}

@end