//
//  CustomCell.swift
//  MVVMSample
//
//  Created by KURUMSAL on 10.08.2023.
//

import UIKit
import SnapKit
import TinyConstraints
import SDWebImage

class CustomCell: UITableViewCell {
    
    private lazy var mainImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var lblDesc1:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "AvenirNext-Medium", size: 12)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        
    }
    
    private func setupViews(){
        self.contentView.addSubviews(mainImageView, lblDesc1)
        
        setupLayout()
    }
    
    
    private func setupLayout(){
        
        mainImageView.leadingToSuperview(offset: 16)
        mainImageView.topToSuperview(offset: 8)
        mainImageView.bottomToSuperview(offset: -8)
        mainImageView.height(120)
        mainImageView.width(80)
        
        lblDesc1.snp.makeConstraints({ make in
            make.top.equalTo(mainImageView.snp.top)
            make.leading.equalTo(mainImageView.snp.trailing).offset(50)
            make.bottom.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        })
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(imageUrl :String, desc :String  ) {
        mainImageView.sd_setImage(with: URL( string: imageUrl), completed: nil)
        lblDesc1.text = desc
    }
    
}

