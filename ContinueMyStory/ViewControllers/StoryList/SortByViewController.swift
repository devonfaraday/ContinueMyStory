//
//  SortByViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/21/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import UIKit

class SortByViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let sortByTypes: [SortByType] = [.name, .newest, .oldest, .top, .featured, .category]
    var delegate: SortTypeSelectable?

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortByTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .sortyByCellIdentifier, for: indexPath)
        cell.textLabel?.text = sortByTypes[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sortBy = sortByTypes[indexPath.row]
        delegate?.sortByFinished(withValue: sortBy)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol SortTypeSelectable: class {
    func sortByFinished(withValue value: SortByType)
}
