//
//  FavoriteViewController.swift
//  Dolanan
//
//  Created by Tio on 28/02/23.
//

import UIKit
import Lottie


class FavoriteViewController : UIViewController{
    
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var lottieAnimationView: LottieAnimationView!
    @IBOutlet weak var emptyView: UIStackView!
    
    private var games = [Game]()
    private var viewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        showInformation(isHidden: false)
    }
    
    private func initView(){
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil),forCellReuseIdentifier:"gameTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        observeData()
    }
    
    private func observeData(){
        viewModel.getFavoriteGames(){ (games) in
            DispatchQueue.main.async {
                self.games = games
                self.gameTableView.reloadData()
                if self.games.isEmpty { self.showInformation(isHidden: false) }
                else { self.showInformation(isHidden: true) }
            }
        }
    }
   
    private func showInformation(isHidden: Bool){
        lottieAnimationView.contentMode = .scaleAspectFit
        lottieAnimationView.loopMode = .loop
        lottieAnimationView.animationSpeed = 1.0
        lottieAnimationView.play()
        
        emptyView.isHidden = isHidden
    }
}


extension FavoriteViewController: UITableViewDataSource{
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

extension FavoriteViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "moveToDetail", sender: games[indexPath.row].id )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToDetail"{
            if let detailViewController = segue.destination as? DetailViewController{
                detailViewController.gameId = sender as? Int ?? 0
            }
        }
    }
    
}
