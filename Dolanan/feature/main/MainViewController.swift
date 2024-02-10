//
//  ViewController.swift
//  Dolanan
//
//  Created by Tio on 21/02/23.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let viewModel = MainViewModel()
    private var games = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        observeData()
    }
    
    private func initView(){
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil),forCellReuseIdentifier:"gameTableViewCell")
    }
    
    
    private func observeData(){
        loadingIndicator.startAnimating()
        viewModel.getGameList { [weak self] (result) in
            switch result {
            case .success(let data):
                self?.games = data
                self?.gameTableView.reloadData()
                self?.gameTableView.isHidden = false
                self?.hideProgressView()
            case .failure(let error):
                self?.hideProgressView()
                print(error)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func hideProgressView() {
        loadingIndicator.stopAnimating()
        loadingIndicator.hidesWhenStopped = true
    }
}

extension MainViewController: UITableViewDataSource{
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

extension MainViewController: UITableViewDelegate{
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

