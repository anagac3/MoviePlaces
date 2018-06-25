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
        case productionCompany = "production company"
        case releaseYear = "release year"
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadButton: UIButton!
    
    private let pickerContainerHeight: CGFloat = 200
    private let filterArray = [FilterTypes.title, FilterTypes.director, FilterTypes.productionCompany, FilterTypes.releaseYear]
    private let movieListCellIdentifier = "movieListCell"
    
    private let interactor: MovieListInteractorProtocol
    private var movies: [Movie]?
    
    var collapseDetail: Bool = true
    
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
        configurePickerView()
        configureTableView()
        configureFilterButton()
        activityIndicator.startAnimating()
        interactor.getMovies()
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
    
    private func configureTableView() {
        //Hiding table at first
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "MovieListCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: movieListCellIdentifier)
    }
    
    private func configureFilterButton() {
        let buttonSize: CGFloat = 30
        let filterButton = UIButton(type: .custom)
        filterButton.setImage(UIImage(named:"filterIcon"), for: .normal)
        filterButton.frame  = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        filterButton.addTarget(self, action: #selector(toggleFilterOptions), for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: filterButton)
        if #available(iOS 11.0, *) {
            barButton.customView?.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            barButton.customView?.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        }
        navigationItem.setRightBarButton(barButton, animated: false)
    }
    
    private func configurePickerView() {
        //HidingContainer view at init
        pickerBottomConstraint.constant = -pickerContainerHeight
        pickerView.delegate = self
        pickerView.dataSource = self
        
        view.layoutIfNeeded()
    }
    
    @objc private func toggleFilterOptions() {
        
        //Hidden
        if (pickerBottomConstraint.constant == 0) {
            pickerBottomConstraint.constant = -pickerContainerHeight
        } else {
        //Not hidden
            pickerBottomConstraint.constant = 0
        }
        //1 second animation
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func applyFilterButtonTapped(_ sender: Any) {
        let index = pickerView.selectedRow(inComponent: 0)
        let filterType = filterArray[index]
        filterMovies(by: filterType)
        tableView.reloadData()
        toggleFilterOptions()
    }
    
    @IBAction func cancelFilterButtonTapped(_ sender: Any) {
        toggleFilterOptions()
    }
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        interactor.getMovies()
        activityIndicator.startAnimating()
        reloadButton.isHidden = true
        
    }
}

extension MovieListViewController: MovieListViewControllerDelegate {
    func successFetchedMovies(movies: [Movie]) {
        self.movies = movies
        tableView.isHidden = false
        //Initial sort by title
        filterMovies(by: .title)
        tableView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    func errorFetchingMovies(error: String) {
        reloadButton.isHidden = false
        activityIndicator.stopAnimating()
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
        let movie = movies![indexPath.row]
        Router.shared.navigate(to: .map, parameters: movie)
    }
}

extension MovieListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = filterArray[row].rawValue
        return title.capitalized
    }
}

extension MovieListViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return collapseDetail
    }
}
