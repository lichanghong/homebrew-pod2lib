# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Pod2lib < Formula
  desc "李长鸿"
  homepage "pod2lib转换"
  url "https://github.com/lichanghong/homebrew-pod2lib/raw/master/Formula/pod2lib-0.1.0.tar.gz"
  sha256 "73e7eb4d48632a0e76c6004bd2a6a7265b616ad7c283739f6740e13b65ea6d74"
  # depends_on "cmake" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    #system "make", "install" # if this fails, try separate make/make install steps
	bin.install "function.sh" , "pod2lib"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test pod2lib`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
