import 'package:learnio/base.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1,
      appBar: AppBar(
        backgroundColor: transparent,
        elevation: 0,
        leading: iconButton(icon(Icons.arrow_back_ios_new_rounded, 20, tx1), () => popPage(context)),
      ),
      body: scroll(
        padding(
          const EdgeInsets.symmetric(horizontal: 32),
          column([
            height(40),
            text("歡迎回來", 32, fw8, tx1),
            height(8),
            text("請登入您的 Learnio 帳號以繼續學習", 16, fw4, tx2),
            height(48),
            
            _buildInputField(
              controller: _emailController,
              label: "電子郵件",
              hint: "example@email.com",
              icon: Icons.email_outlined,
            ),
            height(20),
            _buildInputField(
              controller: _passwordController,
              label: "密碼",
              hint: "請輸入您的密碼",
              icon: Icons.lock_outline_rounded,
              isPassword: true,
            ),
            
            height(12),
            row([
              spacer(),
              inkWell(text("忘記密碼？", 14, fw5, primary), () {}),
            ]),
            
            height(48),
            inkWell(
              container(
                center(text("登入", 16, fw7, tx1p)),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                radius: DesignSystem.borderL,
                color: primary,
              ),
              () {
                AuthController.instance.finishIntro(); // 先標記為看過導覽
                AuthController.instance.login();
                // 在實際應用中，登入成功後 AuthController 會觸發 main rebuild
                // 並將 home 切換為 RootPage
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            
            height(24),
            row([
              expand(container(box(), height: 1, color: bg3)),
              padding(const EdgeInsets.symmetric(horizontal: 16), text("或", 14, fw4, tx6)),
              expand(container(box(), height: 1, color: bg3)),
            ]),
            
            height(24),
            _buildSocialLogin(
              label: "使用 Google 帳號登入",
              icon: Icons.g_mobiledata_rounded,
            ),
            
            height(40),
            center(
              row([
                text("還沒有帳號？", 14, fw4, tx2),
                width(4),
                inkWell(text("立即註冊", 14, fw7, primary), () {}),
              ]),
            ),
          ], ca: caS),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return column([
      text(label, 14, fw6, tx1),
      height(10),
      container(
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: TextStyle(color: tx1, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: tx6, fontSize: 16),
            prefixIcon: Icon(icon, color: tx3, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        radius: DesignSystem.borderM,
        color: bg2,
        border: Border.all(color: bg3, width: 1),
      ),
    ], ca: caS);
  }

  Widget _buildSocialLogin({required String label, required IconData icon}) {
    return inkWell(
      container(
        row([
          Icon(icon, color: tx1, size: 24),
          width(12),
          text(label, 15, fw6, tx1),
        ], ma: maC),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        radius: DesignSystem.borderL,
        border: Border.all(color: bg3, width: 1),
        color: bg1,
      ),
      () {},
    );
  }
}
