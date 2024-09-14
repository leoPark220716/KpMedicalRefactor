import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginController
    @FocusState private var focus: Bool
    @EnvironmentObject var errorHandler: GlobalErrorHandler
    init(appManager: NavigationRouter,errorHandler: GlobalErrorHandler){
        //        _ 는 StateObject 와 같은 속성 래퍼로 선언된 변수를 가리키는 것이다.
        _viewModel = StateObject(wrappedValue: LoginController(appManager: appManager, errorHandler: errorHandler))
    }
    var body: some View {
        VStack(spacing: 20) {
            // 헤더
            Text(PlistManager.shared.string(forKey: "app_title"))
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(Color("AccentColor"))
            //                 아이디 입력 필드
            TextField(PlistManager.shared.string(forKey: "login_hint"), text: $viewModel.id)
                .focused($focus)
                .modifier(IDFildModifier())
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(viewModel.checked ? Color.gray : Color.red, lineWidth: 1)
                )
                .padding(.horizontal)
            // 비밀번호 입력 필드
            SecureField(PlistManager.shared.string(forKey: "password_hint"), text: $viewModel.password)
                .modifier(IDFildModifier())
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(viewModel.checked ? Color.gray : Color.red, lineWidth: 1)
                )
                .padding(.horizontal)
            
            // 비밀번호 찾기
            Button(action:viewModel.searchPasswordAction){
                Text(PlistManager.shared.string(forKey: "search_password_button"))
                    .modifier(LoginSubText())
            }
            
            Button(action: viewModel.actionLoginAction) {
                Text(PlistManager.shared.string(forKey: "login_button"))
                    .modifier(LoginButton())
            }
            .padding(.horizontal)
            // 회원가입
            Button(action: viewModel.actionSignUpAction) {
                Text(PlistManager.shared.string(forKey: "sign_up_button"))
                    .modifier(LoginSubText())
            }
            .padding(.horizontal)
            Spacer()
        }
        .normalToastView(toast: $viewModel.toast)
        .padding()
        .onAppear{
            focus = true
        }
        .modifier(ErrorAlertModifier(errorHandler: errorHandler))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var errorHandler = GlobalErrorHandler()
        @StateObject var router = NavigationRouter()
        LoginView(appManager: router, errorHandler: errorHandler)
            .environmentObject(errorHandler)
    }
}
