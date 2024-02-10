//
//  DetailViewController.swift
//  Dolanan
//
//  Created by Tio on 21/02/23.
//

import UIKit
import SnackBar

class DetailViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ivGamePhoto: UIImageView!
    @IBOutlet weak var labelGameName: UILabel!
    @IBOutlet weak var labelGameRating: UILabel!
    @IBOutlet weak var labelGameRatingCount: UILabel!
    @IBOutlet weak var labelGameDescription: UILabel!
    @IBOutlet weak var collectionScreenshots: UICollectionView!
    
    
    var gameId = 0
    var gameDetail : Game?
    var screenshots = [ScreenshotResponse]()
    private var isFavorite = false
    
    private let viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeData()
        checkFavorite()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.layoutIfNeeded()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.parentView.frame.size.height)
    }
    
    private func observeData(){
        guard gameId != 0 else {
            return
        }
        contentView.isHidden = true
        loadingIndicator.startAnimating()
        self.collectionScreenshots.dataSource = self
        viewModel.getGameDetail(id: gameId) { (result) in
            switch result {
            case .success(let game): self.setupGame(game: game)
            case .failure(let error):  print("Error on: \(error.localizedDescription)")
            }
        }
        
        viewModel.getGameScreenshots(id: gameId) { result in
            switch result {
            case .success(let screenshots): self.setupScreenshots(screenshots: screenshots)
            case.failure(let error): print(error)
            }
        }
    }
    
    private func checkFavorite(){
        guard gameId != 0 else {
            return
        }
        viewModel.isGameFavorite(gameId){ (isFavorite) in
            self.isFavorite = isFavorite
            DispatchQueue.main.async { self.setIconFavorite() }
        }
    }
    
    private func setupScreenshots(screenshots:[ScreenshotResponse]) {
        self.screenshots = screenshots
        self.collectionScreenshots.reloadData()
    }
    
    private func setupGame(game: Game) {
        contentView.isHidden = false
        hideProgressView()
        gameDetail = game
        
        ivGamePhoto.setKfImage(url: game.gamePosterUrl)
        labelGameName.text = game.name
        labelGameRating.text = game.gameRatingText
        labelGameRatingCount.text = game.gameRatingCount
        labelGameDescription.text = game.description
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.moreNavigationController.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.moreNavigationController.setNavigationBarHidden(false, animated: animated)
    }
    
    private func hideProgressView() {
        loadingIndicator.stopAnimating()
        loadingIndicator.hidesWhenStopped = true
    }
    
    
    @IBAction func onButtonFavClicked(_ sender: Any) {
        if isFavorite {
            if(gameId != 0){
                viewModel.removeFromFavorite(gameId){
                    DispatchQueue.main.async {
                        self.showSnackBar("Game deleted from favorite")
                    }
                }
            }
        } else {
            guard let addGameFavorite = gameDetail else { return }
            viewModel.addToFavorite(addGameFavorite){
                DispatchQueue.main.async {
                    self.showSnackBar("Game added to favorite")
                }
            }
            
        }
        isFavorite = !isFavorite
        setIconFavorite()
    }
    
    
    private func setIconFavorite() {
        if isFavorite {
            navigationItem.rightBarButtonItem = favoriteActive
        } else {
            navigationItem.rightBarButtonItem = favoriteDeactivated
        }
    }
    
    private lazy var favoriteDeactivated: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(self.onButtonFavClicked))
        btn.tintColor = UIColor.darkGray
        return btn
    }()
    
    private lazy var favoriteActive: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(self.onButtonFavClicked))
        btn.tintColor = UIColor.activeTint
        return btn
    }()
    
    private func showSnackBar(_ message: String){
        SnackBar.make(in: self.view, message: message, duration: .lengthShort).show()
    }
    
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.screenshots.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenshotsCell", for: indexPath) as! ScreenshotsCollectionViewCell
        cell.setImage(url: URL(string: (screenshots[indexPath.row].image)))
        return cell
    }
}
