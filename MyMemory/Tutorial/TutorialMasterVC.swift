//
//  TutorialMasterVC.swift
//  MyMemory
//
//  Created by Hamlit Jason on 2021/03/28.
//

import UIKit

class TutorialMasterVC: UIViewController, UIPageViewControllerDataSource{
    
    var pageVC : UIPageViewController!
    
    // 콘텐츠 뷰 컨트롤러에 들어갈 타이틀과 이미지
    var contentTitles = ["Step1","Step2","Step3","Step4"]
    var contentImages = ["Page0","Page1","Page2","Page3"]
    
    @IBAction func close(_ sender: Any) {
        let ud = UserDefaults.standard
        ud.set(true,forKey: UserInfoKey.tutorial)
        ud.synchronize()
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad(){
        
        // 페이지 뷰 컨트롤러 객체 생성하기
        self.pageVC = self.instanceTutorialVC(name:"PageVC") as? UIPageViewController //
        self.pageVC.dataSource = self // 생성된 인스턴스의 데이터소스를 셀프로 설정하여 데이터 소스 구성에 필요한 메소드가 현재의 클래스 인스턴스 자신에게 구현되어 있다는 것을 알려준다
        
        // 페이지 뷰 컨트롤러의 기본 페이지 지정
        let startContentVC = self.getContentVC(atIndex:0)!
        self.pageVC.setViewControllers([startContentVC], direction: .forward, animated : true) // 이 메소드는 페이지 뷰 컨트롤러가 실행되면 사용자의 스와이프 액션이 있기 전까지 임의의 컨텐츠 뷰를 기본값으로 출력하고 있어야 하는데, 이 기본값은 이 메소드를 통해 사용된다.
        
        // 페이지 뷰 컨트롤러의 출력 영역 지정
        self.pageVC.view.frame.origin = CGPoint(x:0, y:0)
        self.pageVC.view.frame.size.width = self.view.frame.width
        self.pageVC.view.frame.size.height = self.view.frame.height - 50 // 듀토리얼이 상단에서 50정도 덜 나와야 모달식으로 듀토리얼로 느낄거니까
        
        // 페이지 뷰 컨트롤러 마스터 뷰 컨트롤러의 자식 뷰 컨트롤러로 설정
        self.addChild(self.pageVC) // 페이지 뷰 자식 컨트롤러로 등록
        self.view.addSubview(self.pageVC.view) // 컨트롤러의 뷰를 현재의 서브 뷰로 추가한 다음
        self.pageVC.didMove(toParent: self) // 자식 뷰 컨트롤러에게 부모 뷰 컨트롤러가 바뀌었음을 알려주기
        // 3단 과정 외우기
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        /*
         현재의 컨텐츠 뷰 컨트롤러보다 앞쪽에 올 컨텐츠 뷰 컨트롤러 객체
         즉, 현재의 상태에서 앞쪽으로 스와이프 했을 때, 보여줄 컨텐츠 뷰 컨트롤러 객체
         */
        
        guard var index = (viewController as! TutorialContentsVC).pageIndex else {
            return nil
        }
        
        guard index > 0 else { // 현재의 인덱스가 맨 앞이라면 nil을 반환하고 종료
            return nil
        }
                
        index -= 1 // 현재의 인덱스에서 하나 뺌(즉, 이전페이지의 인덱스)
        return self.getContentVC(atIndex: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        /*
         현재의 컨텐츠 뷰 컨트롤러보다 뒤쪽에 올 컨텐츠 뷰 컨트롤러 객체
         즉, 현재의 상태에서 뒤쪽으로 스와이프 했을 때, 보여줄 컨텐츠 뷰 컨트롤러 객체
         */
        
        guard var index = (viewController as! TutorialContentsVC).pageIndex else {
            return nil
        }
        
        index += 1 // 현재의 인덱스에서 하나 뺌(즉, 이전페이지의 인덱스)
        
        guard index < self.contentTitles.count else { // 인덱스는 항상 배열 데이터의 크기보다 작아야 한다.
            return nil
        }
                
        
        return self.getContentVC(atIndex: index)
    }
    
    func getContentVC(atIndex idx : Int) -> UIViewController? {
        
        guard self.contentTitles.count >= idx && self.contentTitles.count > 0 else {
            // 인덱스가 데이터 배열 크기 범위를 벗어나면 nil 반환
            return nil
        }
        /*
         instanceTutorialVC 는 Utils.swift에 익스텐션으로 추가된 메소드
         */
        
        guard let cvc = self.instanceTutorialVC(name: "ContentsVC") as? TutorialContentsVC else { // ContentsVC 라는 스토리보드 아이디를 가진 뷰 컨트롤러의 인스턴스를 생성하고 캐스팅한다.
            return nil
        }
        // 콘턴츠 뷰 컨트롤러의 내용을 구성
        cvc.titleText = self.contentTitles[idx]
        cvc.imageFile = self.contentImages[idx]
        cvc.pageIndex = idx
        return cvc
    }
    
    
    // 페이지 인디케이터를 위한 메소드 - 필수
    func presentationCount(for pageViewController: UIPageViewController) -> Int { // 출력한 페이지가 모두 몇개인지
        return self.contentTitles.count
    }
    
    // 페이지 인디케이터를 위한 메소드 - 필수
    func presentationIndex(for pageViewController: UIPageViewController) -> Int { // 최초에 출력한 컨텐츠 뷰의 인덱스 번호를 알려줌
        return 0
    }
}
