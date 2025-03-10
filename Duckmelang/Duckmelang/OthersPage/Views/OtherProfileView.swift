//
//  OtherProfileModifyView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class OtherProfileView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
    
    let otherProfileTopView = OtherProfileTopView()
    let otherProfileBottomView = OtherProfileBottomView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addStack(){
        
    }
    
    private func setupView(){
        [otherProfileTopView, otherProfileBottomView].forEach{addSubview($0)}
        
        otherProfileTopView.snp.makeConstraints{
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview()
            $0.height.equalTo(250)//188
        }
        
        otherProfileBottomView.snp.makeConstraints{
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(otherProfileTopView.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }
}

//상단 바와 프로필, 자기소개 부분
class OtherProfileTopView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var profileData: OtherProfileData? {
        didSet {
            if let profile = profileData { //profileData가 nil이 아닐 때만 실행
                print("profileData 변경됨: \(profile)") // 확인용로그
                updateProfile(with: profile) //인스턴스를 전달
            }
        }
    }
    
    func updateProfile(with data: OtherProfileData) {
        myProfileTitle.text = "\(data.nickname) 님의 프로필"
        
        nickname.text = data.nickname
        gender.text = data.gender == "FEMALE" ? "여성" : "남성"
        age.text = "만 \(data.age)세"
        postCount.text = "\(data.postCount)"
        matchingCount.text = "\(data.matchCount)"
        selfPR.text = data.introduction
        
        //Kingfisher로 이미지 로딩 (URL이 유효한 경우만)
        if let url = URL(string: data.latestPublicMemberProfileImage) {
            profileImage.kf.setImage(
                with: url,
                placeholder: UIImage() // 로딩 전 기본 이미지
            )
        }
    }
    
    lazy var backBtn = UIButton().then {
        $0.setImage(.back, for: .normal)
    }
    
    private lazy var myProfileTitle = Label(text: "남 님의 프로필", font: .aritaSemiBoldFont(ofSize: 18), color: .black)
    
    lazy var profileImage = UIImageView().then {
        $0.image = .profile
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 64/2
        $0.clipsToBounds = true
    }
    
    private lazy var nickname = Label(text: "닉네임", font: .ptdSemiBoldFont(ofSize: 17), color: .black)
    
    private lazy var gender = Label(text: "여성", font: .ptdRegularFont(ofSize: 13), color: .grey600)
    
    private lazy var line = Label(text: "ㅣ", font: .ptdRegularFont(ofSize: 13), color: .grey400)
    
    private lazy var age = Label(text: "나이", font: .ptdRegularFont(ofSize: 13), color: .grey600)
    
    private lazy var post = Label(text: "게시글", font: .ptdRegularFont(ofSize: 12), color: .grey700)
    
    private lazy var matching = Label(text: "매칭횟수", font: .ptdRegularFont(ofSize: 12), color: .grey700)
    
    private lazy var postCount = Label(text: "80", font: .ptdSemiBoldFont(ofSize: 17), color: .grey800)
    
    private lazy var matchingCount = Label(text: "80", font: .ptdSemiBoldFont(ofSize: 17), color: .grey800)
    
    private lazy var nicknameAndInfo = Stack(axis: .vertical, spacing: 6)
    private lazy var genderAndAgeStack = Stack(axis: .horizontal, spacing: -13, distribution: .equalSpacing)
    private lazy var postStack = Stack(axis: .vertical, spacing: 4, alignment: .center)
    private lazy var matchingStack = Stack(axis: .vertical, spacing: 4, alignment: .center)
    private lazy var postMatchingStack = Stack(axis: .horizontal, spacing: 25)
    private lazy var middleView = UIView()
    
    private lazy var backView = UIView().then {
        $0.layer.borderColor = UIColor.grey200?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 7
    }
    
    private lazy var selfPR = UILabel().then {
        $0.text = "메랑이 구해요!"
        $0.font = .ptdRegularFont(ofSize: 12)
        $0.textColor = .grey800
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
    }
    
    private func addStack(){
        [gender, line, age].forEach{genderAndAgeStack.addArrangedSubview($0)}
        [nickname, genderAndAgeStack].forEach{nicknameAndInfo.addArrangedSubview($0)}
        [post, postCount].forEach{postStack.addArrangedSubview($0)}
        [matching, matchingCount].forEach{matchingStack.addArrangedSubview($0)}
        [postStack, matchingStack].forEach{postMatchingStack.addArrangedSubview($0)}
    }
        
    private func setupView(){
        [profileImage, nicknameAndInfo, postMatchingStack].forEach{middleView.addSubview($0)}
        [selfPR].forEach{backView.addSubview($0)}
        [backBtn, myProfileTitle, middleView, backView].forEach{addSubview($0)}
        
        myProfileTitle.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        backBtn.snp.makeConstraints{
            $0.centerY.equalTo(myProfileTitle.snp.centerY)
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        middleView.snp.makeConstraints{
            $0.top.equalTo(myProfileTitle.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(68)
        }
        
        profileImage.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.height.width.equalTo(68)
        }
        
        nicknameAndInfo.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.left.equalTo(profileImage.snp.right).offset(16)
        }
        
        genderAndAgeStack.snp.makeConstraints{
            $0.top.equalTo(nickname.snp.bottom).offset(6)
            $0.left.equalTo(profileImage.snp.right).offset(16)
        }
        
        postMatchingStack.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
        }
        
        backView.snp.makeConstraints{
            $0.top.equalTo(middleView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        selfPR.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(16)
        }
    }
}

//세그먼트 컨트롤부터 아래부분
class OtherProfileBottomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let segmentedControl = UISegmentedControl(items: ["업로드한 게시물", "나와의 동행 후기"]).then {
        $0.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        $0.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        $0.setBackgroundImage(UIImage(), for: .highlighted, barMetrics: .default)
        $0.setDividerImage(UIImage(), forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        
        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.grey900!,
            .font: UIFont.ptdSemiBoldFont(ofSize: 17)
        ], for: .selected)
        
        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.grey400!,
            .font: UIFont.ptdSemiBoldFont(ofSize: 17)
        ], for: .normal)
        $0.selectedSegmentIndex = 0
    }
    
    lazy var underLineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private func setupView(){
        [segmentedControl, underLineView].forEach{addSubview($0)}
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.equalTo(segmentedControl.snp.leading)
            $0.width.equalTo(segmentedControl.snp.width).multipliedBy(0.5)
            $0.height.equalTo(1)
        }
    }
}
