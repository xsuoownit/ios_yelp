//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpBusiness.h"
#import "BusinessCell.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *businesses;
@property (strong, nonatomic) NSArray *filteredBusinesses;

@end

@implementation MainViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [YelpBusiness searchWithTerm:@"Restaurants"
                            sortMode:YelpSortModeBestMatched
                          categories:@[@"burgers"]
                               deals:NO
                          completion:^(NSArray *businesses, NSError *error) {
                              self.businesses = businesses;
                              self.filteredBusinesses = businesses;
                              [self.tableView reloadData];
                          }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    
    self.tableView.estimatedRowHeight = 140;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIColor *navigationBarTintColor = [UIColor colorWithRed:191/255.0 green:25/255.0 blue:0 alpha:1];
    [self.navigationController.navigationBar setBarTintColor:navigationBarTintColor];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"Restaurants";
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Filter" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
    [button.layer setCornerRadius:4.0f];
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    button.frame=CGRectMake(0.0, 100.0, 60.0, 28.0);
    [button addTarget:self action:@selector(onFilterTapped)  forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = filterButton;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)onFilterTapped {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredBusinesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.filteredBusinesses[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.filteredBusinesses = self.businesses;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
        self.filteredBusinesses = [self.businesses filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];
}

- (void)hideKeyboard {
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
