class Tritondft < Formula
  include Language::Python::Virtualenv

  desc "AI-powered local-to-cluster DFT workflow agent"
  homepage "https://github.com/ktalit/TritonDFT"
  url "https://github.com/ktalit/TritonDFT.git",
      revision: "6dc0ec6112137233dc8ec61deb7f4f6b2fd2477f"
  version "0.1.0"
  revision 4

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      TritonDFT was installed successfully.

      Create your private configuration:
        tritondft init

      Then edit ~/.tritondft/config.yaml and verify it with:
        tritondft doctor
    EOS
  end

  on_macos do
    def post_install
      Keg.new(prefix).mach_o_files.each do |binary|
        system "/usr/bin/codesign", "--force", "--sign", "-", binary
      end
    end
  end

  test do
    assert_match "TritonDFT 0.1.0", shell_output("#{bin}/tritondft --version")
  end
end
