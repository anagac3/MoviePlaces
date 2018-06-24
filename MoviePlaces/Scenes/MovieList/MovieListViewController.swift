//
//  MovieListViewController.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/23/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    
    enum FilterTypes: String {
        case title
        case director
        case productionCompany
        case releaseYear
    }

    @IBOutlet weak var tableView: UITableView!
    private let movieListCellIdentifier = "movieListCell"
    
    private let interactor: MovieListInteractorProtocol
    private var movies: [Movie]?
    
    init(interactor: MovieListInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    //required if using custom initializr
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        configureTableView()
        interactor.getMovies()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "MovieListCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: movieListCellIdentifier)
    }
    
    private func filterMovies(by selection: FilterTypes) {
        movies?.sort(by: { (movie1, movie2) -> Bool in
            switch (selection) {
            case .director:
                return movie1.director.lowercased() < movie2.director.lowercased()
            case .title:
                return movie1.title.lowercased() < movie2.title.lowercased()
            case .productionCompany:
                return movie1.productionCompany.lowercased() < movie2.productionCompany.lowercased()
            case .releaseYear:
                return movie1.releaseYear.lowercased() < movie2.releaseYear.lowercased()
            }
        })
    }

}

extension MovieListViewController: MovieListViewControllerDelegate {
    func successFetchedMovies(movies: [Movie]) {
        self.movies = movies
        //Initial sort by title
        filterMovies(by: .title)
        tableView.reloadData()
    }
    
    func errorFetchingMovies(error: String) {
        
    }
    
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieListCellIdentifier, for: indexPath) as! MovieListCell
    
        let movie = movies![indexPath.row]
        cell.titleLabel.text = movie.title
        cell.directorLabel.text = movie.director
        cell.productionCompanyLabel.text = movie.productionCompany
        cell.yearLabel.text = movie.releaseYear
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
