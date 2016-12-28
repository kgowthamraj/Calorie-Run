//
//  ViewController.m
//  calorieRun
//
//  Created by Gowthamraj K on 24/12/16.
//  Copyright © 2016 gowtham. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _addListImage.hidden = YES;
    
    
    
   
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    _getUserDetailArray = [Coredata fetchUserDetails];
    
    if(_getUserDetailArray.count == 0)
    {
        _addListImage.hidden = NO;
        _DetailTableView.hidden = YES;
        
    }else{
        _DetailTableView.hidden = NO;

        _DetailTableView.delegate = self;
        _DetailTableView.dataSource = self;
        [_DetailTableView reloadData];
    }
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _getUserDetailArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _DetailTableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    self.DetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.alwaysBounceVertical = NO;
    
    static NSString *CellIdentifier = @"detailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel * timeUserLabel = (UILabel*)[cell viewWithTag:1];
    UILabel * distanceUserLabel = (UILabel*)[cell viewWithTag:2];
    UILabel * calorieUserLabel = (UILabel*)[cell viewWithTag:3];
  //  UILabel * indexUserLabel = (UILabel*)[cell viewWithTag:4];
    
     _getUserDetail = [_getUserDetailArray objectAtIndex:indexPath.row];
   timeUserLabel.text = _getUserDetail.usertimer;
    distanceUserLabel.text = _getUserDetail.userdistance;
    calorieUserLabel.text = _getUserDetail.usercalorie;
    
    
    
//    indexUserLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    
    
 
    
      return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [Coredata deleteUserDetail:indexPath.row];
        
        [_getUserDetailArray removeObjectAtIndex:indexPath.row];
        [_DetailTableView reloadData];
      
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _getUserDetail   = [_getUserDetailArray objectAtIndex:indexPath.row];
    _sendIndexvalue = indexPath.row;
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

#pragma mark - UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"googleSegue"])
    {
        _googlecontroller = [segue destinationViewController];
    }else  if ([[segue identifier] isEqualToString:@"detailSegue"])
    {
        _detailController = [segue destinationViewController];
        _detailController.showUserDetail = _getUserDetail;
        _detailController.getIndexvalue = _sendIndexvalue;
    }

}


- (IBAction)detailPageAction:(id)sender {
    
    [self performSegueWithIdentifier:@"googleSegue" sender:self];
    
    
    
}
@end
