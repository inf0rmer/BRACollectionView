//
//  ViewController.m
//  BRACollectionViewExample
//
//  Created by Bruno Abrantes on 22/09/14.
//
//

#import "ViewController.h"
#import <BRACollectionView/BRACollectionViewCell.h>

@interface ViewController ()

@property (nonatomic, strong) NSArray *data;

@end

@implementation ViewController

static NSString *imageCellIdentifier = @"ImageCell";
static NSString *mapCellIdentifier = @"MapCell";
static NSString *kTypeMap = @"map";
static NSString *kTypeImage = @"image";

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  self.data = @[
                 @{
                   @"title": @"This is a cell with an image",
                   @"subtitle": @"This is a subtitle for this cell. It can break in two lines just in case it's too long.",
                   @"image": [UIImage imageNamed:@"kitten"],
                   @"type": kTypeImage
                   },
                 @{
                   @"title": @"This is a cell with a map",
                   @"subtitle": @"This is a subtitle for this cell. It can break in two lines just in case it's too long.",
                   @"coordinates": @{ @"lat": @(52.52426800), @"lon": @(13.40629000) },
                   @"type": kTypeMap
                   }
                 ];
  
  BRACollectionView *collectionView = [[BRACollectionView alloc] initWithFrame:self.view.bounds];
  collectionView.backgroundColor = UIColor.whiteColor;
  collectionView.delegate = self;
  collectionView.dataSource = self;
  
  self.view = collectionView;
  [collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - BRACollectionViewDelegate

- (CGFloat)collectionView:(BRACollectionView *)collectionView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 120.f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  NSLog(@"number of views :%lu", (unsigned long)self.view.subviews.count);
}

- (void)collectionView:(BRACollectionView *)collectionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Tapped cell at index path: %ld", (long)indexPath.row);
}

#pragma mark - BRACollectionViewDataSource

- (BRACollectionViewCell *)collectionView:(BRACollectionView *)collectionView
                    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *item = [self.data objectAtIndex:indexPath.row];
  
  BOOL isMap = [item[@"type"] isEqualToString:kTypeMap];
  NSString *cellIdentifier = (isMap) ? mapCellIdentifier : imageCellIdentifier;
  BRACollectionViewStyle style = (isMap) ? BRACollectionViewStyleMap : BRACollectionViewStyleImage;
  
  BRACollectionViewCell *cell = [collectionView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (cell == nil) {
    cell = [[BRACollectionViewCell alloc] initWithStyle:style reuseIdentifier:cellIdentifier];
  }
  
  cell.backgroundColor = UIColor.whiteColor;
  
  cell.titleLabel.text = item[@"title"];
  cell.detailLabel.text = item[@"subtitle"];
  
  if (isMap) {
    double lat = [(NSNumber *) item[@"coordinates"][@"lat"] doubleValue];
    double lon = [(NSNumber *) item[@"coordinates"][@"lon"] doubleValue];
    
    [cell.mapView setCenterCoordinate:CLLocationCoordinate2DMake(lat, lon) animated:YES];
  } else {
    cell.imageView.image = item[@"image"];
  }
  
  return cell;
}

- (NSInteger)numberOfRowsForCollectionView:(BRACollectionView *)collectionView
{
  return self.data.count;
}

@end
