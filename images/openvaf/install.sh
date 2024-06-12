#!/bin/bash

set -ex

REPO_COMMIT_SHORT=$(echo "$OPENVAF_REPO_COMMIT" | cut -c 1-7)

compile_binary () {
    git clone --filter=blob:none "${OPENVAF_REPO_URL}" "${OPENVAF_NAME}"
    cd "${OPENVAF_NAME}"
    git checkout "${OPENVAF_REPO_COMMIT}"

    # LLVM compile (needs LLVM 15 or 16)

    # FIXME patching OpenVAF until PR is merged
    patch -p1 << EOF
diff --git a/openvaf/target/build.rs b/openvaf/target/build.rs
index 13db6e5..dada68e 100644
--- a/openvaf/target/build.rs
+++ b/openvaf/target/build.rs
@@ -36,7 +36,7 @@ fn gen_msvcrt_importlib(sh: &Shell, arch: &str, target: &str, check: bool) {
     let ucrt_obj = out_dir.join(format!("ucrt_{arch}.obj"));
     cmd!(
         sh,
-        "clang-cl /c /Zl /GS- /clang:--target={target}-pc-windows-msvc /clang:-o{ucrt_obj} {ucrt_src}"
+        "clang -c -fno-autolink -fno-stack-protector --target={target}-pc-windows-msvc -o{ucrt_obj} {ucrt_src}"
     )
     .run()
     .expect("ucrt compilation succeeds");
EOF

    cargo build --release --bin openvaf

    mkdir -p  "/${TOOLS}/${OPENVAF_NAME}/${REPO_COMMIT_SHORT}/bin"
    cp target/release/openvaf "/${TOOLS}/${OPENVAF_NAME}/${REPO_COMMIT_SHORT}/bin"
    ln -s "/${TOOLS}/${OPENVAF_NAME}/${REPO_COMMIT_SHORT}/bin/openvaf" /usr/local/bin
}


download_binary () {
    wget "$OPENVAF_DOWNLOAD"
    OPENVAF_BASENAME=$(basename "$OPENVAF_DOWNLOAD" .tar.gz)
    tar -xvf "${OPENVAF_BASENAME}.tar.gz"

    mkdir -p  "/${TOOLS}/${OPENVAF_NAME}/${OPENVAF_BASENAME}/bin"
    cp openvaf "/${TOOLS}/${OPENVAF_NAME}/${OPENVAF_BASENAME}/bin"
    ln -s "/${TOOLS}/${OPENVAF_NAME}/${OPENVAF_BASENAME}/bin/openvaf" /usr/local/bin
}


download_binary
