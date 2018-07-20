# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Pod2lib < Formula
  desc "iOS开发中的cocoapod管理的第三方库在打包的时候会编译一遍，特别耗时，此工具是pod二进制化的实现"
  homepage "iOS开发中的cocoapod管理的第三方库在打包的时候会编译一遍，特别耗时，此工具是pod二进制化的实现，一句命令即可把所有的pod库编译成.a .h,拖到项目中即可"
  url "https://github.com/lichanghong/pod2lib/blob/master/pod2lib-0.1.0.zip"
  sha256 "308b0e65f0903b957db50e598bd1146d4f1802dd4966da1ce7fa9edea50e84aa"
  # depends_on "cmake" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
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
