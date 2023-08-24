//
//  ViewController.swift
//  CodingChallengeWalmart
//
//  Created by Dustin Pavy on 8/23/23.
//

import UIKit

class MyViewController: UIViewController {
    
    private let viewModel = ViewModel(repository: CountryRepository(networkManager: NetworkManager()))
    private let searchController = UISearchController()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var MyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyTableView.dataSource = self
        MyTableView.delegate = self
        
        searchBar.delegate = self
        
        let cellXib = UINib(nibName: "CustomCell", bundle: nil)
        MyTableView.register(cellXib, forCellReuseIdentifier: "CustomCell")
        
        Task{
            await getCountries()
            viewModel.countryListFiltered = viewModel.countryList
        }
    }
    
    func getCountries() async{
        await viewModel.getListFromApi()
        DispatchQueue.main.async {
            self.MyTableView.reloadData()
        }
    }
    
}

extension MyViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBar.text?.isEmpty ?? true ? viewModel.countryList.count : viewModel.countryListFiltered.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomCell else { return UITableViewCell() }
        let country = searchBar.text?.isEmpty ?? true ? viewModel.countryList[indexPath.row] : viewModel.countryListFiltered[indexPath.row]
        cell.nameAndRegion.text = "\(country.name), \(country.region)"
        cell.code.text = country.code
        cell.capital.text = country.capital
        return cell
    }
}

extension MyViewController: UITableViewDelegate{
    
}

extension MyViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.countryListFiltered = viewModel.countryList.filter { country in
            return (
                country.name.lowercased().starts(with: searchText.lowercased())
                ||
                country.capital.lowercased().starts(with: searchText.lowercased())
            )
        }
        MyTableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.countryListFiltered.removeAll()
        MyTableView.reloadData()
    }
}
