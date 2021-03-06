class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"

  stable do
    url "https://github.com/minetest/minetest/archive/5.1.0.tar.gz"
    sha256 "ca53975eecf6a39383040658f41d697c8d7f8d5fe9176460f564979c73b53906"

    # This patch is already merged in master and it should be removed when new version of mintest is released
    patch do
      url "https://github.com/minetest/minetest/pull/9064.patch?full_index=1"
      sha256 "78c5148ae5260bf2220ca18849c698e92c93e1c92b8f287135b293457c9ab6cd"
    end

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/5.1.0.tar.gz"
      sha256 "f165fac0081bf4797cf9094282cc25034b2347b3ea94e6bb8d9329c5ee63f41b"
    end
  end

  bottle do
    sha256 "e6774d4217375c164de190acccfbc208ca7c9e5a491b0584450090ea7d393b65" => :catalina
    sha256 "656842e7896dcc6458522201d9a6ec2ccd6f09daf249a1145387122c52af74bb" => :mojave
    sha256 "cebe39a206ec1d950d8c3e77b94d2b8e4f1953350d9b0ae5ece220de082f531c" => :high_sierra
  end

  head do
    url "https://github.com/minetest/minetest.git"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game.git", :branch => "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "irrlicht"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "luajit"

  def install
    (buildpath/"games/minetest_game").install resource("minetest_game")

    args = std_cmake_args - %w[-DCMAKE_BUILD_TYPE=None]
    args << "-DCMAKE_BUILD_TYPE=Release" << "-DBUILD_CLIENT=1" << "-DBUILD_SERVER=0"
    args << "-DENABLE_FREETYPE=1" << "-DCMAKE_EXE_LINKER_FLAGS='-L#{Formula["freetype"].opt_lib}'"
    args << "-DENABLE_GETTEXT=1" << "-DCUSTOM_GETTEXT_PATH=#{Formula["gettext"].opt_prefix}"

    system "cmake", ".", *args
    system "make", "package"
    system "unzip", "minetest-*-osx.zip"
    prefix.install "minetest.app"
  end

  def caveats
    <<~EOS
      Put additional subgames and mods into "games" and "mods" folders under
      "~/Library/Application Support/minetest/", respectively (you may have
      to create those folders first).

      If you would like to start the Minetest server from a terminal, run
      "/Applications/minetest.app/Contents/MacOS/minetest --server".
    EOS
  end
end
