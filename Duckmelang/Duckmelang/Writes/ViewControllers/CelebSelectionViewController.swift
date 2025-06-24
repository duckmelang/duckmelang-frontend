//
//  CelebSelectionViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/20/25.
//

import UIKit

protocol CelebSelectionDelegate: AnyObject {
    func didSelectCeleb(_ celeb: idolDTO)
}

class CelebSelectionViewController: UIViewController {
    weak var delegate: CelebSelectionDelegate?
    var dismissCompletion: (() -> Void)?
    
    var celebs: [idolDTO]
    var selectedCeleb: idolDTO?
    
    init(celebs: [idolDTO], selectedCeleb: idolDTO?) {
        self.celebs = celebs
        self.selectedCeleb = selectedCeleb
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = celebSelectionView
        setupDelegate()
    }
    
    private lazy var celebSelectionView: CelebSelectionView = {
        let view = CelebSelectionView()
        return view
    }()
    
    private func setupDelegate() {
        celebSelectionView.collectionView.delegate = self
        celebSelectionView.collectionView.dataSource = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissCompletion?()
    }
}

extension CelebSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return celebs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CelebCell",
            for: indexPath
        ) as! CelebCell
        let celeb = celebs[indexPath.item]
        cell
            .configure(
                with: celeb,
                isSelected: celeb.idolId == selectedCeleb?.idolId
            )
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let selected = celebs[indexPath.item]
        delegate?.didSelectCeleb(selected)
        dismiss(animated: true)
    }
}

// MARK: - CelebSelectionDelegate
extension CelebSelectionViewController: CelebSelectionDelegate {
    func didSelectCeleb(_ celeb: idolDTO) {
        delegate?.didSelectCeleb(celeb)
        dismiss(animated: true)
    }
}
