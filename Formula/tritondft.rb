class Tritondft < Formula
  include Language::Python::Virtualenv

  desc "AI-powered local-to-cluster DFT workflow agent"
  homepage "https://github.com/ktalit/TritonDFT"
  url "https://github.com/ktalit/TritonDFT.git",
      revision: "79fc4c0d93e090dce62cab99ad502d669c739dd7"
  version "0.1.0"
  revision 2

  depends_on "python@3.12"

  def install
    venv = virtualenv_create(libexec, "python3.12")
    python = Formula["python@3.12"].opt_bin/"python3.12"
    system python, "-m", "pip", "--python=#{venv.root}/bin/python", "install", buildpath
    bin.install_symlink libexec/"bin/tritondft"
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

  test do
    assert_match "TritonDFT 0.1.0", shell_output("#{bin}/tritondft --version")
  end
end
