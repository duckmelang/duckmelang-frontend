//
//  CelebSelectionView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/18/25.
//

import UIKit

protocol CelebSelectionDelegate: AnyObject {
    func didSelectCeleb(_ celeb: Celeb)
}

class CelebSelectionView: UIViewController {
    
    weak var delegate: CelebSelectionDelegate?
    var dismissCompletion: (() -> Void)?
    private var celebs: [Celeb]
    private var selectedCeleb: Celeb?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width - 40,
            height: 65
        )
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView
            .register(CelebCell.self, forCellWithReuseIdentifier: "CelebCell")
        return collectionView
    }()

    init(celebs: [Celeb], selectedCeleb: Celeb?) {
        self.celebs = celebs
        self.selectedCeleb = selectedCeleb
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }
    // 모달이 닫힐 때 `dismissCompletion` 실행
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissCompletion?()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CelebSelectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
                isSelected: celeb.name == selectedCeleb?.name
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
