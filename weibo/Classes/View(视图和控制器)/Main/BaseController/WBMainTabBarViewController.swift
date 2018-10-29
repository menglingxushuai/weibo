//
//  WBMainTabBarViewController.swift
//  weibo
//
//  Created by xiaotong on 2018/9/12.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBMainTabBarViewController: UITabBarController {
    
    private lazy var composeButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupChildControllers()
        setupComposeButton()
        setupNewfeatureView()
        
        self.delegate = self
       
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
        
        // 设置tabbar的bageNumber
        tabBar.items?[0].badgeValue = "4"
        // 设置APP的bageNumber ,从iOS8.0之后要用户授权才能使用
        UIApplication.shared.applicationIconBadgeNumber = 4
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc private func userLogin(n: Notification) {
        
        guard let path = accountFile.cz_appendDocumentDir() else {
            return
        }
        try? FileManager.default.removeItem(atPath: path)
        
        var when = DispatchTime.now()
        if n.object != nil {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录已过期,需要重新登录")
            when = DispatchTime.now() + 2
        }
        DispatchQueue.main.asyncAfter(deadline: when) {
            let nav = UINavigationController(rootViewController: WBOauthViewController())
            self.present(nav, animated: true, completion: nil)
            SVProgressHUD.setDefaultMaskType(.clear)
        }
    }
    /**
        portrait        ：竖屏，肖像
        landscape       ：横屏，风景画
     
        - 使用代码控制设备的方向，好处，可以进行单独控制
        - 设置支持方向之后，当前控制器以及子控制器都会遵循这个方向
        - 如果播放视频通常是通过 modal 展现的
     */
    // 屏幕旋转
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // FIXME:没有实现
    @objc private func composeBtnClick() {
        print("撰写微博")
        
        // 测试方向旋转
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.randomColor
        let nav = UINavigationController.init(rootViewController: vc)
        
        present(nav, animated: true, completion: nil)
    }

}

// MARK : - 新特性视图处理
extension WBMainTabBarViewController {
    
    private func setupNewfeatureView() {
        // 判断用户是否登录
        if WBNetworkManager.shared.userAccount.access_token == nil {
            return
        }
        
        let v = isNewVersion ? (UIView()) : (WBWelcomeView.welcome())
        
        print(isNewVersion)
        
        view.addSubview(v)
    }
    
    // extension 可以有 计算性属性 不会占用存储空间 类似一个函数
    private var isNewVersion: Bool {
        
        let currentVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        
        let path: String = ("version" as NSString).cz_appendDocumentDir()
        
        let sandboxVersion = (try? String(contentsOfFile: path)) ?? ""
        
        print(sandboxVersion)
        
        try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        
        return currentVersion != sandboxVersion
    }
}


// MARK : - UITabBarControllerDelegate
extension WBMainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = (childViewControllers as NSArray).index(of: viewController)
        if selectedIndex == 0 && index == selectedIndex {
            let nav = viewController as! WBMainNavController
            let vc = nav.childViewControllers[0] as! WBHomeViewController
            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -UIApplication.shared.statusBarFrame.height - 44), animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                vc.loadData()
            }
            
        }
        return !viewController.isMember(of: UIViewController.self)
    }
}
// extension 类似OC的分类，在swift中还可以用来切分代码块
// 可以把相近功能的函数放在一个extension中
// 便于代码维护
// 注意：和OC的分类一样 extension中不能自定义属性
// MARK: - 设置界面
extension WBMainTabBarViewController {
    
    private func setupComposeButton() {
        tabBar.addSubview(composeButton)
        // 设置按钮的位置
        let count = CGFloat(childViewControllers.count)
        let w = tabBar.width / count
        // CGRectInset 正数向内缩进 负数向外扩展
        composeButton.frame = tabBar.bounds.insetBy(dx: 2*w, dy: 0)
        
        // 2.设置图片
        composeButton.setImage(UIImage(named: "tabbar_compose_icon_add"), for: UIControlState.normal)
        composeButton.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: UIControlState.highlighted)
        // 3.设置背景图片
        composeButton.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: UIControlState.normal)
        composeButton.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: UIControlState.highlighted)
        // 4.监听加号按钮点击
        composeButton.addTarget(self, action: #selector(composeBtnClick), for: .touchUpInside)
    }
    
    /// 设置所有子控制器
    private func setupChildControllers() {
        // 从bundle加载配置的json
        guard
            let path = Bundle.main.path(forResource: "main.json", ofType: nil),
            let data = NSData(contentsOfFile: path),
            let array = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [[String: Any]]
        else {
                return
        }
        
        var arrayM = [UIViewController]()

        for dict in array! {
            arrayM.append(controller(dict: dict))
        }
        
        viewControllers = arrayM
    }
    
    private func controller(dict: [String: Any]) -> UIViewController {
        
        guard
            let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? WBBaseViewController.Type,
        let visitorInfo = dict["visitorInfo"] as? [String: String]
            else {
                return UIViewController()
        }
        
        let vc = cls.init();
        vc.visitorInfoDict = visitorInfo
        vc.title = title;
        vc.tabBarItem.image = UIImage(named: "tabbar_"+imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_"+imageName+"_highlighted")?.withRenderingMode(.alwaysOriginal)
    vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.orange], for: .highlighted)
    vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12)], for: .normal)
        let nav = WBMainNavController(rootViewController: vc)
        return nav
    }
    
    
}
