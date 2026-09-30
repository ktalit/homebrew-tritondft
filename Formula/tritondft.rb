class Tritondft < Formula
  desc "AI-powered local-to-cluster DFT workflow agent"
  homepage "https://github.com/ktalit/TritonDFT"
  url "https://github.com/ktalit/TritonDFT.git",
      revision: "6dc0ec6112137233dc8ec61deb7f4f6b2fd2477f"
  version "0.1.0"
  revision 5

  depends_on "python@3.12"
  depends_on "uv"

  define_method(:post_install) do
    on_macos do
      libexec.glob("lib/python3.12/site-packages/**/*.so.gz").each do |binary|
        system "/usr/bin/gunzip", binary
      end
      Keg.new(prefix).mach_o_files.each do |binary|
        system "/usr/bin/codesign", "--force", "--sign", "-", binary
      end
    end
  end

  def install
    # This third-party tap deliberately uses PyPI's platform wheels. TritonDFT's
    # scientific stack is too large for a reasonable per-user source build.
    # The environment remains private to this formula and never writes to the
    # Homebrew base Python, the system Python, or a user's Conda environment.
    python = formula_opt_bin("python@3.12")/"python3.12"
    system "uv", "venv", "--python", python, "--no-project", libexec
    system "uv", "pip", "install", "--python", libexec/"bin/python",
           "--only-binary=:all:", "--no-binary=tritondft", "--no-cache", buildpath
    # PyPI wheels are already relocatable; some do not reserve enough Mach-O
    # header padding for Homebrew to rewrite their IDs. Hide wheel extensions
    # from that pass; post_install restores and signs their original binaries.
    libexec.glob("lib/python3.12/site-packages/**/*.so").each do |binary|
      system "/usr/bin/gzip", binary
    end
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
