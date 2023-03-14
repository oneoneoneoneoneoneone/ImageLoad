//
//  ViewController.swift
//  ImageLoad
//
//  Created by hana on 2023/03/02.
//

import UIKit

class ViewController: UIViewController {
    private final let cnt = 5
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 20, height: 100)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    private lazy var loadAllButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitle("Load All Images", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(loadAllButtonTap), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }

    private func setLayout(){
        [collectionView, loadAllButton].forEach{
            view.addSubview($0)
            //Frame-Based Layout x AutoLayout o
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 600).isActive = true
        
        loadAllButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10).isActive = true
        loadAllButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        loadAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    @objc func loadAllButtonTap(){
        collectionView.visibleCells.forEach{cell in
            guard let cell = cell as? CollectionViewCell else {return}
            cell.loadImage()
        }
    }

}


extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell()}
        cell.tag = indexPath.row
        
        return cell
    }
    

}
