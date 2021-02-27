//
//  FavoritesTableViewCell.swift
//  Motivation
//
//  Created by Atahan Sahlan on 20/10/2020.
//

import UIKit
import WidgetKit
import SwiftUI

class FavoritesTableViewCell: UITableViewCell {
    var  widgetView = UIHostingController(rootView: WidgetView( Number: 0, Type: 1))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "WidgetCell")
      
   
    }
    func set(Text: String, Author:String, BackroundColor: Gradient, TextColor: UIColor, Number: Int, Type: Int){
        widgetView = UIHostingController(rootView: WidgetView(Text: Text,Author: Author, TextColor: TextColor, BackroundColor: BackroundColor, Number: Number, Type: Type))
        addSubview(widgetView.view)
        widgetView.view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        widgetView.view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        widgetView.view.translatesAutoresizingMaskIntoConstraints = false
        widgetView.view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        widgetView.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        widgetView.view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        widgetView.view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
