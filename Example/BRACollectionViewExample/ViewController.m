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

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation ViewController

static NSString *cellIdentifier = @"Cell";

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  self.data = [@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17"] mutableCopy];
  
  BRACollectionView *collectionView = [[BRACollectionView alloc] initWithFrame:self.view.bounds];
  collectionView.backgroundColor = UIColor.yellowColor;
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
  BRACollectionViewCell *cell = [collectionView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (cell == nil) {
    cell = [[BRACollectionViewCell alloc] initWithReusableIdentifier:cellIdentifier];
  }
  
  cell.backgroundColor = UIColor.redColor;
  cell.nameLabel.text = [self.data objectAtIndex:indexPath.row];
  
  return cell;
}

- (NSInteger)numberOfRowsForCollectionView:(BRACollectionView *)collectionView
{
  return self.data.count;
}

@end
