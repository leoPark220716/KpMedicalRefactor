import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginController
    @FocusState private var focus: Bool
    
    init(router: NavigationRouter){
    _viewModel = StateObject(wrappedValue: LoginController(router: router))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 헤더
            Text("Medical Wallet")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(Color("AccentColor"))
            //                 아이디 입력 필드
            TextField("아이디", text: $viewModel.id)
                .focused($focus)
                .modifier(IDFildModifier())
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(viewModel.checked ? Color.gray : Color.red, lineWidth: 1)
                )
                .padding(.horizontal)
            // 비밀번호 입력 필드
            SecureField("비밀번호", text: $viewModel.password)
                .modifier(IDFildModifier())
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(viewModel.checked ? Color.gray : Color.red, lineWidth: 1)
                )
                .padding(.horizontal)
            
            // 비밀번호 찾기
            Button(action:viewModel.searchPasswordAction){
                Text("비밀번호를 잊으셨나요?")
                    .modifier(LoginSubText())
            }
            
            Button(action: viewModel.actionLoginAction) {
                Text("로그인")
                    .modifier(LoginButton())
            }
            .padding(.horizontal)
            // 회원가입
            Button(action: viewModel.actionLoginAction) {
                Text("아직 회원이 아니신가요? 가입하기")
                    .modifier(LoginSubText())
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .normalToastView(toast: $viewModel.toast)
        .padding()
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .onAppear{
            focus = true
        }
        
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var router = NavigationRouter()
        LoginView(router: router)
    }
}
