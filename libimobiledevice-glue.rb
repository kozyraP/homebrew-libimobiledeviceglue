class LibimobiledeviceGlue < Formula
    desc "Library with common system API code for libimobiledevice projects"
    homepage "https://www.libimobiledevice.org/"
    license "LGPL-2.1-or-later"
    # Official Repo provides both a populated master and an empty main branch
    head "https://github.com/kozyraP/libimobiledevice-glue.git", branch: "master"
  
    # this is my temporary fix for being able to install libimobiledevice with --HEAD (1.3.1)
  
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
    depends_on "libplist"
  
    def install
        system "./autogen.sh" if build.head?
        system "./configure", "--disable-dependency-tracking",
                              "--disable-silent-rules",
                              "--prefix=#{prefix}"
        system "make", "install"
    end
  
    test do
      (testpath/"test.c").write <<~EOS
        #include "libimobiledevice-glue/utils.h"
        int main(int argc, char* argv[]) {
          char *uuid = generate_uuid();
          return 0;
        }
      EOS
      system ENV.cc, "test.c", "-L#{lib}", "-limobiledevice-glue-1.0", "-o", "test"
      assert_equal 0, $CHILD_STATUS.exitstatus
      system "./test"
      assert_equal 0, $CHILD_STATUS.exitstatus
    end
  end