//
//  Model.swift
//  TableViewTest
//
//  Created by Yuki Shinohara on 2020/07/09.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import Foundation

enum CellModel {
    case collectionView(models: [CollectionTableCellModel], rows: Int)
    case list(models: [ListCellModel])
}

struct ListCellModel {
    let title : String
}

struct CollectionTableCellModel {
    let title : String
    let imageName : String
}
