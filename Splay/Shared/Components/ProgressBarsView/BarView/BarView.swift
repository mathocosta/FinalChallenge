//
//  BarView.swift
//  FinalChallenge
//
//  Created by Paulo José on 06/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class BarView: UIView {

    static let height: CGFloat = 20.0

    var progressBarConstraint: NSLayoutConstraint?

    var progress: CGFloat {
        didSet {
            progressBarConstraint?.constant = -(self.frame.width * (1 - progress))
        }
    }

    lazy var goalLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var goalColor: RoundedView = {
        let view = RoundedView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(frame: CGRect, progress: CGFloat = 0.5) {
        self.progress = progress
        super.init(frame: frame)

//        self.layer.borderWidth = 1
//        self.layer.cornerRadius = 5
//        self.layer.masksToBounds = true

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        // Essa checagem é necessária pois esse método é chamado mais de uma vez (por algum motivo
        // obscuro do SDK do iOS), portanto são criadas constraints iguais mais uma vez para os mesmos
        // elementos. Dessa forma, se tentar atualizar o progresso na barra, somente a última constraint
        // será atualizada, pois foi salva na propriedade `progressBarConstraint`. Isso causa o erro "Unable
        // to simultaneously satisfy constraints". Assim, é checado se a propriedade já foi inicializada,
        // para não adicionar mais de uma vez.
//        if progressBarConstraint == nil {
//            progressBarConstraint = progressBar.rightAnchor.constraint(
//                equalTo: self.rightAnchor, constant: -(self.frame.width * (1 - progress)))
//            progressBarConstraint?.isActive = true
//        }
    }

}

extension BarView: CodeView {
    func buildViewHierarchy() {
        addSubview(goalColor)
        addSubview(goalLabel)
        addSubview(progressLabel)
    }

    func setupConstraints() {
        goalColor.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        goalColor.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        goalColor.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        goalColor.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        goalLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        goalLabel.leftAnchor.constraint(equalTo: goalColor.rightAnchor, constant: 8).isActive = true
        goalLabel.rightAnchor.constraint(equalTo: progressLabel.leftAnchor, constant: -8).isActive = true
        //goalLabel.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        goalLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        progressLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //progressLabel.leftAnchor.constraint(equalTo: goalLabel.rightAnchor, constant: 8).isActive = true
        progressLabel.widthAnchor.constraint(equalToConstant: 64).isActive = true
        progressLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        progressLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//        progressBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        progressBar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        progressBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//
//        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
////        label.heightAnchor.constraint(equalTo: progressBar.heightAnchor).isActive = true
//        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
//        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
    }

    func setupAdditionalConfiguration() {

    }

}
