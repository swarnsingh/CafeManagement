/**
 *  @author Swarn Singh.
 */

import UIKit

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (orderDetail?.products.count)!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let order = orderDetail?.products[indexPath.section]
        
        if indexPath.section != 1 {
            let productQuantity = cell?.viewWithTag(101) as! UILabel
            let productItem = cell?.viewWithTag(102) as! UILabel
            let productPrice = cell?.viewWithTag(103) as! UILabel
            
            productQuantity.text = "\(order?.quantity ?? 0)x"
            productItem.text = order?.name
            let total = Double((order?.quantity)!) * (order?.price)!
            productPrice.text = "\(total)"
            
            cell?.selectionStyle = .none
        }
        return cell!
    }
}
