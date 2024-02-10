//
//  SearchViewController.swift
//  Dolanan
//
//  Created by Tio on 28/02/23.
//

import UIKit
import Lottie

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lottieAnimationView: LottieAnimationView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var emptyView: UIStackView!
    
    private let viewModel = MainViewModel()
    private var games = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        showInformation(isHidden: false)
    }
    
    private func initView(){
        searchBar.delegate = self
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil),forCellReuseIdentifier:"gameTableViewCell")
    }
    
    
    private func searchData(query: String){
        loadingIndicator.startAnimating()
        dismissKeyboard()
        showInformation(isHidden: true)
        viewModel.getGameList(query: query) { [weak self] (result) in
            switch result {
            case .success(let data):
                self?.games = data
                self?.gameTableView.reloadData()
                self?.gameTableView.isHidden = false
                self?.hideProgressView()
                self?.showInformation(isHidden: !(data.isEmpty), information: "Sorry, the game you're looking for was not found")
                
            case .failure(let error):
                self?.hideProgressView()
                self?.showInformation(isHidden: false, information: "Sorry, the game you're looking for was not found")
                print(error)
            }
        }
    }
    
    private func hideProgressView() {
        loadingIndicator.stopAnimating()
        loadingIndicator.hidesWhenStopped = true
    }
    
    
    private func showInformation(isHidden: Bool, information: String = "No game found"){
        lottieAnimationView.contentMode = .scaleAspectFit
        lottieAnimationView.loopMode = .loop
        lottieAnimationView.animationSpeed = 1.0
        lottieAnimationView.play()
        
        informationLabel.text = information
        emptyView.isHidden = isHidden
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.gameTableView.isHidden = true
        searchData(query: searchBar.text ?? "")
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        dismissKeyboard()
    }
}


extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "gameTableViewCell", for: indexPath)
            as? GameTableViewCell {
            cell.setupData(game: games[indexPath.row])
            return cell
            
        }else {
            return UITableViewCell()
        }
    }
}

extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "moveToDetail", sender: games[indexPath.row].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToDetail"{
            if let detailViewController = segue.destination as? DetailViewController{
                detailViewController.gameId = sender as? Int ?? 0
            }
        }
    }
    
}
