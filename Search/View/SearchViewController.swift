//
//  SearchViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 07/02/2022.
//

import UIKit

class SearchViewController: BaseViewController, UISearchBarDelegate {
    var searchVM: SearchVM = SearchVM()
    @IBOutlet weak var fieldSearch: UISearchBar!
    @IBOutlet weak var TBVSearch: UITableView!
    var time: Double = 0
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tìm kiếm"
        TBVSearch.register(UINib(nibName: "SearchShoesCell", bundle: nil), forCellReuseIdentifier: "SearchShoesCell")
        showLoading()
        searchVM.searchVM(text: "") {
            self.dismisLoading()
            self.TBVSearch.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        time = Date().timeIntervalSinceReferenceDate
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let timeNow = Date().timeIntervalSinceReferenceDate
        if timeNow - time < 1 {
            timer.invalidate()
        }
        time = timeNow
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [self] _ in
            print(1)
            searchVM.searchVM(text: searchText) {
                self.TBVSearch.reloadData()
            }
        })
    }
}

@available(iOS 13.0, *)
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TBVSearch.frame.height/5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchVM.listSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TBVSearch.dequeueReusableCell(withIdentifier: "SearchShoesCell") as? SearchShoesCell
        cell?.filldata(searchVM.listSearch[indexPath.row])
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = TBVSearch.dequeueReusableCell(withIdentifier: "SearchShoesCell", for: indexPath) as? SearchShoesCell
        self.pushView(storybard: UIStoryboard(name: "TabBar", bundle: nil),
                      nextView: DetailsViewController.self) { view in
            view.detailVM.mainProduct = self.searchVM.listSearch[indexPath.row]
        }
    }
}
