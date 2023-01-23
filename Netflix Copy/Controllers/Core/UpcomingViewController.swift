//
//  UpcomingViewController.swift
//  Netflix Copy
//
//  Created by Mark Goncharov on 23.01.2023.
//

import UIKit

class UpcomingViewController: UIViewController {

    private var titles: [Title] = [Title]()

    private let upcomingTableView: UITableView = {
        
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Upcoming"
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTableView)
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        
        getUpcomingMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upcomingTableView.frame = view.bounds
    }
 
    func getUpcomingMovies() {
        
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {

            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = upcomingTableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath)
                as? TitleTableViewCell  else { return UITableViewCell() }
        
        let titles = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: titles.original_title ?? titles.original_name ?? "Unknow",
                                            posterUrl: titles.poster_path ?? ""))
        return cell
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        
        APICaller.shared.getYoutubeTrailer(with: titleName) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let video):
                    
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: video, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
