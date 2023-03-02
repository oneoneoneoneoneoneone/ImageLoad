//
//  ViewController.swift
//  ImageLoad
//
//  Created by hana on 2023/03/02.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    final let cnt = 5
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    lazy var loadAllButton: UIButton = {
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

    func setLayout(){
        [collectionView, loadAllButton].forEach{
            view.addSubview($0)
        }
        
        collectionView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview().inset(10)
        }
        
        loadAllButton.snp.makeConstraints{
            $0.top.equalTo(collectionView.snp.bottom)
            $0.leading.trailing.equalTo(collectionView)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    @objc func loadAllButtonTap(){
        collectionView.visibleCells.forEach{cell in
            guard let cell = cell as? CollectionViewCell else {return}
            cell.loadImage(row: cell.tag)
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
