import SwiftUI

struct LoginView: View {
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var checkBool: Bool = true
    @FocusState private var focus: Bool
    var body: some View {
        VStack(spacing: 20) {
            // 헤더
            Text("Medical Wallet")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(Color("AccentColor"))
            //                 아이디 입력 필드
            TextField("아이디", text: $id)
                .focused($focus)
                .modifier(IDFildModifier())
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(checkBool ? Color.gray : Color.red, lineWidth: 1)
                )
                .padding(.horizontal)
            // 비밀번호 입력 필드
            SecureField("비밀번호", text: $password)
                .modifier(IDFildModifier())
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(checkBool ? Color.gray : Color.red, lineWidth: 1)
                )
                .padding(.horizontal)
            
            // 비밀번호 찾기
            Button(action: {
                // 비밀번호 찾기 액션
            }) {
                Text("비밀번호를 잊으셨나요?")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
            // 로그인 버튼
            Button(action: {
                // 로그인 액션
            }) {
                Text("로그인")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AccentColor"))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            // 회원가입
            Button(action: {
                // 회원가입 액션
            }) {
                Text("아직 회원이 아니신가요? 가입하기")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
            
            Spacer()
        }
        .onAppear{
            focus = true
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
