//
//  ViewController.swift
//  TableViewTest
//
//  Created by Yuki Shinohara on 2020/07/09.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import AVFoundation //videoを再生する用

class ViewController: UIViewController {
    
    //全体の基礎部分
    private let table:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        //groupedでcollectionとlistを分けている
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //下半分のtableView
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
    }()
    
    private var models = [CellModel]()
    //CellModelはenumで2つケースを持っている。switchで条件分岐。
    //よって1つの配列だけで済む？

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpModels()
        
        view.addSubview(table) //tableを配置する
        table.tableHeaderView = createTableHeader() //header(ビデオ部分)を配置する
        table.delegate = self
        table.dataSource = self
    }
    
    private func createTableHeader() -> UIView?{
        guard let path = Bundle.main.path(forResource: "test", ofType: "mp4") else {
            //https://yuu.1000quu.com/points_to_note_when_acquiring_files_with_swift
            return nil}
        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url: url)
        player.volume = 0
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = headerView.bounds
        headerView.layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resizeAspectFill
        player.play()
        
        return headerView
    }
    
    private func setUpModels(){
        //append()の()で.を入力するとenum CellModelの2つのcaseが表示される
        //modelがCellModelの配列であり、CellModelは2つのcaseから成る
        models.append(.collectionView(models: [
            CollectionTableCellModel(title: "Image-1",
                                     imageName: "Image-1"),
            CollectionTableCellModel(title: "Image-2",
                                     imageName: "Image-2"),
            CollectionTableCellModel(title: "Image-3",
                                     imageName: "Image-3"),
            CollectionTableCellModel(title: "Image-4",
                                     imageName: "Image-4"),
            CollectionTableCellModel(title: "Image-5",
                                     imageName: "Image-5"),
            CollectionTableCellModel(title: "Image-6",
                                     imageName: "Image-6"),
            CollectionTableCellModel(title: "Image-7",
                                     imageName: "Image-7")],
            rows: 1))
        
        models.append(.list(models: [
            ListCellModel(title: "test"),
            ListCellModel(title: "test"),
            ListCellModel(title: "test"),
            ListCellModel(title: "test"),
            ListCellModel(title: "test")
        ]))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count //=2 写真rowとリストrow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch models[section]{
        case .collectionView(_, _):
            return 1 //2以上だと同じ写真の列が複製される heightForRowAtで高さを調整してくれる
        case .list(models: let models):
            return models.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch models[indexPath.section]{
            
        case .collectionView(let models, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as! CollectionTableViewCell
            cell.configure(with: models)
            //このcellはCollectionTableViewCellだからconfigureもdelegateも使える
            cell.delegate = self //CollectionTableViewCellで作ったdelegate
            return cell
            
        case .list(models: let models):
            let model = models[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = model.title
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //セルをタップしたら選択が消える
        print("VC didSelectRowAt")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch models[indexPath.section]{
        case .collectionView(_, let rows): return 180 * CGFloat(rows)
        case .list(_): return 50
        }
    }
    
}

extension ViewController: CollectionTableViewCellDelegate{
    func didSelectItem(with model: CollectionTableCellModel) {
        print("Selected model : \(model.title)")
        //CollectionTableViewCellのdidSelectItemAtでselectしたmodelを取得してprint
        //このdelegateのおかげでCollectionTableViewCellとつながっている
    }
    
    
}
