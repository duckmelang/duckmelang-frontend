//
//  CelebSelectionViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/20/25.
//

import UIKit

protocol CelebSelectionDelegate: AnyObject {
    func didSelectCeleb(_ celeb: IdolListDTO?)
    func didTapIdolAdd()
}

enum CelebSelectionMode {
    case home
    case write
}

class CelebSelectionViewController: UIViewController {
    weak var delegate: CelebSelectionDelegate?
    var dismissCompletion: (() -> Void)?
    
    let networkService = MyPageService()
    
    var celebs: [IdolListDTO]
    var selectedCeleb: IdolListDTO?
    
    private let mode: CelebSelectionMode
    
    init(celebs: [IdolListDTO], selectedCeleb: IdolListDTO?, mode: CelebSelectionMode) {
        self.celebs = celebs
        self.selectedCeleb = selectedCeleb
        self.mode = mode // home -> 전체보기 버튼, write -> 더 찾아보기 버튼
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = celebSelectionView
        setupDelegate()
        setupActions()
        getMyIdolList()
    }
    
    private lazy var celebSelectionView = CelebSelectionView(mode: mode)
    
    private func setupActions() {
        celebSelectionView.allPostSeeBtn.addTarget(self, action: #selector(allPostSeeBtnDidTap), for: .touchUpInside)
        celebSelectionView.idolAddBtn.addTarget(self, action: #selector(idolAddBtnDidTap), for: .touchUpInside)
    }
    
    @objc
    private func allPostSeeBtnDidTap() {
        delegate?.didSelectCeleb(nil) // nil전달
        dismiss(animated: true)
    }
    
    @objc
    private func idolAddBtnDidTap() {
        dismiss(animated: true) {
            self.delegate?.didTapIdolAdd()
        }
    }
    
    private func getMyIdolList() {
        _Concurrency.Task {
            do {
                startLoading()
                
                let response = try await networkService.getIdolList().idolList
                self.celebs = response
                DispatchQueue.main.async {
                    self.celebSelectionView.collectionView.reloadData()
                }
                
                stopLoading()
            } catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
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
    func didSelectCeleb(_ celeb: IdolListDTO?) {
        delegate?.didSelectCeleb(celeb)
        dismiss(animated: true)
    }
    
    func didTapIdolAdd() {
        let vc = HomeIdolAddViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
