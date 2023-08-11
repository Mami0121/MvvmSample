//
//  MvvmSampleVC.swift
//  MVVMSample
//
//  Created by KURUMSAL on 10.08.2023.
//

import UIKit
import SnapKit
import TinyConstraints
import SDWebImage

class MvvmSampleVC: UIViewController {
    
    lazy var viewModel: PhotoListViewModel = {
            return PhotoListViewModel()
        }()
    
    private var photos: [Photo] = [Photo]()
    
    private lazy var tableView:UITableView = {
       let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        //tv.rowHeight = UITableView.automaticDimension
        //tv.estimatedRowHeight = 100
        tv.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        return tv
    }()
    
    private let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        initVM()
       
    }
    func initVM() {
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.indicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.indicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
       
        viewModel.initFetch()
    }
    

    private func setupView(){
        self.view.backgroundColor = .yellow
        self.view.addSubviews(tableView, indicator)
        setupLayout()
    }
    
    func setupLayout(){
        
       
        
        indicator.snp.makeConstraints({ make in
            make.center.equalTo(view.center)
            
        })
        tableView.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalToSuperview()
          
            make.bottom.equalToSuperview()
        })
    }
}

extension MvvmSampleVC:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150.0
        }
}

extension MvvmSampleVC:UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return  1

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
     
       }

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
//    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell else { return UITableViewCell() }
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell else {
        fatalError("Cell not exists in storyboard")
    }
    
    let cellVM = viewModel.getCellViewModel( at: indexPath )
    //cell.photoListCellViewModel = cellVM
    cell.configure(imageUrl: cellVM.imageUrl, desc: cellVM.description)
    
    return cell
}
}

