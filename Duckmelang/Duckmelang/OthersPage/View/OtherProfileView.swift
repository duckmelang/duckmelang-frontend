//
//  OtherProfileModifyView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Cosmos

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
        postCount.text = "\(data.postCnt)"
        matchingCount.text = "\(data.matchCnt)"
        selfPR.text = data.introduction
        
        //Kingfisher로 이미지 로딩 (URL이 유효한 경우만)
        if let url = URL(string: data.profileImageUrl) {
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
    
    lazy var setBtn = UIButton().then {
        $0.setImage(.moreVertical, for: .normal)
    }
    
    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    
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
    private lazy var genderAndAgeStack = Stack(axis: .horizontal, spacing: 1)
    private lazy var postStack = Stack(axis: .vertical, spacing: 4, alignment: .center)
    private lazy var matchingStack = Stack(axis: .vertical, spacing: 4, alignment: .center)
    private lazy var postMatchingStack = Stack(axis: .horizontal, spacing: 25)
    private lazy var middleView = UIView()
    
    private lazy var backView = UIView().then {
        $0.layer.borderColor = UIColor.grey200?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 7
    }
    
    private lazy var selfPR = Label(text: "메랑이 구해요!", font: .ptdRegularFont(ofSize: 12), color: .grey800)
    
    // 상단바 오른쪽 버튼 누르면 나오는 버튼...? 마이페이지에선 이렇게 구현했었다.
    /*lazy var setBtnImage = UIImageView().then {
        $0.image = UIImage(resource: .menu)
        $0.isHidden = true
        $0.isUserInteractionEnabled = true
    }*/
    
    private func addStack(){
        [backBtn, myProfileTitle, setBtn].forEach{topStack.addArrangedSubview($0)}
        [gender, line, age].forEach{genderAndAgeStack.addArrangedSubview($0)}
        [nickname, genderAndAgeStack].forEach{nicknameAndInfo.addArrangedSubview($0)}
        [post, postCount].forEach{postStack.addArrangedSubview($0)}
        [matching, matchingCount].forEach{matchingStack.addArrangedSubview($0)}
        [postStack, matchingStack].forEach{postMatchingStack.addArrangedSubview($0)}
    }
        
    private func setupView(){
        [profileImage, nicknameAndInfo, postMatchingStack].forEach{middleView.addSubview($0)}
        [selfPR].forEach{backView.addSubview($0)}
        [topStack, middleView, backView].forEach{addSubview($0)}
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        middleView.snp.makeConstraints{
            $0.top.equalTo(topStack.snp.bottom).offset(10)
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
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
        
        /*
        setBtnImage.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide).inset(26)
            $0.right.equalTo(setBtn.snp.left).offset(-2.25)
            $0.height.equalTo(80)
            $0.width.equalTo(96)
        }*/
    }
}

//세그먼트 컨트롤부터 아래부분
class OtherProfileBottomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
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
    
    lazy var uploadPostView = UITableView().then {
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 106
        $0.isHidden = false
    }
    
    //변경 예정
    lazy var reviewTableView = UITableView().then {
        $0.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 72
        $0.isHidden = true
    }
    
    lazy var cosmosView = CosmosView().then {
        $0.rating = 4.8 // 평점
        $0.settings.updateOnTouch = false // 터치 비활성화 옵션
        $0.settings.fillMode = .precise // 별 채우기 모드 full(완전히), half(절반), precise(터치 및 입력한 곳까지 소수점으로)
        $0.settings.starSize = 25 // 별 크기
        $0.settings.starMargin = 6.4 // 별 간격
        
        // 이미지 변경
        // 이미지를 변경할 경우 색상은 적용되지 않는다. (색상이 들어간 이미지를 사용해야 한다.)
        $0.settings.filledImage = UIImage(resource: .star)
        $0.settings.emptyImage = UIImage(resource: .emptyStar)
    }
    
    lazy var cosmosCount = Label(text: String(cosmosView.rating), font: .ptdSemiBoldFont(ofSize: 17), color: .mainColor)
    
    private lazy var cosmosFive = Label(text: "/ 5", font: .ptdRegularFont(ofSize: 17), color: .grey600)
    
    lazy var cosmosStack = Stack(axis: .horizontal, spacing: 3)
    
    private func addStack(){
        [cosmosCount, cosmosFive].forEach{cosmosStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [segmentedControl, underLineView, uploadPostView, reviewTableView, cosmosView, cosmosStack].forEach{addSubview($0)}
        
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
        
        uploadPostView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(400)
        }
        
        cosmosView.snp.makeConstraints{
            $0.top.equalTo(segmentedControl.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        cosmosStack.snp.makeConstraints{
            $0.top.equalTo(cosmosView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        reviewTableView.snp.makeConstraints{
            $0.top.equalTo(cosmosStack.snp.bottom).offset(18)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(400)
        }
    }
}
