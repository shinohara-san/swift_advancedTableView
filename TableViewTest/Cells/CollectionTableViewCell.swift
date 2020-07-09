//
//  CollectionTableViewCell.swift
//  TableViewTest
//
//  Created by Yuki Shinohara on 2020/07/09.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

protocol CollectionTableViewCellDelegate: AnyObject {
    func didSelectItem(with model: CollectionTableCellModel)
}

class CollectionTableViewCell: UITableViewCell {
    
    public weak var delegate: CollectionTableViewCellDelegate?
    
    static let identifier = "CollectionTableViewCell"
    
    private var models = [CollectionTableCellModel]()
    
    private let collectionView: UICollectionView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 170, height: 170)
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(TableCollectionViewCell.self, forCellWithReuseIdentifier: TableCollectionViewCell.identifier) //collectionViewにtableViewを使用する
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        contentView.addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with models: [CollectionTableCellModel]){
        self.models = models
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension CollectionTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableCollectionViewCell.identifier, for: indexPath) as! TableCollectionViewCell
        //collectionViewのcellでtableViewを使う
        cell.configure(with: model)
        //configure()でlabelとimageviewにこのmodelのデータを入れている
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = models[indexPath.row] //このmodelを使うために
        delegate?.didSelectItem(with: model) //delegate.didSelectItemを作った？
        //CollectionTableViewCellのdidSelectItemAtでselectしたmodelを取得してprint
    }
    
    
}
