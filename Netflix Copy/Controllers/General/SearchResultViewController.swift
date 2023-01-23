//
//  SearchResultViewController.swift
//  Netflix Copy
//
//  Created by Mark Goncharov on 23.01.2023.
//

import Foundation

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewControllerTapped(_ viewModel: TitlePreviewViewModel)
}

class SearchResultViewController: UIViewController {

    public var titles: [Title] = [Title]()
    public var delegate: SearchResultViewControllerDelegate?
    
    public let searchResultCollecrtionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollecrtionView)
        
        searchResultCollecrtionView.delegate = self
        searchResultCollecrtionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultCollecrtionView.frame = view.bounds
    }
 

}


extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = searchResultCollecrtionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        let titles = titles[indexPath.row]
        cell.configure(with: titles.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? title.original_name ?? ""
        
        APICaller.shared.getYoutubeTrailer(with: titleName) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let video):
                    self?.delegate?.searchResultViewControllerTapped(TitlePreviewViewModel(title: title.original_title ?? title.original_name ?? "",
                                                                                     youtubeView: video,
                                                                                     titleOverview: title.overview ?? ""))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        

    }
    
}
